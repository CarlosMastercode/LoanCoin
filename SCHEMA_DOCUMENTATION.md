# LoanCoin Mortgage Platform - Database Schema Documentation

## Project Overview
Building a mortgage platform with PostgreSQL on Supabase. The schema supports:
- Multiple borrowers per loan
- Properties (one per loan)
- Valuations with comparable sales data
- Escrow management (property tax, insurance, HOA fees)
- Multiple investors and insurance providers per loan

---

## Core Tables

### `loan_type` (Existing)
- Lookup table for loan types (FHA, CONVENTIONAL, VA, USDA, HELOC, AUTO, BOAT, EQUIPMENT, PERSONAL, COMMERCIAL)
- Seeded with common loan types

### `loan` (Existing)
- Immutable origination data
- References `loan_type_id`
- Key fields: `loan_number`, `origination_date`, `first_payment_date`, `original_maturity_date`, `original_balance`, `original_term_months`, `interest_calculation_method` (FIXED, ARM, BALLOON, INTEREST_ONLY)

---

## Borrower Tables

### `borrower_details` 
- Core borrower information (reusable across loans)
- Key fields:
  - `first_name`, `last_name`, `middle_name`
  - `ssn_encrypted` (for PII security)
  - `date_of_birth`, `email_address`, `phone_number`
  - **Mailing Address** (not property address)
  - `employment_status`, `employer_name`, `job_title`, `years_employed`, `annual_income`
  - `credit_score`, `citizenship_status`, `marital_status`, `num_dependents`
- **Note:** Borrower position is NOT here (see loan_borrower below)

### `loan_borrower` (Junction Table)
- Links borrowers to loans with their position on **that specific loan**
- Key fields:
  - `loan_id`, `borrower_id`
  - `borrower_position` (PRIMARY, CO_BORROWER, GUARANTOR)
  - `liability_percentage`, `is_primary_liable`
  - `signed_date`, `has_signed`
  - Unique constraint: only one PRIMARY per loan
- **Why separate?** A borrower could be PRIMARY on one property, CO_BORROWER on another

---

## Property Table

### `property`
- One property per loan (UNIQUE loan_id)
- Key fields:
  - **Address:** `street_address`, `city`, `state`, `zip_code`, `country`, `county`
  - **Property details:** `property_type`, `square_feet`, `lot_size_sqft`, `year_built`, `num_bedrooms`, `num_bathrooms`
  - **Characteristics:** `occupancy_status` (PRIMARY_RESIDENCE, SECOND_HOME, INVESTMENT_PROPERTY), `condition_rating`
  - **Legal info:** `parcel_number`, `legal_description`
  - **Features:** `has_garage`, `garage_spaces`, `has_pool`, `has_patio`
- **Why separate from borrower?** One borrower may own multiple properties

---

## Valuation & Comparables

### `valuations`
- Links to `loan_id` and `property_id`
- Key fields:
  - `valuation_type` (APPRAISAL, AVM, BROKER_PRICE_OPINION, AUTOMATED_VALUATION, DESK_REVIEW)
  - `property_value`, `original_property_value`
  - `loan_amount`, `loan_to_value` (0-125%)
  - `valuation_date`, `appraiser_name`, `appraiser_license_number`
  - `market_conditions_description`

### `comparables`
- Comparable property sales data for valuations
- Key fields:
  - `valuation_id` (FK - each comparable tied to one valuation)
  - **Address & Geo:** `street_address`, `city`, `state`, `zip_code`, `latitude`, `longitude`
  - **Property details:** `property_type`, `square_feet`, `lot_size_sqft`, `year_built`, `num_bedrooms`, `num_bathrooms`
  - **Sale info:** `sale_price`, `sale_date`, `days_on_market`
  - **Market data:** `price_per_sqft`, `price_per_lot_sqft`
  - **Source:** `mls_number`, `data_source`
  - `condition_rating`, `notes`
- **Why separate table?** Comparable data is reusable for general market analysis even after valuation

---

## Escrow Table

### `escrow`
- Holds escrow amounts and tracks payments for taxes, insurance, HOA fees
- Key fields:
  - `loan_id` (FK)
  - `escrow_type` (PROPERTY_TAX, HOMEOWNERS_INSURANCE, MORTGAGE_INSURANCE, HOA_FEES, OTHER)
  - `monthly_payment_amount` (no balance here - accounting handles that)
  - **Due dates:** `due_date`, `paid_date`, `next_payment_date`
  - **Recipient:** `recipient_name`, `recipient_address`, `recipient_city`, `recipient_state`, `recipient_zip_code`, `recipient_country`, `recipient_email`, `recipient_phone`
  - **Account info:** `recipient_account_number`, `recipient_tax_id`
  - `payment_status` (PENDING, PAID, PARTIALLY_PAID, OVERDUE, CANCELLED)
