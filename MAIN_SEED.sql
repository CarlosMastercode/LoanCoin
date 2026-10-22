-- ==========================================
-- LOANCOIN MORTGAGE PLATFORM - SEED DATA
-- Comprehensive test data with wide range of scenarios
-- ==========================================

-- ==========================================
-- LOAN TYPE SEED DATA
-- ==========================================

INSERT INTO loan_type (loan_type_id, loan_type_code, description) VALUES
    (1, 'FHA', 'Federal Housing Administration'),
    (2, 'CONVENTIONAL', 'Conventional Mortgage'),
    (3, 'VA', 'Veterans Affairs Loan'),
    (4, 'USDA', 'USDA Rural Development Loan'),
    (5, 'HELOC', 'Home Equity Line of Credit'),
    (6, 'AUTO', 'Automobile Loan'),
    (7, 'BOAT', 'Boat Loan'),
    (8, 'EQUIPMENT', 'Equipment Financing'),
    (9, 'PERSONAL', 'Personal Loan'),
    (10, 'COMMERCIAL', 'Commercial Loan');

-- ==========================================
-- LOAN SEED DATA
-- ==========================================

INSERT INTO loan (loan_id, loan_number, loan_type_id, origination_date, first_payment_date, original_maturity_date, original_balance, original_term_months, interest_calculation_method) VALUES
    (1, 'LN-2022-0001', 2, '2022-03-15', '2022-04-15', '2052-03-15', 350000.00, 360, 'FIXED'),
    (2, 'LN-2023-0002', 1, '2023-01-20', '2023-02-20', '2053-01-20', 280000.00, 360, 'FIXED'),
    (3, 'LN-2023-0003', 2, '2023-06-10', '2023-07-10', '2053-06-10', 425000.00, 360, 'ARM'),
    (4, 'LN-2024-0004', 3, '2024-02-05', '2024-03-05', '2054-02-05', 320000.00, 360, 'FIXED'),
    (5, 'LN-2024-0005', 2, '2024-04-18', NULL, '2054-04-18', 275000.00, 360, 'FIXED'),
    (6, 'LN-2022-0006', 2, '2022-08-22', '2022-09-22', '2052-08-22', 180000.00, 360, 'BALLOON'),
    (7, 'LN-2021-0007', 4, '2021-11-10', '2021-12-10', '2051-11-10', 195000.00, 360, 'FIXED'),
    (8, 'LN-2023-0008', 2, '2023-09-30', '2023-10-30', '2053-09-30', 500000.00, 360, 'FIXED'),
    (9, 'LN-2020-0009', 2, '2020-05-12', '2020-06-12', '2050-05-12', 250000.00, 360, 'FIXED'),
    (10, 'LN-2024-0010', 2, '2024-01-08', '2024-02-08', '2054-01-08', 350000.00, 360, 'FIXED');

-- ==========================================
-- BORROWER DETAILS SEED DATA
-- ==========================================

