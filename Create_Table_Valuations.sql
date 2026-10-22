-- ==========================================
-- VALUATIONS
-- Property valuations and appraisals
-- ==========================================

CREATE TABLE valuations (
    valuation_id BIGSERIAL PRIMARY KEY,

    loan_id BIGINT NOT NULL
        REFERENCES loan(loan_id),

    property_id BIGINT NOT NULL
        REFERENCES property(property_id),

    valuation_type VARCHAR(50) NOT NULL
        CHECK (valuation_type IN ('APPRAISAL', 'AVM', 'BROKER_PRICE_OPINION', 'AUTOMATED_VALUATION', 'DESK_REVIEW')),

    -- Property Value
    property_value NUMERIC(14,2) NOT NULL
        CHECK (property_value > 0),

    original_property_value NUMERIC(14,2),

    -- LTV Calculation
    current_loan_balance NUMERIC(14,2),
    loan_to_value NUMERIC(5,2) NOT NULL
        CHECK (loan_to_value > 0 AND loan_to_value <= 125),

    -- Valuation Details
    valuation_date DATE NOT NULL,
    appraiser_name VARCHAR(255),
    appraiser_license_number VARCHAR(50),

    -- Market/Economic Info
    market_conditions_description TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_valuations_loan_id ON valuations(loan_id);
CREATE INDEX idx_valuations_property_id ON valuations(property_id);
CREATE INDEX idx_valuations_date ON valuations(valuation_date);