- **Note:** `escrow_balance` removed - accounting system tracks actual balances

---

## Investor & Insurance Tables

### `investor`
- Loan investors/ownership information
- Key fields:
  - `investor_name`, `investor_type` (BANK, CREDIT_UNION, INSURANCE_COMPANY, PENSION_FUND, HEDGE_FUND, INDIVIDUAL, OTHER)
  - **Contact:** `contact_email`, `contact_phone`
  - **Address:** `street_address`, `city`, `state`, `zip_code`, `country`
  - **Business:** `tax_id`, `registration_number`
  - **Licensing:** `mlo_license_number`, `broker_dealer_license`
  - `is_active`, `is_approved`, `approval_date`
  - **Rating:** `credit_rating`, `risk_level` (LOW, MEDIUM, HIGH, UNRATED)
  - `parent_company_id` (self-referencing for corporate hierarchies)
- **Note:** Removed calculated fields (`total_portfolio_value`, `mortgage_loans_held`) - derive from queries instead

### `loan_investor_assignment`
- Links loans to investors (enables multiple investors per loan)
- Key fields:
  - `loan_id`, `investor_id`
  - `assignment_date`, `ownership_percentage`
  - `assigned_principal_balance`
  - `assignment_type` (ORIGINATION, SALE, TRANSFER, SYNDICATION)
  - `is_active` (allows tracking historical assignments)
  - Unique constraint: only one active assignment per loan/investor pair

### `insurer`
- Mortgage insurance providers (FHA, USDA, VA, PMI providers)
- Key fields:
  - `insurer_name`, `insurer_type` (FHA, USDA, VA, PMI_PROVIDER, OTHER)
  - **Contact & Address:** Similar to investor
  - `license_number`
  - `is_active`
- **Why separate from investor?** Loans can have multiple insurers (FHA + PMI, for example)

### `loan_insurer`
- Links loans to insurers (enables multiple insurers per loan)
- Key fields:
  - `loan_id`, `insurer_id`
  - `insurance_type` (PRIMARY_MORTGAGE_INSURANCE, SECONDARY_MORTGAGE_INSURANCE, GOVERNMENT_INSURANCE, LENDER_PLACED_INSURANCE)
  - `premium_amount`, `monthly_premium`, `policy_number`
  - **Dates:** `effective_date`, `expiration_date`, `cancellation_date`
  - `insurance_status` (ACTIVE, INACTIVE, CANCELLED, EXPIRED)

---

## Files Created

```
Create_Table_Loan_Type_wSeed.sql          (existing)
Create_Table_Loan.sql                     (existing)
Create_Table_Borrower_Details.sql         (new)
Create_Table_Loan_Borrower.sql            (new)
Create_Table_Property.sql                 (new)
Create_Table_Valuations.sql               (new)
Create_Table_Comparables.sql              (new)
Create_Table_Escrow.sql                   (new)
Create_Table_Investor.sql                 (new)
Create_Table_Insurer.sql                  (new)
```

---

## Key Design Decisions

1. **Borrower Position in Junction Table** — A borrower's position (PRIMARY, CO_BORROWER, GUARANTOR) is specific to a loan, not a borrower attribute, since the same person could have different roles across properties.

2. **Property as Separate Table** — Properties are separate from borrowers because one borrower can own multiple properties, and one property can have multiple borrowers.

3. **Comparables Data Persistence** — Comparable sales data is stored permanently for market analysis reuse, not just for the valuation it supports.

4. **Escrow Without Balance** — `escrow_balance` is not stored in the escrow table; accounting system maintains daily balances based on activity.

5. **Multiple Investors & Insurers** — Junction tables (`loan_investor_assignment`, `loan_insurer`) enable syndication scenarios where loans have multiple owners and insurance providers.

6. **Geo-Coordinates for Comparables** — Added `latitude`/`longitude` to comparables for geographic analysis and mapping capabilities.

---

## Pending: Accounting/Ledger System

Not yet created. Will need:
- **Accounting/Ledger Table** — Daily financial transactions (principal, interest, escrow, adjustments)
- **Activity/Events Table** — Tracks loan activity that triggers accounting entries
- **ETL Process** — Daily population of accounting entries from loan activity

Details to be determined in next session.

---

## Next Steps

1. Create accounting/ledger tables
2. Add payment tracking table(s) if not already planned
3. Consider loan servicing/status tracking table
4. Add documentation for ETL/accounting logic
