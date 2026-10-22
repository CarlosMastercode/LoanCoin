-- ==========================================
-- AUDIT LOG
-- Change tracking for compliance and auditing
-- ==========================================

CREATE TABLE audit_log (
    audit_log_id BIGSERIAL PRIMARY KEY,

    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT NOT NULL,

    -- Action Details
    action VARCHAR(20) NOT NULL
        CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),

    changed_by VARCHAR(255) NOT NULL,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- User/Application Context
    user_id VARCHAR(255),
    application_name VARCHAR(100),
    ip_address VARCHAR(45),

    -- Changes
    old_values JSONB,
    new_values JSONB,
    changed_columns TEXT[],

    -- Additional Context
    transaction_id VARCHAR(100),
    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_log_table_record ON audit_log(table_name, record_id);
CREATE INDEX idx_audit_log_changed_at ON audit_log(changed_at);
CREATE INDEX idx_audit_log_changed_by ON audit_log(changed_by);
CREATE INDEX idx_audit_log_action ON audit_log(action);
CREATE INDEX idx_audit_log_table_name ON audit_log(table_name);
