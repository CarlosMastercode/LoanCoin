'use client'

import { useState } from 'react'
import Link from 'next/link'
import { supabase } from '@/lib/supabase'
import styles from './apply.module.css'

type Step = 'borrower' | 'property' | 'loan' | 'success'

interface BorrowerForm {
  first_name: string
  last_name: string
  email_address: string
  phone_number: string
  date_of_birth: string
  mailing_street_address: string
  mailing_city: string
  mailing_state: string
  mailing_zip_code: string
  employment_status: string
  employer_name: string
  annual_income: string
  credit_score: string
}

interface LoanForm {
  original_balance: string
  original_term_months: string
  interest_calculation_method: string
  loan_purpose: string
}

const STATES = [
  'AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA',
  'KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ',
  'NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT',
  'VA','WA','WV','WI','WY',
]

export default function ApplyPage() {
  const [step, setStep] = useState<Step>('borrower')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [loanNumber, setLoanNumber] = useState<string | null>(null)

  const [borrower, setBorrower] = useState<BorrowerForm>({
    first_name: '', last_name: '', email_address: '', phone_number: '',
    date_of_birth: '', mailing_street_address: '', mailing_city: '',
    mailing_state: '', mailing_zip_code: '', employment_status: '',
    employer_name: '', annual_income: '', credit_score: '',
  })

  const [loan, setLoan] = useState<LoanForm>({
    original_balance: '', original_term_months: '360',
    interest_calculation_method: 'FIXED', loan_purpose: 'PURCHASE',
  })

  function updateBorrower(field: keyof BorrowerForm, value: string) {
    setBorrower(prev => ({ ...prev, [field]: value }))
  }

  function updateLoan(field: keyof LoanForm, value: string) {
    setLoan(prev => ({ ...prev, [field]: value }))
  }

  async function handleSubmit() {
    setLoading(true)
    setError(null)

    try {
      // 1. Insert borrower_details
      const { data: borrowerData, error: borrowerError } = await supabase
        .from('borrower_details')
        .insert({
          first_name: borrower.first_name,
          last_name: borrower.last_name,
          email_address: borrower.email_address || null,
          phone_number: borrower.phone_number || null,
          date_of_birth: borrower.date_of_birth || null,
          mailing_street_address: borrower.mailing_street_address,
          mailing_city: borrower.mailing_city,
          mailing_state: borrower.mailing_state,
          mailing_zip_code: borrower.mailing_zip_code,
          mailing_country: 'US',
          employment_status: borrower.employment_status || null,
          employer_name: borrower.employer_name || null,
          annual_income: borrower.annual_income ? parseFloat(borrower.annual_income) : null,
          credit_score: borrower.credit_score ? parseInt(borrower.credit_score) : null,
        })
        .select('borrower_id')
        .single()

      if (borrowerError) throw borrowerError

      // 2. Generate a loan number
      const generatedLoanNumber = `LC-${Date.now()}`

      // 3. Insert loan (uses loan_type_id = 1 as default — update per your seed data)
      const { data: loanData, error: loanError } = await supabase
        .from('loan')
        .insert({
          loan_number: generatedLoanNumber,
          loan_type_id: 1,
          origination_date: new Date().toISOString().split('T')[0],
          original_maturity_date: new Date(
            Date.now() + parseInt(loan.original_term_months) * 30 * 24 * 60 * 60 * 1000
          ).toISOString().split('T')[0],
          original_balance: parseFloat(loan.original_balance),
          original_term_months: parseInt(loan.original_term_months),
          interest_calculation_method: loan.interest_calculation_method,
        })
        .select('loan_id')
        .single()

      if (loanError) throw loanError

      // 4. Link borrower to loan
      const { error: linkError } = await supabase
        .from('loan_borrower')
        .insert({
          loan_id: loanData.loan_id,
          borrower_id: borrowerData.borrower_id,
          borrower_position: 'PRIMARY',
          is_primary_liable: true,
          has_signed: false,
        })

      if (linkError) throw linkError

      // 5. Create initial loan status
      await supabase.from('loan_status_history').insert({
        loan_id: loanData.loan_id,
        loan_status: 'ORIGINATED',
        status_date: new Date().toISOString().split('T')[0],
        reason: 'Online application submitted',
      })

      setLoanNumber(generatedLoanNumber)
      setStep('success')
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Something went wrong. Please try again.'
      setError(msg)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className={styles.wrap}>
      <nav className={styles.nav}>
        <Link href="/" className={styles.logo}>Loan<span>Coin</span></Link>
        <div className={styles.navRight}>
          <span className={styles.navNote}>🔒 Secure application</span>
        </div>
      </nav>

      <div className={styles.container}>
        {/* PROGRESS */}
        {step !== 'success' && (
          <div className={styles.progress}>
            {(['borrower', 'loan'] as const).map((s, i) => (
              <div key={s} className={`${styles.progressStep} ${step === s ? styles.active : ''} ${
                (step === 'loan' && s === 'borrower') ? styles.done : ''
              }`}>
                <div className={styles.progressDot}>{
                  (step === 'loan' && s === 'borrower') ? '✓' : i + 1
                }</div>
                <span>{s === 'borrower' ? 'Your Info' : 'Loan Details'}</span>
              </div>
            ))}
          </div>
        )}

        {/* ERROR */}
        {error && (
          <div className={styles.errorBanner}>⚠️ {error}</div>
        )}

        {/* STEP 1 — BORROWER */}
        {step === 'borrower' && (
          <div className={styles.card}>
            <h1 className={styles.cardTitle}>Tell us about yourself</h1>
            <p className={styles.cardSub}>This information is used to verify your identity and pre-qualify you.</p>

            <div className={styles.formGrid}>
              <div className={styles.field}>
                <label>First name *</label>
                <input type="text" value={borrower.first_name} onChange={e => updateBorrower('first_name', e.target.value)} placeholder="Jane" />
              </div>
              <div className={styles.field}>
                <label>Last name *</label>
                <input type="text" value={borrower.last_name} onChange={e => updateBorrower('last_name', e.target.value)} placeholder="Smith" />
              </div>
              <div className={styles.field}>
                <label>Email address</label>
                <input type="email" value={borrower.email_address} onChange={e => updateBorrower('email_address', e.target.value)} placeholder="jane@example.com" />
              </div>
              <div className={styles.field}>
                <label>Phone number</label>
                <input type="tel" value={borrower.phone_number} onChange={e => updateBorrower('phone_number', e.target.value)} placeholder="(555) 000-0000" />
              </div>
              <div className={styles.field}>
                <label>Date of birth</label>
                <input type="date" value={borrower.date_of_birth} onChange={e => updateBorrower('date_of_birth', e.target.value)} />
              </div>
              <div className={styles.field}>
                <label>Employment status</label>
                <select value={borrower.employment_status} onChange={e => updateBorrower('employment_status', e.target.value)}>
                  <option value="">Select...</option>
                  <option value="EMPLOYED">Employed</option>
                  <option value="SELF_EMPLOYED">Self-employed</option>
                  <option value="RETIRED">Retired</option>
                  <option value="DISABLED">Disabled</option>
                  <option value="UNEMPLOYED">Unemployed</option>
                </select>
              </div>
              <div className={`${styles.field} ${styles.fullWidth}`}>
                <label>Street address *</label>
                <input type="text" value={borrower.mailing_street_address} onChange={e => updateBorrower('mailing_street_address', e.target.value)} placeholder="123 Main St" />
              </div>
              <div className={styles.field}>
                <label>City *</label>
                <input type="text" value={borrower.mailing_city} onChange={e => updateBorrower('mailing_city', e.target.value)} placeholder="Tampa" />
              </div>
              <div className={styles.field}>
                <label>State *</label>
                <select value={borrower.mailing_state} onChange={e => updateBorrower('mailing_state', e.target.value)}>
                  <option value="">Select...</option>
                  {STATES.map(s => <option key={s} value={s}>{s}</option>)}
                </select>
              </div>
              <div className={styles.field}>
                <label>ZIP code *</label>
                <input type="text" value={borrower.mailing_zip_code} onChange={e => updateBorrower('mailing_zip_code', e.target.value)} placeholder="34601" />
              </div>
              <div className={styles.field}>
                <label>Annual income ($)</label>
                <input type="number" value={borrower.annual_income} onChange={e => updateBorrower('annual_income', e.target.value)} placeholder="85000" />
              </div>
              <div className={styles.field}>
                <label>Credit score (estimate)</label>
                <input type="number" value={borrower.credit_score} onChange={e => updateBorrower('credit_score', e.target.value)} placeholder="720" min="300" max="850" />
              </div>
            </div>

            <div className={styles.formActions}>
              <button
                className={styles.btnPrimary}
                onClick={() => {
                  if (!borrower.first_name || !borrower.last_name || !borrower.mailing_street_address || !borrower.mailing_city || !borrower.mailing_state || !borrower.mailing_zip_code) {
                    setError('Please fill in all required fields (*).')
                    return
                  }
                  setError(null)
                  setStep('loan')
                }}
              >
                Continue to loan details →
              </button>
            </div>
          </div>
        )}

        {/* STEP 2 — LOAN */}
        {step === 'loan' && (
          <div className={styles.card}>
            <h1 className={styles.cardTitle}>Loan details</h1>
            <p className={styles.cardSub}>Tell us about the mortgage you're looking for.</p>

            <div className={styles.formGrid}>
              <div className={`${styles.field} ${styles.fullWidth}`}>
                <label>Loan amount ($) *</label>
                <input type="number" value={loan.original_balance} onChange={e => updateLoan('original_balance', e.target.value)} placeholder="360000" />
              </div>
              <div className={styles.field}>
                <label>Loan term</label>
                <select value={loan.original_term_months} onChange={e => updateLoan('original_term_months', e.target.value)}>
                  <option value="120">10 years</option>
                  <option value="180">15 years</option>
                  <option value="240">20 years</option>
                  <option value="360">30 years</option>
                </select>
              </div>
              <div className={styles.field}>
                <label>Loan type</label>
                <select value={loan.interest_calculation_method} onChange={e => updateLoan('interest_calculation_method', e.target.value)}>
                  <option value="FIXED">Fixed rate</option>
                  <option value="ARM">Adjustable rate (ARM)</option>
                  <option value="INTEREST_ONLY">Interest only</option>
                  <option value="BALLOON">Balloon</option>
                </select>
              </div>
              <div className={styles.field}>
                <label>Loan purpose</label>
                <select value={loan.loan_purpose} onChange={e => updateLoan('loan_purpose', e.target.value)}>
                  <option value="PURCHASE">Purchase</option>
                  <option value="REFINANCE">Refinance</option>
                  <option value="CASH_OUT_REFI">Cash-out refi</option>
                  <option value="CONSTRUCTION">Construction</option>
                </select>
              </div>
            </div>

            <div className={styles.formActions}>
              <button className={styles.btnGhost} onClick={() => setStep('borrower')}>← Back</button>
              <button
                className={styles.btnPrimary}
                disabled={loading}
                onClick={() => {
                  if (!loan.original_balance) {
                    setError('Please enter a loan amount.')
                    return
                  }
                  setError(null)
                  handleSubmit()
                }}
              >
                {loading ? 'Submitting...' : 'Submit application'}
              </button>
            </div>
          </div>
        )}

        {/* SUCCESS */}
        {step === 'success' && (
          <div className={`${styles.card} ${styles.successCard}`}>
            <div className={styles.successIcon}>✓</div>
            <h1 className={styles.cardTitle}>Application submitted!</h1>
            <p className={styles.cardSub}>
              Your loan number is <strong className={styles.loanNum}>{loanNumber}</strong>.<br />
              Our team will review your application and reach out within 1–2 business days.
            </p>
            <Link href="/" className={styles.btnPrimary} style={{ display: 'inline-block', marginTop: '1.5rem' }}>
              Back to home
            </Link>
          </div>
        )}
      </div>
    </div>
  )
}
