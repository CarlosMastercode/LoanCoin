

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
        CHECK (
            interest_calculation_method IN (
                'FIXED',
                'ARM',
                'BALLOON',
                'INTEREST_ONLY'
            )
        ),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);