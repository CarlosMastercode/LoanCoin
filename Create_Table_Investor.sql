-- ==========================================
-- INVESTOR
-- Loan investors/investors and ownership information
-- ==========================================

CREATE TABLE investor (
    investor_id BIGSERIAL PRIMARY KEY,

    investor_name VARCHAR(255) NOT NULL UNIQUE,

    investor_type VARCHAR(50) NOT NULL
        CHECK (investor_type IN ('BANK', 'CREDIT_UNION', 'INSURANCE_COMPANY', 'PENSION_FUND', 'HEDGE_FUND', 'INDIVIDUAL', 'OTHER')),

    -- Contact Information
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),

    -- Address
    street_address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    country VARCHAR(2) DEFAULT 'US',

    -- Business Information
    tax_id VARCHAR(50),
    registration_number VARCHAR(50),

    -- Licensing & Compliance
    mlo_license_number VARCHAR(50),
    broker_dealer_license VARCHAR(50),

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_approved BOOLEAN NOT NULL DEFAULT FALSE,

    approval_date DATE,

    -- Risk/Rating
    credit_rating VARCHAR(10),
    risk_level VARCHAR(20)
        CHECK (risk_level IN ('LOW', 'MEDIUM', 'HIGH', 'UNRATED')),

    -- Relationships
    parent_company_id BIGINT
        REFERENCES investor(investor_id),

    -- Audit Trail
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

    -- Ownership Details
    ownership_percentage NUMERIC(5,2) NOT NULL
        CHECK (ownership_percentage > 0 AND ownership_percentage <= 100),

    assigned_principal_balance NUMERIC(14,2) NOT NULL,

    assignment_type VARCHAR(50)
        CHECK (assignment_type IN ('ORIGINATION', 'SALE', 'TRANSFER', 'SYNDICATION')),

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loan_investor_assignment_loan_id ON loan_investor_assignment(loan_id);
CREATE INDEX idx_loan_investor_assignment_investor_id ON loan_investor_assignment(investor_id);
CREATE UNIQUE INDEX idx_loan_investor_unique ON loan_investor_assignment(loan_id, investor_id) WHERE is_active = TRUE;