INSERT INTO borrower_details (borrower_id, first_name, last_name, middle_name, ssn_encrypted, date_of_birth, email_address, phone_number, 
                              mailing_street_address, mailing_city, mailing_state, mailing_zip_code, mailing_country,
                              employment_status, employer_name, job_title, years_employed, annual_income, credit_score,
                              citizenship_status, marital_status, num_dependents) VALUES
    (1, 'John', 'Smith', 'Michael', 'SSN_ENCRYPTED_001', '1975-03-15', 'john.smith@email.com', '555-0101',
     '123 Main Street', 'Portland', 'OR', '97201', 'US', 'EMPLOYED', 'Tech Corp', 'Software Engineer', 8, 125000.00, 750,
     'US_CITIZEN', 'MARRIED', 2),
    
    (2, 'Sarah', 'Johnson', 'Marie', 'SSN_ENCRYPTED_002', '1982-07-22', 'sarah.j@email.com', '555-0102',
     '456 Oak Avenue', 'Seattle', 'WA', '98101', 'US', 'EMPLOYED', 'Finance Inc', 'Account Manager', 10, 95000.00, 780,
     'US_CITIZEN', 'SINGLE', 1),
    
    (3, 'Michael', 'Davis', 'Robert', 'SSN_ENCRYPTED_003', '1968-11-30', 'mdavis@email.com', '555-0103',
     '789 Pine Road', 'Eugene', 'OR', '97401', 'US', 'SELF_EMPLOYED', 'Davis Consulting LLC', 'Owner', 15, 150000.00, 720,
     'US_CITIZEN', 'MARRIED', 3),
    
    (4, 'Jennifer', 'Wilson', 'Anne', 'SSN_ENCRYPTED_004', '1990-05-12', 'jen.wilson@email.com', '555-0104',
     '321 Elm Street', 'Vancouver', 'WA', '98660', 'US', 'EMPLOYED', 'Healthcare Systems', 'Nurse Manager', 6, 85000.00, 690,
     'US_CITIZEN', 'MARRIED', 0),
    
    (5, 'David', 'Brown', 'James', 'SSN_ENCRYPTED_005', '1955-08-08', 'dbrown@email.com', '555-0105',
     '654 Spruce Lane', 'Salem', 'OR', '97301', 'US', 'RETIRED', 'Portland General', 'Retired Engineer', 0, 65000.00, 740,
     'US_CITIZEN', 'MARRIED', 0),
    
    (6, 'Lisa', 'Martinez', 'Rosa', 'SSN_ENCRYPTED_006', '1987-02-14', 'lmartinez@email.com', '555-0106',
     '987 Cedar Drive', 'Bend', 'OR', '97701', 'US', 'EMPLOYED', 'Retail Co', 'Store Manager', 12, 75000.00, 650,
     'US_CITIZEN', 'SINGLE', 2),
    
    (7, 'Robert', 'Anderson', 'Charles', 'SSN_ENCRYPTED_007', '1980-09-25', 'randerson@email.com', '555-0107',
     '147 Maple Court', 'Corvallis', 'OR', '97330', 'US', 'EMPLOYED', 'Manufacturing Co', 'Plant Manager', 14, 120000.00, 710,
     'US_CITIZEN', 'DIVORCED', 1),
    
    (8, 'Patricia', 'Taylor', 'Elizabeth', 'SSN_ENCRYPTED_008', '1972-12-03', 'ptaylor@email.com', '555-0108',
     '258 Birch Way', 'Springfield', 'OR', '97477', 'US', 'EMPLOYED', 'Education District', 'Teacher', 20, 68000.00, 700,
     'US_CITIZEN', 'MARRIED', 2),
    
    (9, 'James', 'Thomas', 'Edward', 'SSN_ENCRYPTED_009', '1960-01-17', 'jthomas@email.com', '555-0109',
     '369 Hickory Hill', 'Medford', 'OR', '97501', 'US', 'RETIRED', 'US Military', 'Retired Officer', 0, 55000.00, 730,
     'US_CITIZEN', 'MARRIED', 0),
    
    (10, 'Maria', 'Garcia', 'Isabel', 'SSN_ENCRYPTED_010', '1985-06-20', 'mgarcia@email.com', '555-0110',
     '741 Willow Street', 'Salem', 'OR', '97302', 'US', 'SELF_EMPLOYED', 'Landscaping Services', 'Owner', 8, 82000.00, 665,
     'PERMANENT_RESIDENT', 'SINGLE', 1);

-- ==========================================
-- LOAN_BORROWER LINKING SEED DATA
-- ==========================================

INSERT INTO loan_borrower (loan_id, borrower_id, borrower_position, liability_percentage, is_primary_liable, signed_date, has_signed) VALUES
    (1, 1, 'PRIMARY', 100.00, TRUE, '2022-03-15', TRUE),
    (2, 2, 'PRIMARY', 100.00, TRUE, '2023-01-20', TRUE),
    (3, 3, 'PRIMARY', 100.00, TRUE, '2023-06-10', TRUE),
    (3, 4, 'CO_BORROWER', 100.00, FALSE, '2023-06-10', TRUE),
    (4, 5, 'PRIMARY', 100.00, TRUE, '2024-02-05', TRUE),
    (5, 6, 'PRIMARY', 100.00, TRUE, '2024-04-18', TRUE),
    (6, 7, 'PRIMARY', 100.00, TRUE, '2022-08-22', TRUE),
    (7, 8, 'PRIMARY', 100.00, TRUE, '2021-11-10', TRUE),
    (8, 9, 'PRIMARY', 100.00, TRUE, '2023-09-30', TRUE),
    (9, 10, 'PRIMARY', 100.00, TRUE, '2020-05-12', TRUE),
    (10, 1, 'PRIMARY', 100.00, TRUE, '2024-01-08', TRUE);

-- ==========================================
-- PROPERTY SEED DATA
-- ==========================================

