-- ==========================================
-- INSURER
-- Mortgage insurance providers
-- ==========================================

CREATE TABLE insurer (
    insurer_id BIGSERIAL PRIMARY KEY,

    insurer_name VARCHAR(255) NOT NULL UNIQUE,

    insurer_type VARCHAR(50) NOT NULL
        CHECK (insurer_type IN ('FHA', 'USDA', 'VA', 'PMI_PROVIDER', 'OTHER')),

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
    license_number VARCHAR(50),

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit Trail
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

    -- Insurance Details
    insurance_type VARCHAR(50) NOT NULL
        CHECK (insurance_type IN ('PRIMARY_MORTGAGE_INSURANCE', 'SECONDARY_MORTGAGE_INSURANCE', 'GOVERNMENT_INSURANCE', 'LENDER_PLACED_INSURANCE')),

    premium_amount NUMERIC(10,2),
    monthly_premium NUMERIC(10,2),

    policy_number VARCHAR(100),

    -- Dates
    effective_date DATE NOT NULL,
    expiration_date DATE,
    cancellation_date DATE,

    -- Status
    insurance_status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE'
        CHECK (insurance_status IN ('ACTIVE', 'INACTIVE', 'CANCELLED', 'EXPIRED')),

    -- Notes
    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loan_insurer_loan_id ON loan_insurer(loan_id);
CREATE INDEX idx_loan_insurer_insurer_id ON loan_insurer(insurer_id);
CREATE INDEX idx_loan_insurer_status ON loan_insurer(insurance_status);
