-- ==========================================
-- COMPARABLES
-- Comparable property sales data for valuations
-- ==========================================

CREATE TABLE comparables (
    comparable_id BIGSERIAL PRIMARY KEY,

    valuation_id BIGINT NOT NULL
        REFERENCES valuations(valuation_id),

    -- Property Address
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    country VARCHAR(2) NOT NULL DEFAULT 'US',

    -- Geo-Location
    latitude NUMERIC(10,8),
    longitude NUMERIC(11,8),

    -- Property Details
    property_type VARCHAR(50)
        CHECK (property_type IN ('SINGLE_FAMILY', 'CONDO', 'TOWNHOUSE', 'MULTI_UNIT', 'MANUFACTURED', 'LAND', 'COMMERCIAL')),

    square_feet INTEGER,
    lot_size_sqft INTEGER,
    year_built INTEGER,
    num_bedrooms INTEGER,
    num_bathrooms NUMERIC(3,1),

    -- Sale Information
    sale_price NUMERIC(14,2) NOT NULL
        CHECK (sale_price > 0),

    sale_date DATE NOT NULL,
    days_on_market INTEGER,

    -- Property Condition
    condition_rating VARCHAR(50)
        CHECK (condition_rating IN ('EXCELLENT', 'GOOD', 'FAIR', 'POOR')),

    -- MLS/Source Information
    mls_number VARCHAR(50),
    data_source VARCHAR(100),

    -- Market Data
    price_per_sqft NUMERIC(10,2),
    price_per_lot_sqft NUMERIC(10,2),

    -- Notes
    notes TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_comparables_valuation_id ON comparables(valuation_id);
CREATE INDEX idx_comparables_geo ON comparables(latitude, longitude

CREATE INDEX idx_valuation_comparable_valuation_id ON valuation_comparable(valuation_id);
CREATE INDEX idx_valuation_comparable_comparable_id ON valuation_comparable(comparable_id);
CREATE UNIQUE INDEX idx_valuation_comparable_unique ON valuation_comparable(valuation_id, comparable_id);
