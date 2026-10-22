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

    -- Borrower Position/Type on this specific loan
    borrower_position VARCHAR(50) NOT NULL
        CHECK (borrower_position IN ('PRIMARY', 'CO_BORROWER', 'GUARANTOR')),

    -- Liability/Obligation Details
    liability_percentage NUMERIC(5,2)
        CHECK (liability_percentage > 0 AND liability_percentage <= 100),

    is_primary_liable BOOLEAN NOT NULL DEFAULT FALSE,

    -- Signature & Consent
    signed_date DATE,
    has_signed BOOLEAN NOT NULL DEFAULT FALSE,

    -- Notes
    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loan_borrower_loan_id ON loan_borrower(loan_id);
CREATE INDEX idx_loan_borrower_borrower_id ON loan_borrower(borrower_id);
CREATE INDEX idx_loan_borrower_position ON loan_borrower(borrower_position);
CREATE UNIQUE INDEX idx_loan_borrower_primary ON loan_borrower(loan_id) WHERE borrower_position = 'PRIMARY';