INSERT INTO property (loan_id, street_address, city, state, zip_code, country, county, property_type, square_feet, lot_size_sqft,
                       year_built, num_bedrooms, num_bathrooms, occupancy_status, condition_rating, parcel_number, has_garage, 
                       garage_spaces, has_pool, has_patio) VALUES
    (1, '123 Main Street', 'Portland', 'OR', '97201', 'US', 'Multnomah', 'SINGLE_FAMILY', 2200, 7500, 1995, 4, 2.5, 'PRIMARY_RESIDENCE', 'GOOD', 'PARCEL-001', TRUE, 2, FALSE, TRUE),
    (2, '456 Oak Avenue', 'Seattle', 'WA', '98101', 'US', 'King', 'CONDO', 1800, 3000, 2005, 3, 2.0, 'PRIMARY_RESIDENCE', 'EXCELLENT', 'PARCEL-002', TRUE, 1, FALSE, FALSE),
    (3, '789 Pine Road', 'Eugene', 'OR', '97401', 'US', 'Lane', 'SINGLE_FAMILY', 3200, 12000, 1988, 5, 3.0, 'INVESTMENT_PROPERTY', 'FAIR', 'PARCEL-003', TRUE, 2, TRUE, TRUE),
    (4, '321 Elm Street', 'Vancouver', 'WA', '98660', 'US', 'Clark', 'TOWNHOUSE', 1900, 2500, 2010, 3, 2.5, 'PRIMARY_RESIDENCE', 'EXCELLENT', 'PARCEL-004', TRUE, 1, FALSE, FALSE),
    (5, '654 Spruce Lane', 'Salem', 'OR', '97301', 'US', 'Marion', 'SINGLE_FAMILY', 2100, 8000, 1992, 4, 2.0, 'PRIMARY_RESIDENCE', 'GOOD', 'PARCEL-005', TRUE, 2, FALSE, FALSE),
    (6, '987 Cedar Drive', 'Bend', 'OR', '97701', 'US', 'Deschutes', 'SINGLE_FAMILY', 1950, 6500, 2000, 3, 2.0, 'PRIMARY_RESIDENCE', 'GOOD', 'PARCEL-006', TRUE, 2, FALSE, TRUE),
    (7, '147 Maple Court', 'Corvallis', 'OR', '97330', 'US', 'Benton', 'SINGLE_FAMILY', 2400, 9000, 2002, 4, 2.5, 'PRIMARY_RESIDENCE', 'EXCELLENT', 'PARCEL-007', TRUE, 2, FALSE, FALSE),
    (8, '258 Birch Way', 'Springfield', 'OR', '97477', 'US', 'Lane', 'SINGLE_FAMILY', 2000, 7000, 1998, 3, 2.0, 'PRIMARY_RESIDENCE', 'GOOD', 'PARCEL-008', TRUE, 1, FALSE, TRUE),
    (9, '369 Hickory Hill', 'Medford', 'OR', '97501', 'US', 'Jackson', 'SINGLE_FAMILY', 2800, 11000, 1985, 5, 3.0, 'INVESTMENT_PROPERTY', 'FAIR', 'PARCEL-009', TRUE, 2, FALSE, FALSE),
    (10, '741 Willow Street', 'Salem', 'OR', '97302', 'US', 'Marion', 'SINGLE_FAMILY', 2100, 7500, 2001, 4, 2.0, 'PRIMARY_RESIDENCE', 'GOOD', 'PARCEL-010', TRUE, 2, TRUE, FALSE);

-- ==========================================
-- VALUATIONS SEED DATA
-- ==========================================

INSERT INTO valuations (loan_id, property_id, valuation_type, property_value, original_property_value, current_loan_balance, 
                        loan_to_value, valuation_date, appraiser_name, appraiser_license_number, market_conditions_description) VALUES
    (1, 1, 'APPRAISAL', 450000.00, 420000.00, 340000.00, 75.56, '2022-03-01', 'John Appraisal Inc', 'LIC-001', 'Strong market'),
    (2, 2, 'APPRAISAL', 380000.00, 360000.00, 270000.00, 71.05, '2023-01-15', 'Jane Valuations LLC', 'LIC-002', 'Steady market'),
    (3, 3, 'APPRAISAL', 550000.00, 500000.00, 410000.00, 74.55, '2023-06-01', 'Bob Appraisals', 'LIC-003', 'Strong market'),
    (4, 4, 'AVM', 420000.00, 400000.00, 305000.00, 72.62, '2024-02-01', NULL, NULL, 'Moderate market'),
    (5, 5, 'APPRAISAL', 380000.00, 380000.00, NULL, 72.37, '2024-04-01', 'Susan Appraisals', 'LIC-004', 'Moderate market'),
    (6, 6, 'APPRAISAL', 320000.00, 300000.00, 170000.00, 56.25, '2022-08-15', 'Mike Values', 'LIC-005', 'Good market'),
    (7, 7, 'APPRAISAL', 410000.00, 390000.00, 185000.00, 45.12, '2021-10-20', 'Chris Valuations', 'LIC-006', 'Strong market'),
    (8, 8, 'APPRAISAL', 620000.00, 550000.00, 475000.00, 76.61, '2023-09-10', 'Diana Appraisals', 'LIC-007', 'Excellent market'),
    (9, 9, 'APPRAISAL', 360000.00, 330000.00, 240000.00, 66.67, '2020-04-20', 'Edward Values', 'LIC-008', 'Soft market'),
    (10, 10, 'APPRAISAL', 420000.00, 420000.00, 330000.00, 78.57, '2024-01-01', 'Fiona Appraisals', 'LIC-009', 'Strong market');

