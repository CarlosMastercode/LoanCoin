-- ==========================================
-- BANKRUPTCY
-- Borrower bankruptcy filings
-- ==========================================

CREATE TABLE bankruptcy (
    bankruptcy_id BIGSERIAL PRIMARY KEY,

    borrower_id BIGINT NOT NULL
        REFERENCES borrower_details(borrower_id),

    -- Bankruptcy Details
    bankruptcy_filing_date DATE NOT NULL,

    bankruptcy_status VARCHAR(50) NOT NULL DEFAULT 'FILED'
        CHECK (bankruptcy_status IN ('FILED', 'ACTIVE', 'DISCHARGED', 'DISMISSED', 'CLOSED')),

    bankruptcy_type VARCHAR(20) NOT NULL
        CHECK (bankruptcy_type IN ('CHAPTER_7', 'CHAPTER_11', 'CHAPTER_13')),

    bankruptcy_case_number VARCHAR(100) NOT NULL UNIQUE,

    -- Court Information
    court_name VARCHAR(255) NOT NULL,
    court_jurisdiction VARCHAR(100),
    bankruptcy_judge VARCHAR(255),

    -- Trustee Information
    trustee_name VARCHAR(255),
    trustee_phone VARCHAR(20),
    trustee_email VARCHAR(100),

    -- Bankruptcy Timeline
    341_meeting_date DATE,
    discharge_date DATE,
    dismissal_date DATE,
    dismissal_reason VARCHAR(255),

    -- Repayment Plan (for Ch. 13)
    plan_start_date DATE,
    plan_end_date DATE,
    plan_monthly_payment NUMERIC(10,2),
    plan_completion_percentage NUMERIC(5,2),

    -- Affected Loans
    number_of_loans_affected INTEGER,
    total_debt_in_bankruptcy NUMERIC(14,2),

    -- Impact on Loan
    loan_discharge_status VARCHAR(50)
        CHECK (loan_discharge_status IN ('INCLUDED', 'EXCLUDED', 'REAFFIRMED', 'STRIPPED', 'PENDING')),

    stay_relief_granted BOOLEAN DEFAULT FALSE,
    stay_relief_date DATE,

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_bankruptcy_borrower_id ON bankruptcy(borrower_id);
CREATE INDEX idx_bankruptcy_filing_date ON bankruptcy(bankruptcy_filing_date);
CREATE INDEX idx_bankruptcy_status ON bankruptcy(bankruptcy_status);
CREATE INDEX idx_bankruptcy_type ON bankruptcy(bankruptcy_type);
CREATE INDEX idx_bankruptcy_case_number ON bankruptcy(bankruptcy_case_number);
CREATE INDEX idx_bankruptcy_discharge_date ON bankruptcy(discharge_date);


-- ==========================================
-- LOAN_BANKRUPTCY
-- Links loans to borrower bankruptcies
-- ==========================================

CREATE TABLE loan_bankruptcy (
    loan_bankruptcy_id BIGSERIAL PRIMARY KEY,

    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),

    bankruptcy_id BIGINT NOT NULL
        REFERENCES bankruptcy(bankruptcy_id),

    -- Relationship Details
    discharge_status VARCHAR(50) NOT NULL DEFAULT 'PENDING'
        CHECK (discharge_status IN ('INCLUDED', 'EXCLUDED', 'REAFFIRMED', 'STRIPPED', 'PAID_OFF', 'PENDING')),

    -- Amounts
    debt_amount_at_filing NUMERIC(14,2),
    current_loan_balance NUMERIC(14,2),

    -- Payment Status During Bankruptcy
    payments_made_during_bankruptcy NUMERIC(14,2) DEFAULT 0,
    last_payment_date DATE,

    -- Proof of Claim
    proof_of_claim_filed BOOLEAN DEFAULT FALSE,
    proof_of_claim_date DATE,
    proof_of_claim_amount NUMERIC(14,2),

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loan_bankruptcy_loan_id ON loan_bankruptcy(loan_id);
CREATE INDEX idx_loan_bankruptcy_bankruptcy_id ON loan_bankruptcy(bankruptcy_id);
CREATE INDEX idx_loan_bankruptcy_discharge_status ON loan_bankruptcy(discharge_status);
