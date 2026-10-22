-- ==========================================
-- LOAN TYPE LOOKUP
-- ==========================================

CREATE TABLE loan_type (
    loan_type_id BIGSERIAL PRIMARY KEY,

    loan_type_code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);