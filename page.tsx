'use client'

import { useState } from 'react'
import Link from 'next/link'
import styles from './page.module.css'

function fmt(n: number) {
  return '$' + Math.round(n).toLocaleString()
}

function calcMonthly(price: number, downPct: number, years: number): string {
  const principal = price * (1 - downPct / 100)
  const r = 0.0648 / 12
  const n = years * 12
  const payment = (principal * (r * Math.pow(1 + r, n))) / (Math.pow(1 + r, n) - 1)
  return fmt(payment)
}

export default function HomePage() {
  const [homePrice, setHomePrice] = useState(450000)
  const [downPct, setDownPct] = useState(20)
  const [loanTerm, setLoanTerm] = useState(30)

  const monthly = calcMonthly(homePrice, downPct, loanTerm)

  return (
    <div className={styles.wrap}>
      {/* NAV */}
      <nav className={styles.nav}>
        <div className={styles.logo}>Loan<span>Coin</span></div>
        <ul className={styles.navLinks}>
          <li><a href="#rates">Rates</a></li>
          <li><a href="#how-it-works">How it works</a></li>
          <li><a href="#features">Features</a></li>
        </ul>
        <Link href="/apply" className={styles.navCta}>Apply Now</Link>
      </nav>

      {/* HERO */}
      <section className={styles.hero}>
        <div className={styles.heroContent}>
          <p className={styles.eyebrow}>Mortgage made modern</p>
          <h1>Your home loan,<br /><em>simplified.</em></h1>
          <p className={styles.heroSub}>
            LoanCoin gives you transparent rates, a fast digital application,
            and real-time loan tracking — all in one place.
          </p>
          <div className={styles.heroActions}>
            <Link href="/apply" className={styles.btnPrimary}>Get Started</Link>
            <a href="#how-it-works" className={styles.btnGhost}>Learn more</a>
          </div>
        </div>

        {/* CALCULATOR */}
        <div className={styles.calcCard}>
          <p className={styles.calcTitle}>Estimate your payment</p>

          <div className={styles.calcRow}>
            <div className={styles.calcLabel}>
              Home price <span>{fmt(homePrice)}</span>
            </div>
            <input
              type="range" min={100000} max={1500000} step={5000}
              value={homePrice}
              onChange={e => setHomePrice(Number(e.target.value))}
            />
          </div>

          <div className={styles.calcRow}>
            <div className={styles.calcLabel}>
              Down payment <span>{downPct}%</span>
            </div>
            <input
              type="range" min={3} max={40} step={1}
              value={downPct}
              onChange={e => setDownPct(Number(e.target.value))}
            />
          </div>

          <div className={styles.calcRow}>
            <div className={styles.calcLabel}>
              Loan term <span>{loanTerm} years</span>
            </div>
            <input
              type="range" min={10} max={30} step={10}
              value={loanTerm}
              onChange={e => setLoanTerm(Number(e.target.value))}
            />
          </div>

          <hr className={styles.divider} />

          <div className={styles.calcResult}>
            <div>
              <div className={styles.monthlyLabel}>Est. monthly payment</div>
              <div className={styles.monthlySub}>Principal &amp; interest only</div>
            </div>
            <div className={styles.monthlyAmount}>{monthly}</div>
          </div>

          <Link href="/apply" className={styles.applyBtn}>
            Apply with this estimate ↗
          </Link>
        </div>
      </section>

      {/* STATS */}
      <div id="rates" className={styles.stats}>
        <div className={styles.stat}>
          <div className={styles.statNum}>6.48%</div>
          <div className={styles.statLbl}>Today's 30-yr rate</div>
        </div>
        <div className={styles.stat}>
          <div className={styles.statNum}>14 days</div>
          <div className={styles.statLbl}>Average closing time</div>
        </div>
        <div className={styles.stat}>
          <div className={styles.statNum}>$0</div>
          <div className={styles.statLbl}>Application fee</div>
        </div>
      </div>

      {/* FEATURES */}
      <section id="features" className={styles.features}>
        <p className={styles.sectionLabel}>Why LoanCoin</p>
        <h2 className={styles.sectionTitle}>Everything you need to close</h2>
        <div className={styles.featuresGrid}>
          {[
            { icon: '📄', name: 'Digital application', desc: 'Apply in minutes from any device. Upload documents, e-sign disclosures, and track your status — no paperwork piles.' },
            { icon: '🛡️', name: 'Transparent terms', desc: 'See your full amortization schedule, interest breakdown, and APR before you commit. No surprises at closing.' },
            { icon: '📈', name: 'Live loan tracking', desc: 'Monitor your balance, escrow account, and payment history in real time. Your mortgage, always in your pocket.' },
            { icon: '🏠', name: 'Multiple loan types', desc: 'Fixed, ARM, FHA, VA, and more. We match you with the right product for your property and financial profile.' },
            { icon: '🔒', name: 'Bank-grade security', desc: 'Encrypted SSN storage, audit logs on every action, and full compliance with federal lending regulations.' },
            { icon: '👥', name: 'Co-borrower support', desc: 'Add a co-borrower or guarantor seamlessly. Each party reviews and e-signs at their own pace.' },
          ].map(f => (
            <div key={f.name} className={styles.featureCard}>
              <div className={styles.featureIcon}>{f.icon}</div>
              <div className={styles.featureName}>{f.name}</div>
              <div className={styles.featureDesc}>{f.desc}</div>
            </div>
          ))}
        </div>
      </section>

      {/* HOW IT WORKS */}
      <div id="how-it-works" className={styles.process}>
        <p className={styles.sectionLabel}>How it works</p>
        <h2 className={styles.sectionTitle} style={{ fontSize: '1.6rem' }}>From application to keys</h2>
        <div className={styles.steps}>
          {[
            { n: '1', title: 'Apply online', desc: 'Fill out our guided application and upload income docs in one session.' },
            { n: '2', title: 'Get pre-approved', desc: 'Our underwriting team reviews and issues a decision, fast.' },
            { n: '3', title: 'Lock your rate', desc: 'Choose your loan terms and lock in your rate with one click.' },
            { n: '4', title: 'Close & move in', desc: 'Sign your closing disclosure digitally and get your keys.' },
          ].map(s => (
            <div key={s.n} className={styles.step}>
              <div className={styles.stepNum}>{s.n}</div>
              <div className={styles.stepTitle}>{s.title}</div>
              <div className={styles.stepDesc}>{s.desc}</div>
            </div>
          ))}
        </div>
      </div>

      {/* CTA BANNER */}
      <div className={styles.ctaBanner}>
        <h2>Ready to find your rate?</h2>
        <p>No credit pull required to get started. Takes under 5 minutes.</p>
        <Link href="/apply" className={styles.btnPrimary}>Check my rate →</Link>
      </div>

      {/* FOOTER */}
      <footer className={styles.footer}>
        <div className={styles.footerLogo}>LoanCoin</div>
        <span>© 2026 LoanCoin. NMLS #000000. Equal Housing Lender.</span>
        <span>Privacy · Terms · Licenses</span>
      </footer>
    </div>
  )
}
