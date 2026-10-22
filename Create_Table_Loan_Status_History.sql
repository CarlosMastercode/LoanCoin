-- ==========================================
-- LOAN STATUS HISTORY
-- Tracks loan state changes over time
-- ==========================================

CREATE TABLE loan_status_history (
    status_history_id BIGSERIAL PRIMARY KEY,

    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),

    loan_status VARCHAR(50) NOT NULL
        CHECK (loan_status IN ('ORIGINATED', 'ACTIVE', 'DELINQUENT', 'PAID_OFF', 'FORECLOSURE', 'DEFAULTED', 'SUSPENDED')),

    status_date DATE NOT NULL,

    reason VARCHAR(255),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_loan_status_loan_id ON loan_status_history(loan_id);
CREATE INDEX idx_loan_status_status_date ON loan_status_history(status_date);
CREATE INDEX idx_loan_status_status ON loan_status_history(loan_status);
