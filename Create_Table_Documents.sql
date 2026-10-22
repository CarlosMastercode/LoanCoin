-- ==========================================
-- DOCUMENTS
-- File references for compliance and records
-- ==========================================

CREATE TABLE documents (
    document_id BIGSERIAL PRIMARY KEY,

    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),

    document_type VARCHAR(100) NOT NULL
        CHECK (document_type IN ('PROMISSORY_NOTE', 'DEED_OF_TRUST', 'MORTGAGE', 'APPRAISAL', 'DISCLOSURE', 
                                 'CLOSING_DISCLOSURE', 'TRUTH_IN_LENDING', 'INSURANCE_DOCUMENTS', 
                                 'TITLE_REPORT', 'INSPECTION_REPORT', 'INCOME_VERIFICATION', 'TAX_RETURNS',
                                 'EMPLOYMENT_VERIFICATION', 'BANK_STATEMENTS', 'UNDERWRITING_DECISION', 'OTHER')),

    description VARCHAR(255),

    file_name VARCHAR(255) NOT NULL,

    file_url VARCHAR(500) NOT NULL,

    file_size_bytes BIGINT,

    document_date DATE,

    upload_date DATE NOT NULL,

    uploaded_by VARCHAR(255),

    -- Expiration tracking (for documents that expire)
    expiration_date DATE,
    is_expired BOOLEAN DEFAULT FALSE,

    -- Compliance
    is_required_for_closing BOOLEAN DEFAULT FALSE,
    is_received BOOLEAN DEFAULT TRUE,

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_documents_loan_id ON documents(loan_id);
CREATE INDEX idx_documents_document_type ON documents(document_type);
CREATE INDEX idx_documents_upload_date ON documents(upload_date);
CREATE INDEX idx_documents_expiration ON documents(expiration_date);
