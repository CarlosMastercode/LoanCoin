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
    payment_amount NUMERIC(14,2) NOT NULL
        CHECK (payment_amount > 0),

   -- Dates
    due_date DATE NOT NULL,
    paid_date DATE,
    next_payment_date DATE,

    -- Recipient Information
    recipient_name VARCHAR(255) NOT NULL,
    recipient_address VARCHAR(255),
    recipient_city VARCHAR(100),
    recipient_state VARCHAR(2),
    recipient_zip_code VARCHAR(10),
    recipient_country VARCHAR(2) DEFAULT 'US',

    recipient_email VARCHAR(100),
    recipient_phone VARCHAR(20),

    -- Account/Reference Information
    recipient_account_number VARCHAR(100),
    recipient_tax_id VARCHAR(50),

    -- Status Tracking
    payment_status VARCHAR(50) NOT NULL DEFAULT 'PENDING'
        CHECK (payment_status IN ('PENDING', 'PAID', 'PARTIALLY_PAID', 'OVERDUE', 'CANCELLED')),

    -- Audit Trail
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_escrow_loan_id ON escrow(loan_id);
CREATE INDEX idx_escrow_due_date ON escrow(due_date);