-- ==========================================
-- INVESTORS SEED DATA
-- ==========================================

INSERT INTO investor (investor_id, investor_name, investor_type, contact_email, contact_phone, street_address, city, state, zip_code,
                     tax_id, registration_number, mlo_license_number, is_active, is_approved, approval_date,
                     credit_rating, risk_level) VALUES
    (1, 'First National Bank', 'BANK', 'portfolio@fnb.com', '503-555-0001', '100 Financial Tower', 'Portland', 'OR', '97201',
     'TAX-001', 'REG-001', 'MLO-001', TRUE, TRUE, '2020-01-01', 'AAA', 'LOW'),
    
    (2, 'Pacific Credit Union', 'CREDIT_UNION', 'loans@pcu.com', '503-555-0002', '200 Credit Lane', 'Eugene', 'OR', '97401',
     'TAX-002', 'REG-002', 'MLO-002', TRUE, TRUE, '2020-06-15', 'AA', 'LOW'),
    
    (3, 'Westside Mortgage Group', 'INDIVIDUAL', 'contact@wsmg.com', '206-555-0003', '300 Mortgage Way', 'Seattle', 'WA', '98101',
     'TAX-003', 'REG-003', 'MLO-003', TRUE, TRUE, '2019-03-10', 'A', 'MEDIUM'),
    
    (4, 'Housing Investment Fund', 'HEDGE_FUND', 'investors@hif.com', '415-555-0004', '400 Investment Blvd', 'San Francisco', 'CA', '94105',
     'TAX-004', 'REG-004', 'MLO-004', TRUE, TRUE, '2021-05-20', 'AA', 'MEDIUM'),
    
    (5, 'Retired Teachers Pension', 'PENSION_FUND', 'portfolio@rtp.org', '503-555-0005', '500 Pension Lane', 'Salem', 'OR', '97301',
     'TAX-005', 'REG-005', NULL, TRUE, TRUE, '2018-01-15', 'AAA', 'LOW');

-- ==========================================
-- LOAN_INVESTOR_ASSIGNMENT SEED DATA
-- ==========================================

INSERT INTO loan_investor_assignment (loan_id, investor_id, assignment_date, ownership_percentage, assigned_principal_balance, 
                                      assignment_type, is_active) VALUES
    (1, 1, '2022-03-15', 100.00, 350000.00, 'ORIGINATION', TRUE),
    (2, 2, '2023-01-20', 100.00, 280000.00, 'ORIGINATION', TRUE),
    (3, 1, '2023-06-10', 50.00, 212500.00, 'SYNDICATION', TRUE),
    (3, 4, '2023-06-10', 50.00, 212500.00, 'SYNDICATION', TRUE),
    (4, 2, '2024-02-05', 100.00, 320000.00, 'ORIGINATION', TRUE),
    (5, 1, '2024-04-18', 100.00, 275000.00, 'ORIGINATION', TRUE),
    (6, 3, '2022-08-22', 100.00, 180000.00, 'ORIGINATION', TRUE),
    (7, 2, '2021-11-10', 100.00, 195000.00, 'ORIGINATION', TRUE),
    (8, 5, '2023-09-30', 100.00, 500000.00, 'ORIGINATION', TRUE),
    (9, 1, '2020-05-12', 100.00, 250000.00, 'ORIGINATION', TRUE),
    (10, 2, '2024-01-08', 100.00, 350000.00, 'ORIGINATION', TRUE);

-- ==========================================
-- INSURERS SEED DATA
-- ==========================================

INSERT INTO insurer (insurer_id, insurer_name, insurer_type, contact_email, contact_phone, street_address, city, state, zip_code,
                    tax_id, license_number, is_active) VALUES
    (1, 'FHA Insurance Corp', 'FHA', 'fha@fhaic.gov', '202-555-0001', '1 HUD Plaza', 'Washington', 'DC', '20410',
     'TAX-FHA-001', 'LIC-FHA-001', TRUE),
    
    (2, 'PMI Plus Insurance', 'PMI_PROVIDER', 'contact@pmiplus.com', '212-555-0002', '500 PMI Street', 'New York', 'NY', '10001',
     'TAX-PMI-001', 'LIC-PMI-001', TRUE),
    
    (3, 'USDA Guarantee', 'USDA', 'loans@usda.gov', '202-555-0003', '1400 Independence Ave', 'Washington', 'DC', '20250',
     'TAX-USDA-001', 'LIC-USDA-001', TRUE),
    
    (4, 'Mortgage Guaranty Inc', 'PMI_PROVIDER', 'mgi@mgi.com', '414-555-0004', '600 MGI Plaza', 'Milwaukee', 'WI', '53202',
     'TAX-MGI-001', 'LIC-MGI-001', TRUE),
    
    (5, 'Radian Mortgage', 'PMI_PROVIDER', 'radian@radian.com', '215-555-0005', '700 Radian Plaza', 'Philadelphia', 'PA', '19101',
     'TAX-RAD-001', 'LIC-RAD-001', TRUE);

