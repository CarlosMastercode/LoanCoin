# LoanCoin — Next.js + Supabase Setup

## 1. Create a Next.js project

```bash
npx create-next-app@latest loancoin --typescript --app --tailwind=false --eslint
cd loancoin
```

## 2. Install Supabase client

```bash
npm install @supabase/supabase-js
```

## 3. Add your files

Copy these files into your project:

```
lib/supabase.ts              → lib/supabase.ts
app/layout.tsx               → app/layout.tsx
app/globals.css              → app/globals.css
app/page.tsx                 → app/page.tsx
app/page.module.css          → app/page.module.css
app/apply/page.tsx           → app/apply/page.tsx
app/apply/apply.module.css   → app/apply/apply.module.css
```

## 4. Set up environment variables

```bash
cp .env.local.example .env.local
```

Then fill in your Supabase credentials from:
https://supabase.com/dashboard → your project → Settings → API

```
NEXT_PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
```

## 5. Seed a loan_type row

The apply form uses `loan_type_id = 1`. Run this in Supabase SQL Editor:

```sql
INSERT INTO loan_type (loan_type_code, description)
VALUES ('CONVENTIONAL', 'Conventional mortgage loan')
ON CONFLICT DO NOTHING;
```

## 6. Enable Row Level Security (RLS) — optional for POC

For a POC you can disable RLS on the tables the app writes to:

```sql
ALTER TABLE borrower_details DISABLE ROW LEVEL SECURITY;
ALTER TABLE loan DISABLE ROW LEVEL SECURITY;
ALTER TABLE loan_borrower DISABLE ROW LEVEL SECURITY;
ALTER TABLE loan_status_history DISABLE ROW LEVEL SECURITY;
```

> ⚠️ Re-enable RLS with proper policies before going to production.

## 7. Run locally

```bash
npm run dev
```

Visit http://localhost:3000

## What the app does

| Route    | What it writes                                          |
|----------|---------------------------------------------------------|
| `/`      | Landing page with live mortgage calculator              |
| `/apply` | Multi-step form → inserts into `borrower_details`, `loan`, `loan_borrower`, `loan_status_history` |

## Next steps

- Add `/dashboard` to show `payment_schedule` and `loan_status_history`
- Add auth via Supabase Auth so borrowers can log back in
- Wire up `loan_terms` insert with a rate from your database
- Add `underwriting` row on submission
