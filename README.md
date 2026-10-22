# LoanCoin
Personal Loan Servicing Interface

## Database Schema
This repository contains SQL files for building a mortgage platform with PostgreSQL on Supabase.

### Schema Documentation
For detailed schema information, see [SCHEMA_DOCUMENTATION.md](./SCHEMA_DOCUMENTATION.md)

### Quick Start Files
- **`MAIN.sql`** - Complete schema with all 22 tables (use this to create entire schema at once)
- **`MAIN_SEED.sql`** - Comprehensive seed data with wide range of realistic scenarios (10 borrowers, 10 loans at various lifecycle stages)

### Individual SQL Files
- `Create_Table_Loan_Type_wSeed.sql` - Loan type lookup table
- `Create_Table_Loan.sql` - Core loan origination data
- `Create_Table_Borrower_Details.sql` - Borrower information
- `Create_Table_Loan_Borrower.sql` - Junction table linking borrowers to loans with their position
- `Create_Table_Property.sql` - Property details
- `Create_Table_Valuations.sql` - Property valuations and appraisals
- `Create_Table_Comparables.sql` - Comparable property sales data
- `Create_Table_Escrow.sql` - Escrow account management
- `Create_Table_Investor.sql` - Loan investors and investor assignments
- `Create_Table_Insurer.sql` - Mortgage insurance providers and loan insurance assignments
- `Create_Table_Loan_Status_History.sql` - Loan status tracking and history
- `Create_Table_Payment_Schedule.sql` - Amortization schedule
- `Create_Table_Payment_Transactions.sql` - Actual payments received
- `Create_Table_Loan_Terms.sql` - Interest rates and pricing details
- `Create_Table_Documents.sql` - Document management and compliance
- `Create_Table_Underwriting.sql` - Loan application and approval tracking
- `Create_Table_Delinquency.sql` - Delinquency and late payment tracking
- `Create_Table_Audit_Log.sql` - Audit trail for compliance
- `Create_Table_Foreclosure.sql` - Foreclosure proceedings
- `Create_Table_Bankruptcy.sql` - Bankruptcy filings and loan impact

### Setup
Execute the SQL files in the order listed above to build the complete schema.

### Recommended Usage
**For complete setup:**
1. Run `MAIN.sql` to create all tables in the correct order
2. Run `MAIN_SEED.sql` to populate with test data

**For development:**
- Individual `Create_Table_*.sql` files can be executed independently for specific tables
