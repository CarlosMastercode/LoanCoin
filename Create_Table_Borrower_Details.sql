-- ==========================================
-- BORROWER DETAILS
-- ==========================================

CREATE TABLE borrower_details (
    borrower_id BIGSERIAL PRIMARY KEY,

    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),

    ssn_encrypted VARCHAR(255),

    date_of_birth DATE,

    email_address VARCHAR(100),
    phone_number VARCHAR(20),

    -- Mailing Address
    mailing_street_address VARCHAR(255) NOT NULL,
    mailing_city VARCHAR(100) NOT NULL,
    mailing_state VARCHAR(2) NOT NULL,
    mailing_zip_code VARCHAR(10) NOT NULL,
    mailing_country VARCHAR(2) NOT NULL DEFAULT 'US',

    -- Employment/Income Information
    employment_status VARCHAR(50)
        CHECK (employment_status IN ('EMPLOYED', 'SELF_EMPLOYED', 'RETIRED', 'DISABLED', 'UNEMPLOYED')),

    employer_name VARCHAR(255),
    job_title VARCHAR(100),
    years_employed INTEGER,

    annual_income NUMERIC(12,2),

    -- Credit Information
    credit_score INTEGER,

    -- Additional Info
    citizenship_status VARCHAR(50)
        CHECK (citizenship_status IN ('US_CITIZEN', 'PERMANENT_RESIDENT', 'NON_RESIDENT')),

    marital_status VARCHAR(20),

    num_dependents INTEGER DEFAULT 0,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_borrower_loan_id ON borrower_details(loan_id);
email ON borrower_details(email_address);
CREATE INDEX idx_borrower_name ON borrower_details(last_name, first_name