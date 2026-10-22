-- ==========================================
-- LOAN TERMS
-- Interest rate and pricing details
-- ==========================================

CREATE TABLE loan_terms (
    loan_terms_id BIGSERIAL PRIMARY KEY,

    loan_id BIGINT NOT NULL UNIQUE
        REFERENCES loan(loan_id),

    -- Interest Rate
    interest_rate NUMERIC(7,5) NOT NULL
        CHECK (interest_rate >= 0 AND interest_rate <= 100),

    annual_percentage_rate NUMERIC(7,5) NOT NULL
        CHECK (annual_percentage_rate >= 0 AND annual_percentage_rate <= 100),

    rate_type VARCHAR(50) NOT NULL
        CHECK (rate_type IN ('FIXED', 'ARM', 'BALLOON', 'INTEREST_ONLY', 'VARIABLE')),

    -- For ARM loans
    initial_rate_period_months INTEGER,
    margin NUMERIC(5,3),
    index_name VARCHAR(100),
    index_current_value NUMERIC(7,5),

    -- Rate caps/floors (for ARM)
    annual_rate_cap NUMERIC(5,3),
    lifetime_rate_cap NUMERIC(5,3),
    rate_floor NUMERIC(7,5),

    -- Prepayment
    prepayment_penalty_applicable BOOLEAN DEFAULT FALSE,
    prepayment_penalty_percent NUMERIC(5,2),
    prepayment_penalty_months INTEGER,

    -- Compliance & Disclosure
    disclosure_date DATE,
    rate_lock_date DATE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loan_terms_loan_id ON loan_terms(loan_id);
CREATE INDEX idx_loan_terms_rate_type ON loan_terms(rate_type);
