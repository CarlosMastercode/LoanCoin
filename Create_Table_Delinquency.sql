-- ==========================================
-- DELINQUENCY
-- Late payment and delinquency tracking
-- ==========================================

CREATE TABLE delinquency (
    delinquency_id BIGSERIAL PRIMARY KEY,

    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),

    delinquent_due_date DATE NOT NULL,

    days_delinquent INTEGER NOT NULL
        CHECK (days_delinquent > 0),

    -- Delinquency Status
    delinquency_status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE'
        CHECK (delinquency_status IN ('ACTIVE', 'CURED', 'FORBEARANCE', 'MODIFICATION', 'FORECLOSURE_INITIATED', 'RESOLVED')),

    -- Amount & Details
    delinquent_principal_amount NUMERIC(12,2),
    delinquent_interest_amount NUMERIC(12,2),
    late_fees_charged NUMERIC(10,2),

    -- Collection Efforts
    collection_attempts INTEGER DEFAULT 0,
    last_collection_attempt_date DATE,

    -- Remedies
    forbearance_granted BOOLEAN DEFAULT FALSE,
    forbearance_start_date DATE,
    forbearance_end_date DATE,

    loan_modification_offered BOOLEAN DEFAULT FALSE,
    modification_details TEXT,

    -- Resolution
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
