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

    -- Payment amounts
    scheduled_payment_amount NUMERIC(10,2) NOT NULL
        CHECK (scheduled_payment_amount > 0),

    scheduled_principal_amount NUMERIC(10,2) NOT NULL
        CHECK (scheduled_principal_amount >= 0),

    scheduled_interest_amount NUMERIC(10,2) NOT NULL
        CHECK (scheduled_interest_amount >= 0),

    -- Balance tracking
    balance_before_payment NUMERIC(14,2) NOT NULL
        CHECK (balance_before_payment >= 0),

    balance_after_payment NUMERIC(14,2) NOT NULL
        CHECK (balance_after_payment >= 0),

    -- Status
    payment_status VARCHAR(50) NOT NULL DEFAULT 'SCHEDULED'
        CHECK (payment_status IN ('SCHEDULED', 'PAID', 'PARTIALLY_PAID', 'OVERDUE', 'SKIPPED')),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_payment_schedule_loan_id ON payment_schedule(loan_id);
CREATE INDEX idx_payment_schedule_payment_date ON payment_schedule(scheduled_payment_date);
CREATE INDEX idx_payment_schedule_payment_number ON payment_schedule(loan_id, payment_number);
CREATE UNIQUE INDEX idx_payment_schedule_unique ON payment_schedule(loan_id, payment_number);
