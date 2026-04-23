# Room Inventory v2

Single-file HTML inventory app with Supabase cloud sync and GitHub Pages hosting.

---

## Setup — do this once, in order

### 1. Create a Supabase project

1. Go to [supabase.com](https://supabase.com) → **Start your project** → sign in with GitHub
2. **New project** → name it `room-inventory` → choose a region close to you → set a DB password (save it somewhere) → **Create new project**
3. Wait ~2 minutes for it to provision

### 2. Create the database table

1. In your Supabase project → **SQL Editor** (left sidebar) → **New query**
2. Copy the contents of `supabase-schema.sql` and paste it in
3. Click **Run** — you should see "Success. No rows returned"

### 3. Get your API credentials

1. **Settings** (gear icon, left sidebar) → **API**
2. Copy two values:
   - **Project URL** — looks like `https://abcdefgh.supabase.co`
   - **anon / public key** — long string starting with `eyJ...`

### 4. Add your credentials to the app

Open `index.html` in a text editor. Near the top of the `<script>` block, find:

```js
const SUPABASE_URL = '';  // e.g. 'https://xyzxyz.supabase.co'
const SUPABASE_KEY = '';  // your anon/public key
```

Fill them in:

```js
const SUPABASE_URL = 'https://abcdefgh.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

Save the file.

### 5. Test locally first

Open `index.html` directly in Chrome (drag it into a browser tab). The sync dot in the header should turn green and say **cloud saved** after a few seconds.

If you have existing data in the old app's localStorage, you'll see a **Cloud Migration** dialog — click **Migrate** and wait for it to complete. Your local data is not deleted until the upload is verified.

---

## Deploy to GitHub Pages

### First time setup

1. Install [Git](https://git-scm.com/downloads) if you don't have it
2. Create a free account at [github.com](https://github.com) if you don't have one
3. Create a **new repository** → name it `room-inventory` → **Private** → **Create repository**

### Push the files

Open Terminal (Mac) or Git Bash (Windows) in this folder and run:

```bash
git init
git add .
git commit -m "Room Inventory v2"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/room-inventory.git
git push -u origin main
```

Replace `YOUR-USERNAME` with your GitHub username.

### Enable GitHub Pages

1. In your GitHub repo → **Settings** → **Pages** (left sidebar)
2. **Source** → **Deploy from a branch**
3. **Branch** → `main` → `/root` → **Save**
4. Wait ~60 seconds → your app is live at `https://YOUR-USERNAME.github.io/room-inventory`

That URL works on iPhone. Add it to your home screen from Safari:
**Share → Add to Home Screen → Add**

---

## Updating the app

Whenever you edit `index.html`:

```bash
git add index.html
git commit -m "Update inventory app"
git push
```

GitHub Pages redeploys automatically in ~30 seconds.

---

## How sync works

| State | Header dot | Meaning |
|---|---|---|
| 🟢 green | cloud saved | All changes are in Supabase |
| 🟡 yellow | syncing… | Write in progress (debounced 800ms after last edit) |
| 🔴 red | sync error | Supabase unreachable — data saved locally, will retry next save |
| ⚫ grey | local only | No Supabase config — running purely on localStorage |

**Every write goes to localStorage first**, then Supabase. If Supabase is down or you're offline, you never lose data — it's always in localStorage as a backup. The next successful save syncs everything.

---

## Troubleshooting

**Migration dialog doesn't appear**
Your Supabase table already has data. Either your data is already there, or the table needs to be cleared. Check the Supabase Table Editor.

**Sync dot stays red**
Check the browser console (F12 → Console) for the error. Common causes:
- Wrong URL or key in the config
- RLS policy not set up (run the SQL schema again)
- Supabase project is paused (free tier pauses after 1 week of inactivity — just visit the Supabase dashboard to wake it)

**Free tier note**
Supabase free tier pauses inactive projects after 1 week. The app handles this gracefully (falls back to localStorage, shows red dot). Just open your Supabase dashboard once a week to keep it active — or upgrade to the $25/mo Pro plan to disable pausing.

---

## What's next (v2 roadmap)

- [ ] Claude API layer — item intelligence, auto-suggest, anomaly detection
- [ ] PWA manifest — iPhone home screen, offline support
- [ ] New schema fields — photo_url, receipt_url, warranty_expires, belongs_to, kit, loanable
- [ ] Completeness system UI — per-item % and "needs attention" queue
