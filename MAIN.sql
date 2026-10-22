-- ==========================================
-- LOANCOIN MORTGAGE PLATFORM - MAIN SCHEMA
-- All tables in execution order
-- ==========================================

-- ==========================================
-- LOAN TYPE LOOKUP
-- ==========================================

CREATE TABLE loan_type (
    loan_type_id BIGSERIAL PRIMARY KEY,
    loan_type_code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==========================================
-- LOAN
-- Immutable Origination Data
-- ==========================================

CREATE TABLE loan (
    loan_id BIGSERIAL PRIMARY KEY,
    loan_number VARCHAR(50) NOT NULL UNIQUE,
    loan_type_id BIGINT NOT NULL
        REFERENCES loan_type(loan_type_id),
    origination_date DATE NOT NULL,
    first_payment_date DATE,
    original_maturity_date DATE NOT NULL,
    original_balance NUMERIC(14,2) NOT NULL
        CHECK (original_balance >= 0),
    original_term_months INTEGER NOT NULL
        CHECK (original_term_months > 0),
    interest_calculation_method VARCHAR(20) NOT NULL
        CHECK (interest_calculation_method IN ('FIXED', 'ARM', 'BALLOON', 'INTEREST_ONLY')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==========================================
-- BORROWER DETAILS
-- ==========================================

CREATE TABLE borrower_details (
    borrower_id BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    ssn_encrypted VARCHAR(255),
    date_of_birth DATE,
    email_address VARCHAR(100),
    phone_number VARCHAR(20),
    mailing_street_address VARCHAR(255) NOT NULL,
    mailing_city VARCHAR(100) NOT NULL,
    mailing_state VARCHAR(2) NOT NULL,
    mailing_zip_code VARCHAR(10) NOT NULL,
    mailing_country VARCHAR(2) NOT NULL DEFAULT 'US',
    employment_status VARCHAR(50)
        CHECK (employment_status IN ('EMPLOYED', 'SELF_EMPLOYED', 'RETIRED', 'DISABLED', 'UNEMPLOYED')),
    employer_name VARCHAR(255),
    job_title VARCHAR(100),
    years_employed INTEGER,
    annual_income NUMERIC(12,2),
    credit_score INTEGER,
    citizenship_status VARCHAR(50)
        CHECK (citizenship_status IN ('US_CITIZEN', 'PERMANENT_RESIDENT', 'NON_RESIDENT')),
    marital_status VARCHAR(20),
    num_dependents INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_borrower_email ON borrower_details(email_address);
CREATE INDEX idx_borrower_name ON borrower_details(last_name, first_name);

-- ==========================================
-- LOAN_BORROWER
-- Links borrowers to loans with their position on that specific loan
-- ==========================================

CREATE TABLE loan_borrower (
    loan_borrower_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),
    borrower_id BIGINT NOT NULL
        REFERENCES borrower_details(borrower_id),
    borrower_position VARCHAR(50) NOT NULL
        CHECK (borrower_position IN ('PRIMARY', 'CO_BORROWER', 'GUARANTOR')),
    liability_percentage NUMERIC(5,2)
        CHECK (liability_percentage > 0 AND liability_percentage <= 100),
    is_primary_liable BOOLEAN NOT NULL DEFAULT FALSE,
    signed_date DATE,
    has_signed BOOLEAN NOT NULL DEFAULT FALSE,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loan_borrower_loan_id ON loan_borrower(loan_id);
CREATE INDEX idx_loan_borrower_borrower_id ON loan_borrower(borrower_id);
CREATE INDEX idx_loan_borrower_position ON loan_borrower(borrower_position);
CREATE UNIQUE INDEX idx_loan_borrower_primary ON loan_borrower(loan_id) WHERE borrower_position = 'PRIMARY';

-- ==========================================
-- PROPERTY
-- Property details for loans (one loan can have one property)
-- ==========================================

CREATE TABLE property (
    property_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL UNIQUE
        REFERENCES loan(loan_id),
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    country VARCHAR(2) NOT NULL DEFAULT 'US',
    county VARCHAR(100),
    property_type VARCHAR(50)
        CHECK (property_type IN ('SINGLE_FAMILY', 'CONDO', 'TOWNHOUSE', 'MULTI_UNIT', 'MANUFACTURED', 'LAND', 'COMMERCIAL')),
    square_feet INTEGER,
    lot_size_sqft INTEGER,
    year_built INTEGER,
    num_bedrooms INTEGER,
    num_bathrooms NUMERIC(3,1),
    occupancy_status VARCHAR(50) NOT NULL
        CHECK (occupancy_status IN ('PRIMARY_RESIDENCE', 'SECOND_HOME', 'INVESTMENT_PROPERTY')),
    condition_rating VARCHAR(50)
        CHECK (condition_rating IN ('EXCELLENT', 'GOOD', 'FAIR', 'POOR')),
    parcel_number VARCHAR(50),
    legal_description TEXT,
    has_garage BOOLEAN,
    garage_spaces INTEGER,
    has_pool BOOLEAN,
    has_patio BOOLEAN,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_property_loan_id ON property(loan_id);
CREATE INDEX idx_property_address ON property(city, state);

-- ==========================================
-- VALUATIONS
-- Property valuations and appraisals
-- ==========================================

CREATE TABLE valuations (
    valuation_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),
    property_id BIGINT NOT NULL
        REFERENCES property(property_id),
    valuation_type VARCHAR(50) NOT NULL
        CHECK (valuation_type IN ('APPRAISAL', 'AVM', 'BROKER_PRICE_OPINION', 'AUTOMATED_VALUATION', 'DESK_REVIEW')),
    property_value NUMERIC(14,2) NOT NULL
        CHECK (property_value > 0),
    original_property_value NUMERIC(14,2),
    current_loan_balance NUMERIC(14,2),
    loan_to_value NUMERIC(5,2) NOT NULL
        CHECK (loan_to_value > 0 AND loan_to_value <= 125),
    valuation_date DATE NOT NULL,
    appraiser_name VARCHAR(255),
    appraiser_license_number VARCHAR(50),
    market_conditions_description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_valuations_loan_id ON valuations(loan_id);
CREATE INDEX idx_valuations_property_id ON valuations(property_id);
CREATE INDEX idx_valuations_date ON valuations(valuation_date);

-- ==========================================
-- COMPARABLES
-- Comparable property sales data for valuations
-- ==========================================

CREATE TABLE comparables (
    comparable_id BIGSERIAL PRIMARY KEY,
    valuation_id BIGINT NOT NULL
        REFERENCES valuations(valuation_id),
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    country VARCHAR(2) NOT NULL DEFAULT 'US',
    latitude NUMERIC(10,8),
    longitude NUMERIC(11,8),
    property_type VARCHAR(50)
        CHECK (property_type IN ('SINGLE_FAMILY', 'CONDO', 'TOWNHOUSE', 'MULTI_UNIT', 'MANUFACTURED', 'LAND', 'COMMERCIAL')),
    square_feet INTEGER,
    lot_size_sqft INTEGER,
    year_built INTEGER,
    num_bedrooms INTEGER,
    num_bathrooms NUMERIC(3,1),
    sale_price NUMERIC(14,2) NOT NULL
        CHECK (sale_price > 0),
    sale_date DATE NOT NULL,
    days_on_market INTEGER,
    condition_rating VARCHAR(50)
        CHECK (condition_rating IN ('EXCELLENT', 'GOOD', 'FAIR', 'POOR')),
    mls_number VARCHAR(50),
    data_source VARCHAR(100),
    price_per_sqft NUMERIC(10,2),
    price_per_lot_sqft NUMERIC(10,2),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_comparables_valuation_id ON comparables(valuation_id);
CREATE INDEX idx_comparables_geo ON comparables(latitude, longitude);

-- ==========================================
-- ESCROW
-- Holds funds for taxes, insurance, and other expenses
-- ==========================================

CREATE TABLE escrow (
    escrow_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),
    escrow_type VARCHAR(50) NOT NULL
        CHECK (escrow_type IN ('PROPERTY_TAX', 'HOMEOWNERS_INSURANCE', 'MORTGAGE_INSURANCE', 'HOA_FEES', 'OTHER')),
    description VARCHAR(255),
    monthly_payment_amount NUMERIC(10,2) NOT NULL
        CHECK (monthly_payment_amount > 0),
    due_date DATE NOT NULL,
    paid_date DATE,
    next_payment_date DATE,
    recipient_name VARCHAR(255) NOT NULL,
    recipient_address VARCHAR(255),
    recipient_city VARCHAR(100),
    recipient_state VARCHAR(2),
    recipient_zip_code VARCHAR(10),
    recipient_country VARCHAR(2) DEFAULT 'US',
    recipient_email VARCHAR(100),
    recipient_phone VARCHAR(20),
    recipient_account_number VARCHAR(100),
    recipient_tax_id VARCHAR(50),
    payment_status VARCHAR(50) NOT NULL DEFAULT 'PENDING'
        CHECK (payment_status IN ('PENDING', 'PAID', 'PARTIALLY_PAID', 'OVERDUE', 'CANCELLED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_escrow_loan_id ON escrow(loan_id);
CREATE INDEX idx_escrow_due_date ON escrow(due_date);

-- ==========================================
-- INVESTOR
-- Loan investors/investors and ownership information
-- ==========================================

CREATE TABLE investor (
    investor_id BIGSERIAL PRIMARY KEY,
    investor_name VARCHAR(255) NOT NULL UNIQUE,
    investor_type VARCHAR(50) NOT NULL
        CHECK (investor_type IN ('BANK', 'CREDIT_UNION', 'INSURANCE_COMPANY', 'PENSION_FUND', 'HEDGE_FUND', 'INDIVIDUAL', 'OTHER')),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    street_address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    country VARCHAR(2) DEFAULT 'US',
    tax_id VARCHAR(50),
    registration_number VARCHAR(50),
    mlo_license_number VARCHAR(50),
    broker_dealer_license VARCHAR(50),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_approved BOOLEAN NOT NULL DEFAULT FALSE,
    approval_date DATE,
    credit_rating VARCHAR(10),
    risk_level VARCHAR(20)
        CHECK (risk_level IN ('LOW', 'MEDIUM', 'HIGH', 'UNRATED')),
    parent_company_id BIGINT
        REFERENCES investor(investor_id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_investor_type ON investor(investor_type);
CREATE INDEX idx_investor_active ON investor(is_active);

-- ==========================================
-- LOAN_INVESTOR_ASSIGNMENT
-- Links loans to investors (enables multiple investors per loan)
-- ==========================================

CREATE TABLE loan_investor_assignment (
    assignment_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),
    investor_id BIGINT NOT NULL
        REFERENCES investor(investor_id),
    assignment_date DATE NOT NULL,
    ownership_percentage NUMERIC(5,2) NOT NULL
        CHECK (ownership_percentage > 0 AND ownership_percentage <= 100),
    assigned_principal_balance NUMERIC(14,2) NOT NULL,
    assignment_type VARCHAR(50)
        CHECK (assignment_type IN ('ORIGINATION', 'SALE', 'TRANSFER', 'SYNDICATION')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loan_investor_assignment_loan_id ON loan_investor_assignment(loan_id);
CREATE INDEX idx_loan_investor_assignment_investor_id ON loan_investor_assignment(investor_id);
CREATE UNIQUE INDEX idx_loan_investor_unique ON loan_investor_assignment(loan_id, investor_id) WHERE is_active = TRUE;

-- ==========================================
-- INSURER
-- Mortgage insurance providers
-- ==========================================

CREATE TABLE insurer (
    insurer_id BIGSERIAL PRIMARY KEY,
    insurer_name VARCHAR(255) NOT NULL UNIQUE,
    insurer_type VARCHAR(50) NOT NULL
        CHECK (insurer_type IN ('FHA', 'USDA', 'VA', 'PMI_PROVIDER', 'OTHER')),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    street_address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    country VARCHAR(2) DEFAULT 'US',
    tax_id VARCHAR(50),
    license_number VARCHAR(50),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_insurer_type ON insurer(insurer_type);
CREATE INDEX idx_insurer_active ON insurer(is_active);

-- ==========================================
-- LOAN_INSURER
-- Links loans to insurers (enables multiple insurers per loan)
-- ==========================================

CREATE TABLE loan_insurer (
    loan_insurer_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),
    insurer_id BIGINT NOT NULL
        REFERENCES insurer(insurer_id),
    insurance_type VARCHAR(50) NOT NULL
        CHECK (insurance_type IN ('PRIMARY_MORTGAGE_INSURANCE', 'SECONDARY_MORTGAGE_INSURANCE', 'GOVERNMENT_INSURANCE', 'LENDER_PLACED_INSURANCE')),
    premium_amount NUMERIC(10,2),
    monthly_premium NUMERIC(10,2),
    policy_number VARCHAR(100),
    effective_date DATE NOT NULL,
    expiration_date DATE,
    cancellation_date DATE,
    insurance_status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE'
        CHECK (insurance_status IN ('ACTIVE', 'INACTIVE', 'CANCELLED', 'EXPIRED')),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loan_insurer_loan_id ON loan_insurer(loan_id);
CREATE INDEX idx_loan_insurer_insurer_id ON loan_insurer(insurer_id);
CREATE INDEX idx_loan_insurer_status ON loan_insurer(insurance_status);

-- ==========================================
-- LOAN STATUS HISTORY
-- Tracks loan state changes over time
-- ==========================================

CREATE TABLE loan_status_history (
    status_history_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),
    loan_status VARCHAR(50) NOT NULL
        CHECK (loan_status IN ('ORIGINATED', 'ACTIVE', 'DELINQUENT', 'PAID_OFF', 'FORECLOSURE', 'DEFAULTED', 'SUSPENDED')),
    status_date DATE NOT NULL,
    reason VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loan_status_loan_id ON loan_status_history(loan_id);
CREATE INDEX idx_loan_status_status_date ON loan_status_history(status_date);
CREATE INDEX idx_loan_status_status ON loan_status_history(loan_status);

-- ==========================================
-- PAYMENT SCHEDULE
-- Amortization schedule for loans
-- ==========================================

CREATE TABLE payment_schedule (
    payment_schedule_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),
    payment_number INTEGER NOT NULL,
    scheduled_payment_date DATE NOT NULL,
    scheduled_payment_amount NUMERIC(10,2) NOT NULL
        CHECK (scheduled_payment_amount > 0),
    scheduled_principal_amount NUMERIC(10,2) NOT NULL
        CHECK (scheduled_principal_amount >= 0),
    scheduled_interest_amount NUMERIC(10,2) NOT NULL
        CHECK (scheduled_interest_amount >= 0),
    balance_before_payment NUMERIC(14,2) NOT NULL
        CHECK (balance_before_payment >= 0),
    balance_after_payment NUMERIC(14,2) NOT NULL
        CHECK (balance_after_payment >= 0),
    payment_status VARCHAR(50) NOT NULL DEFAULT 'SCHEDULED'
        CHECK (payment_status IN ('SCHEDULED', 'PAID', 'PARTIALLY_PAID', 'OVERDUE', 'SKIPPED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_payment_schedule_loan_id ON payment_schedule(loan_id);
CREATE INDEX idx_payment_schedule_payment_date ON payment_schedule(scheduled_payment_date);
CREATE INDEX idx_payment_schedule_payment_number ON payment_schedule(loan_id, payment_number);
CREATE UNIQUE INDEX idx_payment_schedule_unique ON payment_schedule(loan_id, payment_number);

-- ==========================================
-- PAYMENT TRANSACTIONS
-- Actual payments received on loans
-- ==========================================

CREATE TABLE payment_transactions (
    payment_transaction_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),
    payment_date DATE NOT NULL,
    principal_paid NUMERIC(10,2) NOT NULL DEFAULT 0
        CHECK (principal_paid >= 0),
    interest_paid NUMERIC(10,2) NOT NULL DEFAULT 0
        CHECK (interest_paid >= 0),
    escrow_paid NUMERIC(10,2) NOT NULL DEFAULT 0
        CHECK (escrow_paid >= 0),
    late_fees_paid NUMERIC(10,2) NOT NULL DEFAULT 0
        CHECK (late_fees_paid >= 0),
    total_paid NUMERIC(10,2) NOT NULL
        CHECK (total_paid > 0),
    payment_method VARCHAR(50) NOT NULL
        CHECK (payment_method IN ('ACH', 'CHECK', 'WIRE_TRANSFER', 'CREDIT_CARD', 'CASH', 'AUTO_PAY', 'OTHER')),
    reference_number VARCHAR(100),
    payer_name VARCHAR(255),
    payment_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_payment_transactions_loan_id ON payment_transactions(loan_id);
CREATE INDEX idx_payment_transactions_payment_date ON payment_transactions(payment_date);
CREATE INDEX idx_payment_transactions_method ON payment_transactions(payment_method);

-- ==========================================
-- LOAN TERMS
-- Interest rate and pricing details
-- ==========================================

CREATE TABLE loan_terms (
    loan_terms_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL UNIQUE
        REFERENCES loan(loan_id),
    interest_rate NUMERIC(7,5) NOT NULL
        CHECK (interest_rate >= 0 AND interest_rate <= 100),
    annual_percentage_rate NUMERIC(7,5) NOT NULL
        CHECK (annual_percentage_rate >= 0 AND annual_percentage_rate <= 100),
    rate_type VARCHAR(50) NOT NULL
        CHECK (rate_type IN ('FIXED', 'ARM', 'BALLOON', 'INTEREST_ONLY', 'VARIABLE')),
    initial_rate_period_months INTEGER,
    margin NUMERIC(5,3),
    index_name VARCHAR(100),
    index_current_value NUMERIC(7,5),
    annual_rate_cap NUMERIC(5,3),
    lifetime_rate_cap NUMERIC(5,3),
    rate_floor NUMERIC(7,5),
    prepayment_penalty_applicable BOOLEAN DEFAULT FALSE,
    prepayment_penalty_percent NUMERIC(5,2),
    prepayment_penalty_months INTEGER,
    disclosure_date DATE,
    rate_lock_date DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loan_terms_loan_id ON loan_terms(loan_id);
CREATE INDEX idx_loan_terms_rate_type ON loan_terms(rate_type);

-- ==========================================
-- DOCUMENTS
-- File references for compliance and records
-- ==========================================

CREATE TABLE documents (
    document_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),
    document_type VARCHAR(100) NOT NULL
        CHECK (document_type IN ('PROMISSORY_NOTE', 'DEED_OF_TRUST', 'MORTGAGE', 'APPRAISAL', 'DISCLOSURE', 
                                 'CLOSING_DISCLOSURE', 'TRUTH_IN_LENDING', 'INSURANCE_DOCUMENTS', 
                                 'TITLE_REPORT', 'INSPECTION_REPORT', 'INCOME_VERIFICATION', 'TAX_RETURNS',
                                 'EMPLOYMENT_VERIFICATION', 'BANK_STATEMENTS', 'UNDERWRITING_DECISION', 'OTHER')),
    description VARCHAR(255),
    file_name VARCHAR(255) NOT NULL,
    file_url VARCHAR(500) NOT NULL,
    file_size_bytes BIGINT,
    document_date DATE,
    upload_date DATE NOT NULL,
    uploaded_by VARCHAR(255),
    expiration_date DATE,
    is_expired BOOLEAN DEFAULT FALSE,
    is_required_for_closing BOOLEAN DEFAULT FALSE,
    is_received BOOLEAN DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_documents_loan_id ON documents(loan_id);
CREATE INDEX idx_documents_document_type ON documents(document_type);
CREATE INDEX idx_documents_upload_date ON documents(upload_date);
CREATE INDEX idx_documents_expiration ON documents(expiration_date);

-- ==========================================
-- UNDERWRITING
-- Loan application and approval tracking
-- ==========================================

CREATE TABLE underwriting (
    underwriting_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL UNIQUE
        REFERENCES loan(loan_id),
    application_date DATE NOT NULL,
    underwriting_status VARCHAR(50) NOT NULL DEFAULT 'SUBMITTED'
        CHECK (underwriting_status IN ('SUBMITTED', 'IN_REVIEW', 'CONDITIONAL_APPROVAL', 'APPROVED', 'DENIED', 'WITHDRAWN')),
    approval_date DATE,
    approved_by VARCHAR(255),
    debt_to_income_ratio NUMERIC(5,2),
    loan_to_value_ratio NUMERIC(5,2),
    credit_score_at_application INTEGER,
    property_appraisal_value NUMERIC(14,2),
    requested_loan_amount NUMERIC(14,2),
    approved_loan_amount NUMERIC(14,2),
    loan_purpose VARCHAR(50)
        CHECK (loan_purpose IN ('PURCHASE', 'REFINANCE', 'CASH_OUT_REFI', 'CONSTRUCTION', 'OTHER')),
    occupancy_type VARCHAR(50)
        CHECK (occupancy_type IN ('PRIMARY_RESIDENCE', 'SECOND_HOME', 'INVESTMENT_PROPERTY')),
    employment_verified BOOLEAN DEFAULT FALSE,
    employment_verification_date DATE,
    income_verified BOOLEAN DEFAULT FALSE,
    verified_income NUMERIC(12,2),
    income_verification_date DATE,
    has_conditions BOOLEAN DEFAULT FALSE,
    conditions_satisfied BOOLEAN DEFAULT FALSE,
    conditions_notes TEXT,
    underwriting_notes TEXT,
    denial_reason VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_underwriting_loan_id ON underwriting(loan_id);
CREATE INDEX idx_underwriting_status ON underwriting(underwriting_status);
CREATE INDEX idx_underwriting_application_date ON underwriting(application_date);
CREATE INDEX idx_underwriting_approval_date ON underwriting(approval_date);

-- ==========================================
-- DELINQUENCY
-- Late payment and delinquency tracking
-- ==========================================

CREATE TABLE delinquency (
    delinquency_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),
    delinquent_date DATE NOT NULL,
    days_delinquent INTEGER NOT NULL
        CHECK (days_delinquent > 0),
    delinquency_status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE'
        CHECK (delinquency_status IN ('ACTIVE', 'CURED', 'FORBEARANCE', 'MODIFICATION', 'FORECLOSURE_INITIATED', 'RESOLVED')),
    delinquent_principal_amount NUMERIC(12,2),
    delinquent_interest_amount NUMERIC(12,2),
    late_fees_charged NUMERIC(10,2),
    collection_attempts INTEGER DEFAULT 0,
    last_collection_attempt_date DATE,
    forbearance_granted BOOLEAN DEFAULT FALSE,
    forbearance_start_date DATE,
    forbearance_end_date DATE,
    loan_modification_offered BOOLEAN DEFAULT FALSE,
    modification_details TEXT,
    resolved_date DATE,
    resolution_type VARCHAR(50)
        CHECK (resolution_type IN ('PAID_IN_FULL', 'MODIFICATION', 'FORBEARANCE', 'REFINANCE', 'CHARGE_OFF', 'FORECLOSURE_COMPLETED')),
    resolution_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_delinquency_loan_id ON delinquency(loan_id);
CREATE INDEX idx_delinquency_delinquent_date ON delinquency(delinquent_date);
CREATE INDEX idx_delinquency_status ON delinquency(delinquency_status);
CREATE INDEX idx_delinquency_resolved_date ON delinquency(resolved_date);

-- ==========================================
-- AUDIT LOG
-- Change tracking for compliance and auditing
-- ==========================================

CREATE TABLE audit_log (
    audit_log_id BIGSERIAL PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT NOT NULL,
    action VARCHAR(20) NOT NULL
        CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    changed_by VARCHAR(255) NOT NULL,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    user_id VARCHAR(255),
    application_name VARCHAR(100),
    ip_address VARCHAR(45),
    old_values JSONB,
    new_values JSONB,
    changed_columns TEXT[],
    transaction_id VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_log_table_record ON audit_log(table_name, record_id);
CREATE INDEX idx_audit_log_changed_at ON audit_log(changed_at);
CREATE INDEX idx_audit_log_changed_by ON audit_log(changed_by);
CREATE INDEX idx_audit_log_action ON audit_log(action);
CREATE INDEX idx_audit_log_table_name ON audit_log(table_name);

-- ==========================================
-- FORECLOSURE
-- Foreclosure proceedings on loans
-- ==========================================

CREATE TABLE foreclosure (
    foreclosure_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),
    property_id BIGINT NOT NULL
        REFERENCES property(property_id),
    foreclosure_initiation_date DATE NOT NULL,
    foreclosure_status VARCHAR(50) NOT NULL DEFAULT 'INITIATED'
        CHECK (foreclosure_status IN ('INITIATED', 'NOTICE_SENT', 'AUCTION_SCHEDULED', 'AUCTION_COMPLETED', 'REO_PROPERTY', 'WITHDRAWN', 'COMPLETED')),
    foreclosure_type VARCHAR(50) NOT NULL
        CHECK (foreclosure_type IN ('JUDICIAL', 'NON_JUDICIAL', 'DEED_IN_LIEU')),
    attorney_name VARCHAR(255),
    attorney_phone VARCHAR(20),
    attorney_email VARCHAR(100),
    court_name VARCHAR(255),
    court_jurisdiction VARCHAR(100),
    case_number VARCHAR(100),
    lis_pendens_date DATE,
    notice_of_default_date DATE,
    notice_of_sale_date DATE,
    foreclosure_sale_date DATE,
    foreclosure_sale_price NUMERIC(14,2),
    redemption_period_days INTEGER,
    redemption_period_end_date DATE,
    foreclosure_outcome VARCHAR(50)
        CHECK (foreclosure_outcome IN ('PROPERTY_SOLD', 'REDEMPTION_EXECUTED', 'DEED_IN_LIEU_ACCEPTED', 'FORECLOSURE_CANCELLED')),
    became_reo_date DATE,
    property_management_company VARCHAR(255),
    sale_proceeds NUMERIC(14,2),
    remaining_balance_at_sale NUMERIC(14,2),
    deficiency_amount NUMERIC(14,2),
    deficiency_pursued BOOLEAN DEFAULT FALSE,
    deficiency_judgment_date DATE,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_foreclosure_loan_id ON foreclosure(loan_id);
CREATE INDEX idx_foreclosure_property_id ON foreclosure(property_id);
CREATE INDEX idx_foreclosure_status ON foreclosure(foreclosure_status);
CREATE INDEX idx_foreclosure_initiation_date ON foreclosure(foreclosure_initiation_date);
CREATE INDEX idx_foreclosure_sale_date ON foreclosure(foreclosure_sale_date);

-- ==========================================
-- BANKRUPTCY
-- Borrower bankruptcy filings
-- ==========================================

CREATE TABLE bankruptcy (
    bankruptcy_id BIGSERIAL PRIMARY KEY,
    borrower_id BIGINT NOT NULL
        REFERENCES borrower_details(borrower_id),
    bankruptcy_filing_date DATE NOT NULL,
    bankruptcy_status VARCHAR(50) NOT NULL DEFAULT 'FILED'
        CHECK (bankruptcy_status IN ('FILED', 'ACTIVE', 'DISCHARGED', 'DISMISSED', 'CLOSED')),
    bankruptcy_type VARCHAR(20) NOT NULL
        CHECK (bankruptcy_type IN ('CHAPTER_7', 'CHAPTER_11', 'CHAPTER_13')),
    bankruptcy_case_number VARCHAR(100) NOT NULL UNIQUE,
    court_name VARCHAR(255) NOT NULL,
    court_jurisdiction VARCHAR(100),
    bankruptcy_judge VARCHAR(255),
    trustee_name VARCHAR(255),
    trustee_phone VARCHAR(20),
    trustee_email VARCHAR(100),
    meeting_date_341 DATE,
    discharge_date DATE,
    dismissal_date DATE,
    dismissal_reason VARCHAR(255),
    plan_start_date DATE,
    plan_end_date DATE,
    plan_monthly_payment NUMERIC(10,2),
    plan_completion_percentage NUMERIC(5,2),
    number_of_loans_affected INTEGER,
    total_debt_in_bankruptcy NUMERIC(14,2),
    stay_relief_granted BOOLEAN DEFAULT FALSE,
    stay_relief_date DATE,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_bankruptcy_borrower_id ON bankruptcy(borrower_id);
CREATE INDEX idx_bankruptcy_filing_date ON bankruptcy(bankruptcy_filing_date);
CREATE INDEX idx_bankruptcy_status ON bankruptcy(bankruptcy_status);
CREATE INDEX idx_bankruptcy_type ON bankruptcy(bankruptcy_type);
CREATE INDEX idx_bankruptcy_case_number ON bankruptcy(bankruptcy_case_number);
CREATE INDEX idx_bankruptcy_discharge_date ON bankruptcy(discharge_date);

-- ==========================================
-- LOAN_BANKRUPTCY
-- Links loans to borrower bankruptcies
-- ==========================================

CREATE TABLE loan_bankruptcy (
    loan_bankruptcy_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),
    bankruptcy_id BIGINT NOT NULL
        REFERENCES bankruptcy(bankruptcy_id),
    discharge_status VARCHAR(50) NOT NULL DEFAULT 'PENDING'
        CHECK (discharge_status IN ('INCLUDED', 'EXCLUDED', 'REAFFIRMED', 'STRIPPED', 'PAID_OFF', 'PENDING')),
    debt_amount_at_filing NUMERIC(14,2),
    current_loan_balance NUMERIC(14,2),
    payments_made_during_bankruptcy NUMERIC(14,2) DEFAULT 0,
    last_payment_date DATE,
    proof_of_claim_filed BOOLEAN DEFAULT FALSE,
    proof_of_claim_date DATE,
    proof_of_claim_amount NUMERIC(14,2),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loan_bankruptcy_loan_id ON loan_bankruptcy(loan_id);
CREATE INDEX idx_loan_bankruptcy_bankruptcy_id ON loan_bankruptcy(bankruptcy_id);
CREATE INDEX idx_loan_bankruptcy_discharge_status ON loan_bankruptcy(discharge_status);
