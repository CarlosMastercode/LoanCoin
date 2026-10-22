-- ==========================================
-- FORECLOSURE
-- Foreclosure proceedings on loans
-- ==========================================

CREATE TABLE foreclosure (
    foreclosure_id BIGSERIAL PRIMARY KEY,

    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),

    property_id BIGINT NOT NULL
        REFERENCES property(property_id),

    -- Foreclosure Details
    foreclosure_initiation_date DATE NOT NULL,

    foreclosure_status VARCHAR(50) NOT NULL DEFAULT 'INITIATED'
        CHECK (foreclosure_status IN ('INITIATED', 'NOTICE_SENT', 'AUCTION_SCHEDULED', 'AUCTION_COMPLETED', 'REO_PROPERTY', 'WITHDRAWN', 'COMPLETED')),

    foreclosure_type VARCHAR(50) NOT NULL
        CHECK (foreclosure_type IN ('JUDICIAL', 'NON_JUDICIAL', 'DEED_IN_LIEU')),

    -- Legal Representatives
    attorney_name VARCHAR(255),
    attorney_phone VARCHAR(20),
    attorney_email VARCHAR(100),

    -- Court Information
    court_name VARCHAR(255),
    court_jurisdiction VARCHAR(100),
    case_number VARCHAR(100),

    -- Foreclosure Process
    lis_pendens_date DATE,
    notice_of_default_date DATE,
    notice_of_sale_date DATE,

    foreclosure_sale_date DATE,
    foreclosure_sale_price NUMERIC(14,2),

    -- Redemption Period
    redemption_period_days INTEGER,
    redemption_period_end_date DATE,

    -- Outcome
    foreclosure_outcome VARCHAR(50)
        CHECK (foreclosure_outcome IN ('PROPERTY_SOLD', 'REDEMPTION_EXECUTED', 'DEED_IN_LIEU_ACCEPTED', 'FORECLOSURE_CANCELLED')),

    -- REO (Real Estate Owned)
    became_reo_date DATE,
    property_management_company VARCHAR(255),

    -- Deficiency (amount owed after sale)
    sale_proceeds NUMERIC(14,2),
    remaining_balance_at_sale NUMERIC(14,2),
    deficiency_amount NUMERIC(14,2),
    deficiency_pursued BOOLEAN DEFAULT FALSE,
    deficiency_judgment_date DATE,

    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_foreclosure_loan_id ON foreclosure(loan_id);
CREATE INDEX idx_foreclosure_property_id ON foreclosure(property_id);
CREATE INDEX idx_foreclosure_status ON foreclosure(foreclosure_status);
CREATE INDEX idx_foreclosure_initiation_date ON foreclosure(foreclosure_initiation_date);
CREATE INDEX idx_foreclosure_sale_date ON foreclosure(foreclosure_sale_date);