-- ==========================================
-- LOAN_INSURER SEED DATA
-- ==========================================

INSERT INTO loan_insurer (loan_id, insurer_id, insurance_type, premium_amount, monthly_premium, policy_number,
                         effective_date, expiration_date, insurance_status) VALUES
    (1, 2, 'PRIMARY_MORTGAGE_INSURANCE', 8750.00, 72.92, 'POL-001', '2022-03-15', '2027-03-15', 'ACTIVE'),
    (2, 1, 'GOVERNMENT_INSURANCE', 7840.00, 65.33, 'POL-002', '2023-01-20', '2028-01-20', 'ACTIVE'),
    (3, 2, 'PRIMARY_MORTGAGE_INSURANCE', 9450.00, 78.75, 'POL-003', '2023-06-10', '2028-06-10', 'ACTIVE'),
    (4, 4, 'PRIMARY_MORTGAGE_INSURANCE', 7200.00, 60.00, 'POL-004', '2024-02-05', '2029-02-05', 'ACTIVE'),
    (5, 2, 'SECONDARY_MORTGAGE_INSURANCE', 6160.00, 51.33, 'POL-005', '2024-04-18', '2029-04-18', 'ACTIVE'),
    (6, 5, 'PRIMARY_MORTGAGE_INSURANCE', 6300.00, 52.50, 'POL-006', '2022-08-22', '2027-08-22', 'ACTIVE'),
    (7, 3, 'GOVERNMENT_INSURANCE', 5850.00, 48.75, 'POL-007', '2021-11-10', '2026-11-10', 'EXPIRED'),
    (8, 2, 'PRIMARY_MORTGAGE_INSURANCE', 14000.00, 116.67, 'POL-008', '2023-09-30', '2028-09-30', 'ACTIVE'),
    (9, 1, 'GOVERNMENT_INSURANCE', 8750.00, 72.92, 'POL-009', '2020-05-12', '2025-05-12', 'INACTIVE'),
    (10, 2, 'PRIMARY_MORTGAGE_INSURANCE', 9800.00, 81.67, 'POL-010', '2024-01-08', '2029-01-08', 'ACTIVE');

-- ==========================================
-- LOAN STATUS HISTORY SEED DATA
-- ==========================================

INSERT INTO loan_status_history (loan_id, loan_status, status_date, reason) VALUES
    (1, 'ORIGINATED', '2022-03-15', 'Initial origination'),
    (1, 'ACTIVE', '2022-04-15', 'First payment received'),
    (2, 'ORIGINATED', '2023-01-20', 'Initial origination'),
    (2, 'ACTIVE', '2023-02-20', 'First payment received'),
    (3, 'ORIGINATED', '2023-06-10', 'Initial origination'),
    (3, 'ACTIVE', '2023-07-10', 'First payment received'),
    (3, 'DELINQUENT', '2024-03-15', 'Payment 30+ days late'),
    (4, 'ORIGINATED', '2024-02-05', 'Initial origination'),
    (5, 'ORIGINATED', '2024-04-18', 'Initial origination'),
    (6, 'ORIGINATED', '2022-08-22', 'Initial origination'),
    (6, 'ACTIVE', '2022-09-22', 'First payment received'),
    (6, 'PAID_OFF', '2030-08-22', 'Loan matured - paid in full'),
    (7, 'ORIGINATED', '2021-11-10', 'Initial origination'),
    (7, 'ACTIVE', '2021-12-10', 'First payment received'),
    (7, 'PAID_OFF', '2051-11-10', 'Loan matured'),
    (8, 'ORIGINATED', '2023-09-30', 'Initial origination'),
    (8, 'ACTIVE', '2023-10-30', 'First payment received'),
    (9, 'ORIGINATED', '2020-05-12', 'Initial origination'),
    (9, 'ACTIVE', '2020-06-12', 'First payment received'),
    (9, 'DELINQUENT', '2021-02-15', 'Payment 60+ days late'),
    (9, 'FORECLOSURE', '2021-04-01', 'Foreclosure initiated'),
    (10, 'ORIGINATED', '2024-01-08', 'Initial origination'),
    (10, 'ACTIVE', '2024-02-08', 'First payment received');

-- ==========================================
-- LOAN TERMS SEED DATA
-- ==========================================

