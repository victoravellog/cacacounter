# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Cacacounter is a small Rails app for tracking diaper (pañal) usage for a newborn: log each
diaper change, log each pack purchased, and see an estimated remaining stock per diaper size plus
a low-stock warning. Single-user/family app — no authentication.

## Commands

Run `bin/setup` once to install gems, prepare the database, and clear logs/tmp (add
`--skip-server` to skip launching the dev server, `--reset` to reset the DB).

- Dev server: `bin/dev` (runs `bin/rails server`)
- Console: `bin/rails console`
- Full CI suite (mirrors `.github/workflows/ci.yml`): `bin/ci`
- Tests (RSpec): `bundle exec rspec` (all), `bundle exec rspec spec/models/diaper_change_spec.rb`
  (one file), `bundle exec rspec spec/models/diaper_change_spec.rb:12` (single example at a line)
- Lint (Rubocop Omakase style): `bin/rubocop` (add `-a`/`-A` to autocorrect)
- Security scans: `bin/brakeman --no-pager` (static analysis), `bin/bundler-audit` (gem CVEs),
  `bin/importmap audit` (JS dependency CVEs)
- Reseed test DB (used in CI): `RAILS_ENV=test bin/rails db:seed:replant`
- DB migrations: `bin/rails db:prepare` / `bin/rails db:migrate`

`bin/ci` (backed by `config/ci.rb`, using `ActiveSupport::ContinuousIntegration`) runs setup,
rubocop, all three security scans, and the RSpec suite in one command — run this before
considering a change done, since it's the same thing CI runs.

Testing is RSpec (`rspec-rails`), not Minitest — there is no `test/` directory. `spec/rails_helper.rb`
has `config.infer_spec_type_from_file_location!` enabled, so `spec/models/**` specs auto-get
`type: :model`, etc. No FactoryBot/fixtures are set up; specs build records directly with
`Model.create!`/`Model.new`. Capybara + Selenium are in the `test` group for future system specs,
but none exist yet.

## Architecture

- **Framework**: Rails 8.1 in the default "no PaaS" configuration — SQLite (via the `sqlite3`
  gem) for the primary DB, and the Solid trifecta (`solid_queue`, `solid_cache`, `solid_cable`)
  backing jobs, caching, and Action Cable respectively, each in its own SQLite database
  (`storage/production.sqlite3`, `storage/production_queue.sqlite3`, etc. per
  `config/database.yml`). There is no Redis dependency.
- **Frontend**: Hotwire stack — `turbo-rails` + `stimulus-rails` — with `importmap-rails` for JS
  (no Node/bundler build step) and `propshaft` as the asset pipeline. Stimulus controllers live
  in `app/javascript/controllers/` and are auto-registered via `app/javascript/controllers/index.js`
  (unused so far — the UI is plain server-rendered ERB + CSS, no custom JS yet).
- **Styling**: hand-written neobrutalist CSS in `app/assets/stylesheets/application.css` (no
  Tailwind/Bootstrap) — thick black borders, hard offset box-shadows (no blur), flat saturated
  colors, uppercase bold type. Reusable classes: `.btn` (+ `.btn-primary/.btn-cyan/.btn-yellow/.btn-danger`,
  `.btn-sm`, `.btn-block`), `.card`, `.stock-card` (+ `.low` modifier), `.entry-list`, `.field`,
  `.error-box`, `.empty-state`. Keep new UI consistent with these instead of inventing new patterns.
- **Domain model**:
  - `DiaperSize::OPTIONS` (`app/models/diaper_size.rb`) is the fixed, ordered list of valid sizes
    (`RN, P, M, G, XG, XXG`). Both `DiaperChange` and `DiaperPurchase` validate `size` against this list.
  - `DiaperChange` — one row per diaper change (`occurred_at`, `size`, optional `notes`).
  - `DiaperPurchase` — one row per pack bought (`purchased_at`, `size`, `quantity`, optional `brand`/`notes`).
  - `DiaperStockSummary` (`app/models/diaper_stock_summary.rb`) is a plain Ruby object (not an
    ActiveRecord model) that computes, per size: `stock` = total purchased − total used,
    `avg_daily_usage` over a 14-day trailing window, `estimated_days_left`, and `low_stock?`
    (true when stock ≤ 0 or ≤3 estimated days left). `.for_active_sizes` returns one summary per
    size that has at least one purchase or change, ordered per `DiaperSize::OPTIONS`. This is
    where all "how many diapers are left / should I buy more" logic lives — extend here rather
    than duplicating math in controllers/views.
- **Routes/controllers**: `DashboardController#index` (root `/`) is the main screen — per-size
  quick-log buttons (`button_to` posting straight to `diaper_changes#create` with just a `size`,
  defaulting `occurred_at` to now), the stock overview, and recent activity. `DiaperChangesController`
  and `DiaperPurchasesController` are plain CRUD (`index/new/create/destroy` only) for full history
  and manual entry with custom timestamps/notes.
- **Background jobs**: Solid Queue. In production it runs embedded inside the Puma process via
  `SOLID_QUEUE_IN_PUMA=true` (see `config/deploy.yml`) rather than a separate worker dyno, unless
  scaled out later. Recurring jobs are declared in `config/recurring.yml`. Not currently used by
  the app's own code — no jobs defined yet beyond Rails/Solid Queue defaults.
- **Deployment**: Kamal, configured in `config/deploy.yml` and `.kamal/`. Deploys as a single
  Docker image (see `Dockerfile`); the SQLite databases and any Active Storage files persist via
  a Docker volume (`cacacounter_storage`) mounted at `/rails/storage`. Useful aliases:
  `bin/kamal console`, `bin/kamal shell`, `bin/kamal logs`, `bin/kamal dbc` (dbconsole).
- **CI** (`.github/workflows/ci.yml`): separate jobs for Brakeman, bundler-audit, importmap audit,
  Rubocop, and `bundle exec rspec` — all run on every PR and on push to `master`.
