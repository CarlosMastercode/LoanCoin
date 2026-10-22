-- ==========================================
-- PROPERTY
-- Property details for loans (one loan can have one property)
-- ==========================================

CREATE TABLE property (
    property_id BIGSERIAL PRIMARY KEY,

    loan_id BIGINT NOT NULL UNIQUE
        REFERENCES loan(loan_id),

    -- Property Address
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    country VARCHAR(2) NOT NULL DEFAULT 'US',

    county VARCHAR(100),

    -- Property Type and Details
    property_type VARCHAR(50)
        CHECK (property_type IN ('SINGLE_FAMILY', 'CONDO', 'TOWNHOUSE', 'MULTI_UNIT', 'MANUFACTURED', 'LAND', 'COMMERCIAL')),

    square_feet INTEGER,
    lot_size_sqft INTEGER,

    year_built INTEGER,
    num_bedrooms INTEGER,
    num_bathrooms NUMERIC(3,1),

    -- Property Characteristics
    occupancy_status VARCHAR(50) NOT NULL
        CHECK (occupancy_status IN ('PRIMARY_RESIDENCE', 'SECOND_HOME', 'INVESTMENT_PROPERTY')),

    condition_rating VARCHAR(50)
        CHECK (condition_rating IN ('EXCELLENT', 'GOOD', 'FAIR', 'POOR')),

    -- Legal Information
    parcel_number VARCHAR(50),
    legal_description TEXT,

    -- Utilities & Features
    has_garage BOOLEAN,
    garage_spaces INTEGER,
    has_pool BOOLEAN,
    has_patio BOOLEAN,

    -- Audit Trail
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_property_loan_id ON property(loan_id);
CREATE INDEX idx_property_address ON property(city, state);