INSERT INTO loan_terms (loan_id, interest_rate, annual_percentage_rate, rate_type, initial_rate_period_months,
                       disclosure_date, rate_lock_date) VALUES
    (1, 6.50, 6.75, 'FIXED', NULL, '2022-03-01', '2022-03-10'),
    (2, 6.00, 6.25, 'FIXED', NULL, '2023-01-10', '2023-01-18'),
    (3, 5.80, 6.10, 'ARM', 120, '2023-06-01', '2023-06-08'),
    (4, 6.25, 6.50, 'FIXED', NULL, '2024-01-25', '2024-02-03'),
    (5, 6.75, 7.00, 'FIXED', NULL, '2024-04-01', '2024-04-15'),
    (6, 5.50, 5.85, 'BALLOON', NULL, '2022-08-10', '2022-08-20'),
    (7, 3.50, 3.75, 'FIXED', NULL, '2021-11-01', '2021-11-08'),
    (8, 5.25, 5.50, 'FIXED', NULL, '2023-09-15', '2023-09-25'),
    (9, 4.75, 5.00, 'FIXED', NULL, '2020-05-01', '2020-05-10'),
    (10, 6.00, 6.25, 'FIXED', NULL, '2024-01-01', '2024-01-05');

-- ==========================================
-- UNDERWRITING SEED DATA
-- ==========================================

INSERT INTO underwriting (loan_id, application_date, underwriting_status, approval_date, approved_by,
                         debt_to_income_ratio, loan_to_value_ratio, credit_score_at_application,
                         property_appraisal_value, requested_loan_amount, approved_loan_amount,
                         loan_purpose, occupancy_type, employment_verified, income_verified,
                         verified_income, income_verification_date) VALUES
    (1, '2022-02-15', 'APPROVED', '2022-03-10', 'Ann Martinez', 28.5, 75.56, 750, 450000.00, 350000.00, 350000.00,
     'PURCHASE', 'PRIMARY_RESIDENCE', TRUE, TRUE, 125000.00, '2022-02-20'),
    
    (2, '2023-01-05', 'APPROVED', '2023-01-18', 'Bob Johnson', 31.2, 71.05, 780, 380000.00, 280000.00, 280000.00,
     'PURCHASE', 'PRIMARY_RESIDENCE', TRUE, TRUE, 95000.00, '2023-01-10'),
    
    (3, '2023-05-20', 'APPROVED', '2023-06-05', 'Carol Smith', 35.8, 74.55, 720, 550000.00, 425000.00, 425000.00,
     'PURCHASE', 'INVESTMENT_PROPERTY', TRUE, TRUE, 150000.00, '2023-05-25'),
    
    (4, '2024-01-15', 'APPROVED', '2024-02-02', 'David Lee', 29.3, 72.62, 690, 420000.00, 320000.00, 320000.00,
     'PURCHASE', 'PRIMARY_RESIDENCE', TRUE, TRUE, 85000.00, '2024-01-20'),
    
    (5, '2024-04-01', 'CONDITIONAL_APPROVAL', '2024-04-15', 'Emily Chen', 26.5, 72.37, 665, 380000.00, 275000.00, 275000.00,
     'PURCHASE', 'PRIMARY_RESIDENCE', TRUE, FALSE, 82000.00, '2024-04-10'),
    
    (6, '2022-08-01', 'APPROVED', '2022-08-18', 'Frank Wilson', 24.3, 56.25, 740, 320000.00, 180000.00, 180000.00,
     'REFINANCE', 'PRIMARY_RESIDENCE', TRUE, TRUE, 155000.00, '2022-08-05'),
    
    (7, '2021-10-05', 'APPROVED', '2021-11-08', 'Grace Taylor', 32.1, 45.12, 710, 410000.00, 195000.00, 195000.00,
     'PURCHASE', 'PRIMARY_RESIDENCE', TRUE, TRUE, 120000.00, '2021-10-10'),
    
    (8, '2023-09-01', 'APPROVED', '2023-09-22', 'Henry Adams', 38.5, 76.61, 700, 620000.00, 500000.00, 500000.00,
     'CASH_OUT_REFI', 'PRIMARY_RESIDENCE', TRUE, TRUE, 145000.00, '2023-09-05'),
    
    (9, '2020-04-10', 'APPROVED', '2020-05-05', 'Isabella Rossi', 36.2, 66.67, 680, 360000.00, 250000.00, 250000.00,
     'PURCHASE', 'INVESTMENT_PROPERTY', TRUE, TRUE, 98000.00, '2020-04-15'),
    
    (10, '2023-12-15', 'APPROVED', '2024-01-08', 'James Murphy', 27.8, 78.57, 755, 420000.00, 350000.00, 350000.00,
     'PURCHASE', 'PRIMARY_RESIDENCE', TRUE, TRUE, 128000.00, '2023-12-20');

-- ==========================================
-- PAYMENT SCHEDULE SEED DATA (Sample for Loan 1)
-- ==========================================

