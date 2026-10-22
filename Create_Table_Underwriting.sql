-- ==========================================
-- UNDERWRITING
-- Loan application and approval tracking
-- ==========================================

CREATE TABLE underwriting (
    underwriting_id BIGSERIAL PRIMARY KEY,

    loan_id BIGINT NOT NULL UNIQUE
        REFERENCES loan(loan_id),

    application_date DATE NOT NULL,

    -- Underwriting Status
    underwriting_status VARCHAR(50) NOT NULL DEFAULT 'SUBMITTED'
        CHECK (underwriting_status IN ('SUBMITTED', 'IN_REVIEW', 'CONDITIONAL_APPROVAL', 'APPROVED', 'DENIED', 'WITHDRAWN')),

    approval_date DATE,
    approved_by VARCHAR(255),

    -- Financial Metrics
    debt_to_income_ratio NUMERIC(5,2),

    loan_to_value_ratio NUMERIC(5,2),

    credit_score_at_application INTEGER,

    -- Property & Loan Details
    property_appraisal_value NUMERIC(14,2),
    requested_loan_amount NUMERIC(14,2),
    approved_loan_amount NUMERIC(14,2),

    -- Loan Purpose
    loan_purpose VARCHAR(50)
        CHECK (loan_purpose IN ('PURCHASE', 'REFINANCE', 'CASH_OUT_REFI', 'CONSTRUCTION', 'OTHER')),

    -- Occupancy
    occupancy_type VARCHAR(50)
        CHECK (occupancy_type IN ('PRIMARY_RESIDENCE', 'SECOND_HOME', 'INVESTMENT_PROPERTY')),

    -- Employment Verification
    employment_verified BOOLEAN DEFAULT FALSE,
    employment_verification_date DATE,

    -- Income Documentation
    income_verified BOOLEAN DEFAULT FALSE,
    verified_income NUMERIC(12,2),
    income_verification_date DATE,

    -- Conditions
    has_conditions BOOLEAN DEFAULT FALSE,
    conditions_satisfied BOOLEAN DEFAULT FALSE,
    conditions_notes TEXT,

    -- Underwriter Notes
    underwriting_notes TEXT,

    denial_reason VARCHAR(255),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_underwriting_loan_id ON underwriting(loan_id);
CREATE INDEX idx_underwriting_status ON underwriting(underwriting_status);
CREATE INDEX idx_underwriting_application_date ON underwriting(application_date);
CREATE INDEX idx_underwriting_approval_date ON underwriting(approval_date);
