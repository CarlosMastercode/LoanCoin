-- ==========================================
-- PAYMENT TRANSACTIONS
-- Actual payments received on loans
-- ==========================================

CREATE TABLE payment_transactions (
    payment_transaction_id BIGSERIAL PRIMARY KEY,

    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),

    payment_date DATE NOT NULL,

    -- Payment allocation
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

    -- Payment details
    payment_method VARCHAR(50) NOT NULL
        CHECK (payment_method IN ('ACH', 'CHECK', 'WIRE_TRANSFER', 'CREDIT_CARD', 'CASH', 'AUTO_PAY', 'OTHER')),

    reference_number VARCHAR(100),

    -- Optional details
    payer_name VARCHAR(255),
    payment_notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_payment_transactions_loan_id ON payment_transactions(loan_id);
CREATE INDEX idx_payment_transactions_payment_date ON payment_transactions(payment_date);
CREATE INDEX idx_payment_transactions_method ON payment_transactions(payment_method);