INSERT INTO payment_schedule (loan_id, payment_number, scheduled_payment_date, scheduled_payment_amount,
                             scheduled_principal_amount, scheduled_interest_amount, balance_before_payment,
                             balance_after_payment, payment_status) VALUES
    (1, 1, '2022-04-15', 2156.89, 689.45, 1467.44, 350000.00, 349310.55, 'PAID'),
    (1, 2, '2022-05-15', 2156.89, 691.89, 1464.99, 349310.55, 348618.66, 'PAID'),
    (1, 3, '2022-06-15', 2156.89, 694.35, 1462.54, 348618.66, 347924.31, 'PAID'),
    (1, 4, '2022-07-15', 2156.89, 696.82, 1460.07, 347924.31, 347227.49, 'PAID'),
    (1, 5, '2022-08-15', 2156.89, 699.30, 1457.59, 347227.49, 346528.19, 'PAID'),
    (1, 6, '2022-09-15', 2156.89, 701.80, 1455.09, 346528.19, 345826.39, 'PAID'),
    (1, 7, '2022-10-15', 2156.89, 704.31, 1452.58, 345826.39, 345122.08, 'PAID'),
    (1, 8, '2022-11-15', 2156.89, 706.84, 1450.05, 345122.08, 344415.24, 'PAID'),
    (1, 9, '2022-12-15', 2156.89, 709.38, 1447.51, 344415.24, 343705.86, 'PAID'),
    (1, 10, '2023-01-15', 2156.89, 711.94, 1444.95, 343705.86, 342993.92, 'PAID');

-- ==========================================
-- PAYMENT TRANSACTIONS SEED DATA
-- ==========================================

INSERT INTO payment_transactions (loan_id, payment_date, principal_paid, interest_paid, escrow_paid, late_fees_paid, total_paid, 
                                 payment_method, reference_number, payer_name) VALUES
    (1, '2022-04-15', 689.45, 1467.44, 0.00, 0.00, 2156.89, 'ACH', 'REF-2022-04-001', 'John Smith'),
    (1, '2022-05-15', 691.89, 1464.99, 0.00, 0.00, 2156.89, 'ACH', 'REF-2022-05-001', 'John Smith'),
    (2, '2023-02-20', 500.00, 933.33, 0.00, 0.00, 1433.33, 'CHECK', 'CHK-001', 'Sarah Johnson'),
    (2, '2023-03-20', 502.50, 930.83, 0.00, 0.00, 1433.33, 'AUTO_PAY', 'AUTO-001', 'Sarah Johnson'),
    (3, '2023-07-30', 945.33, 1581.67, 250.00, 0.00, 2777.00, 'WIRE_TRANSFER', 'WIRE-001', 'Michael Davis'),
    (4, '2024-03-10', 750.00, 1200.00, 200.00, 0.00, 2150.00, 'ACH', 'REF-2024-03-001', 'Jennifer Wilson'),
    (6, '2022-10-15', 800.00, 700.00, 300.00, 0.00, 1800.00, 'CHECK', 'CHK-002', 'Robert Anderson'),
    (8, '2023-11-15', 1500.00, 2000.00, 400.00, 0.00, 3900.00, 'WIRE_TRANSFER', 'WIRE-002', 'James Thomas'),
    (9, '2020-07-15', 600.00, 1000.00, 0.00, 0.00, 1600.00, 'ACH', 'REF-2020-07-001', 'Maria Garcia'),
    (10, '2024-02-20', 850.00, 1400.00, 300.00, 0.00, 2550.00, 'AUTO_PAY', 'AUTO-002', 'John Smith');

-- ==========================================
-- ESCROW SEED DATA
-- ==========================================

INSERT INTO escrow (loan_id, escrow_type, description, monthly_payment_amount, due_date, paid_date, next_payment_date,
                   recipient_name, recipient_address, recipient_city, recipient_state, recipient_zip_code,
                   recipient_account_number, recipient_tax_id, payment_status) VALUES
    (1, 'PROPERTY_TAX', 'Annual property taxes', 400.00, '2023-12-31', '2023-12-15', '2024-12-31',
     'Multnomah County', '501 SE Hawthorne Blvd', 'Portland', 'OR', '97214', 'ACCT-PT-001', 'TAX-001', 'PAID'),
    
    (1, 'HOMEOWNERS_INSURANCE', 'Annual homeowners insurance', 150.00, '2024-03-31', NULL, '2024-03-31',
     'Standard Insurance Co', '2500 E Broad St', 'Portland', 'OR', '97204', 'ACCT-INS-001', 'TAX-INS-001', 'PENDING'),
    
    (2, 'PROPERTY_TAX', 'Annual property taxes', 350.00, '2024-02-29', NULL, '2024-02-29',
     'King County Assessor', 'Regional Justice Center', 'Seattle', 'WA', '98104', 'ACCT-PT-002', 'TAX-002', 'OVERDUE'),
    
    (3, 'HOA_FEES', 'HOA membership dues', 250.00, '2024-01-15', '2024-01-10', '2024-02-15',
     'Cedar Ridge HOA', '800 Oak Lane', 'Eugene', 'OR', '97401', 'ACCT-HOA-001', 'TAX-HOA-001', 'PAID'),
    
    (4, 'PROPERTY_TAX', 'Annual property taxes', 325.00, '2024-06-30', NULL, '2024-06-30',
     'Clark County Assessor', '1220 8th Ave', 'Vancouver', 'WA', '98660', 'ACCT-PT-003', 'TAX-003', 'PENDING');

-- ==========================================
-- DELINQUENCY SEED DATA
-- ==========================================

INSERT INTO delinquency (loan_id, delinquent_date, days_delinquent, delinquency_status,
                        delinquent_principal_amount, delinquent_interest_amount, late_fees_charged,
                        collection_attempts, forbearance_granted, resolution_type) VALUES
    (3, '2024-03-15', 45, 'ACTIVE', 500.00, 250.00, 75.00, 3, FALSE, NULL),
    (9, '2021-02-15', 60, 'RESOLVED', 2000.00, 800.00, 200.00, 5, TRUE, 'MODIFICATION');

-- ==========================================
-- DOCUMENTS SEED DATA
-- ==========================================

INSERT INTO documents (loan_id, document_type, description, file_name, file_url, document_date, upload_date,
                      uploaded_by, is_required_for_closing, is_received) VALUES
    (1, 'PROMISSORY_NOTE', 'Signed promissory note', 'note_ln001.pdf', 's3://docs/ln001/note.pdf',
     '2022-03-15', '2022-03-15', 'Underwriter Smith', TRUE, TRUE),
    
    (1, 'DEED_OF_TRUST', 'Recorded deed of trust', 'dot_ln001.pdf', 's3://docs/ln001/dot.pdf',
     '2022-03-18', '2022-03-18', 'Closer Johnson', TRUE, TRUE),
    
    (1, 'APPRAISAL', 'Property appraisal report', 'appraisal_ln001.pdf', 's3://docs/ln001/appraisal.pdf',
     '2022-03-01', '2022-03-05', 'Appraiser Williams', TRUE, TRUE),
    
    (2, 'PROMISSORY_NOTE', 'Signed promissory note', 'note_ln002.pdf', 's3://docs/ln002/note.pdf',
     '2023-01-20', '2023-01-20', 'Underwriter Chen', TRUE, TRUE),
    
    (3, 'CLOSING_DISCLOSURE', 'Final closing disclosure', 'cd_ln003.pdf', 's3://docs/ln003/cd.pdf',
     '2023-06-10', '2023-06-10', 'Closer Martinez', TRUE, TRUE);

-- ==========================================
-- FORECLOSURE SEED DATA
-- ==========================================

INSERT INTO foreclosure (loan_id, property_id, foreclosure_initiation_date, foreclosure_status, foreclosure_type,
                        attorney_name, attorney_phone, attorney_email, court_name, court_jurisdiction, case_number,
                        notice_of_default_date, notice_of_sale_date, foreclosure_sale_date, foreclosure_outcome) VALUES
    (9, 9, '2021-04-01', 'COMPLETED', 'JUDICIAL', 'Robert Jackson & Associates', '541-555-0100',
     'robert@lawfirm.com', 'Jackson County Circuit Court', 'Jackson County, OR', 'CASE-2021-0001',
     '2021-03-15', '2021-05-01', '2021-07-15', 'PROPERTY_SOLD');

-- ==========================================
-- BANKRUPTCY SEED DATA
-- ==========================================

INSERT INTO bankruptcy (bankruptcy_id, borrower_id, bankruptcy_filing_date, bankruptcy_status, bankruptcy_type, bankruptcy_case_number,
                       court_name, court_jurisdiction, trustee_name, trustee_phone, meeting_date_341, discharge_date) VALUES
    (1, 10, '2022-06-15', 'DISCHARGED', 'CHAPTER_13', 'BC-2022-001', 'US Bankruptcy Court District of Oregon',
     'Portland, OR', 'James Bankruptcy Trustee', '503-555-0200', '2022-07-20', '2027-06-15');

-- ==========================================
-- LOAN_BANKRUPTCY SEED DATA
-- ==========================================

INSERT INTO loan_bankruptcy (loan_id, bankruptcy_id, discharge_status, debt_amount_at_filing, current_loan_balance,
                            proof_of_claim_filed, proof_of_claim_date) VALUES
    (5, 1, 'REAFFIRMED', 275000.00, 265000.00, TRUE, '2022-07-15');

-- Commit successful seed data load
COMMIT;
