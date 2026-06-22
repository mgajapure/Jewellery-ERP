# Backend-Readiness Architecture Guide

## Jewellery ERP — From Hardcoded Flutter App to Backend-Connected Product

**Document Type:** Architecture Transition Guide  
**Version:** 1.0  
**Status:** Draft — For Review  
**Scope:** No code changes yet. This guide identifies everything required to make the current hardcoded Flutter application backend-ready.

---

## 1. Executive Summary

The current Flutter application is a UI shell with hardcoded screens, mock data, and placeholder network/storage layers. To make it backend-ready, we need to build and connect a **NestJS backend**, introduce a **local-first data layer**, implement **offline sync**, and restructure the frontend to follow the **Clean Architecture + BLoC** pattern already defined in `DOC-019`.

This guide consolidates the existing specifications (`DOC-018`, `DOC-019`, `DOC-020`, `DOC-021`, API Contract, Database Schema, Roadmap) into a practical transition plan.

---

## 2. Current State Snapshot

| Area | Current State | Gap |
|------|---------------|-----|
| **State Management** | `flutter_riverpod` (basic) | Migrate to `flutter_bloc` per `DOC-019` |
| **Routing** | `go_router` in place | Needs route guards (Auth, Permission, Device) |
| **Networking** | `dio` with `https://api.example.com` | Needs real backend + interceptors |
| **Local DB** | Only secure prefs | Needs `Drift` (SQLite) + offline sync |
| **Storage** | `flutter_secure_storage`, `shared_preferences` | Sufficient; needs key-value design |
| **Screens** | Hardcoded data, Marathi/Hindi strings inline | Needs BLoC + localization (ARB) |
| **Models** | None | Need Freezed models for every entity |
| **Repositories** | None | Need per-feature repositories |
| **Backend** | None | Build NestJS monolith per `DOC-018` |
| **Auth** | UI only | Implement OTP + device binding + JWT |
| **Tests** | Default widget test only | Add unit/bloc/integration tests |

---

## 3. Target Architecture Overview

```text
┌─────────────────────────────────────────────────────────────┐
│                     FLUTTER APPLICATION                      │
│  Presentation  →  BLoC  →  Repository  →  Data Sources      │
│      UI            State      Aggregate     Remote / Local   │
│                                                              │
│  Remote: Dio + Auth/Retry/Logging Interceptors               │
│  Local:  Drift SQLite + Sync Queue + Secure Storage          │
└─────────────────────────────┬───────────────────────────────┘
                              │ HTTPS / REST / WebSocket
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      NESTJS BACKEND                          │
│  Controllers → Services → Repositories → Prisma → PostgreSQL │
│                                                              │
│  Auth (JWT + Refresh + Device)    │    Redis (Cache/Rate)    │
│  RBAC                             │    BullMQ (Queues)       │
│  Audit Logger                     │    S3 (Files)            │
│  Event Bus (Nest EventEmitter)    │    Sync Engine           │
└─────────────────────────────────────────────────────────────┘
```

### Core Principle

**Offline-First:** Every user action writes to the local SQLite database first, then queues for background sync. The UI never waits for the server.

---

## 4. Backend Requirements

### 4.1 Technology Stack

| Layer | Technology |
|-------|------------|
| Runtime | Node.js + NestJS 11+ |
| Database | PostgreSQL 16+ |
| ORM | Prisma |
| Cache / Session / Rate Limit | Redis |
| Background Jobs | BullMQ |
| File Storage | S3-compatible (AWS S3 / MinIO / Cloudflare R2) |
| OTP | Firebase OTP / MSG91 / Twilio |
| Push Notifications | Firebase Cloud Messaging |
| Containerization | Docker + Docker Compose |
| Reverse Proxy | Nginx |

### 4.2 Required Backend Modules

Per `DOC-018`, implement in this order:

1. **Auth** — OTP, JWT, refresh tokens, device binding
2. **RBAC / Staff** — Users, roles, permissions
3. **Settings** — Business config, interest rates, GST, number series
4. **Customers** — KYC, documents, search, QR
5. **Vault** — Safes, trays, slots, assignments
6. **Girvi** — Pledge creation, items, payments, KFS, vault
7. **Interest Engine** — Simple, Katmiti, penalties, renewals
8. **Compliance** — Form 6, 9, 11, 12, 13, KFS generation
9. **Payments** — Partial, redemption, modes
10. **Reports** — Customer, Girvi, collections, vault
11. **Inventory** — Items, barcodes, categories, purity
12. **Purchase** — Suppliers, scrap purchase
13. **Sales** — POS, GST, invoice
14. **Savings Scheme** — Enrollment, deposits, maturity
15. **Dashboard** — KPIs, alerts
16. **Notifications** — Push, SMS, WhatsApp, email
17. **Sync** — Upload batch, download changes, conflict resolution
18. **Audit** — Immutable audit logs
19. **Files** — Upload, signed URLs, virus scan
20. **Backup** — Manual / scheduled encrypted backups

### 4.3 Mandatory Backend Infrastructure

- [ ] PostgreSQL server with row-level security
- [ ] Redis server
- [ ] S3-compatible object storage bucket
- [ ] SMTP / email service (for reports/backup alerts)
- [ ] SMS/WhatsApp gateway (MSG91 / Twilio / Gupshup)
- [ ] Firebase project (push notifications + optional OTP)
- [ ] Docker Compose setup for local development
- [ ] CI/CD pipeline (GitHub Actions)
- [ ] Environment-specific configs (dev / staging / prod)
- [ ] Secret manager (not in source code)
- [ ] SSL/TLS certificates
- [ ] Domain + API subdomain (`api.jewelleryerp.com`)

### 4.4 Database Foundation (Must Be Built First)

Core tables before any business logic:

| Table | Purpose |
|-------|---------|
| `tenant` | Multi-tenancy |
| `users` | Staff/owner accounts |
| `roles` | RBAC roles |
| `permissions` | Granular permissions |
| `role_permissions` | Many-to-many mapping |
| `devices` | Device approval & binding |
| `audit_logs` | Immutable activity logs |
| `settings` | Business configuration |
| `sync_queue` | Server-side sync tracking |
| `backup_history` | Backup audit |

Then business tables: `customers`, `girvi`, `girvi_items`, `payments`, `interest_ledger`, `vaults`, `safes`, `trays`, `slots`, `inventory_items`, `sales`, `purchases`, `savings_accounts`, etc.

---

## 5. Frontend Architecture Changes Required

### 5.1 Restructure `lib/`

From current flat feature folders to Clean Architecture:

```text
lib/
├── main.dart
├── src/
│   ├── app/               # App bootstrap, router, providers
│   ├── core/              # API, auth, database, sync, errors, theme, utils
│   │   ├── api/
│   │   ├── auth/
│   │   ├── database/
│   │   ├── network/
│   │   ├── storage/
│   │   ├── sync/
│   │   ├── errors/
│   │   ├── theme/
│   │   └── utils/
│   ├── shared/            # Shared widgets, design system
│   │   ├── widgets/
│   │   └── design_system/
│   ├── l10n/              # ARB localization files
│   └── features/
│       ├── auth/
│       ├── dashboard/
│       ├── customers/
│       ├── girvi/
│       ├── interest/
│       ├── vault/
│       ├── compliance/
│       ├── staff/
│       ├── reports/
│       ├── inventory/
│       ├── purchase/
│       ├── sales/
│       ├── savings/
│       └── settings/
```

Each feature follows:

```text
features/customers/
├── presentation/
│   ├── bloc/
│   ├── pages/
│   └── widgets/
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
└── domain/
    ├── entities/
    └── usecases/
```

### 5.2 State Management Migration

- Replace ad-hoc Riverpod usage with `flutter_bloc`
- One BLoC per screen group (not per widget)
- Standard states: `Initial`, `Loading`, `Loaded`, `Error`
- Standard events: `LoadXxx`, `CreateXxx`, `UpdateXxx`, `DeleteXxx`

### 5.3 Dependency Injection

Introduce `get_it` + `injectable` to register:

- `ApiClient`
- `LocalDatabase` (Drift)
- `SyncManager`
- Repositories
- BLoCs

### 5.4 Networking Upgrade

`core/api/api_client.dart` needs:

- [ ] Configurable base URL from environment
- [ ] `AuthInterceptor` — attach JWT, refresh on 401
- [ ] `DeviceInterceptor` — attach `X-Device-Id`
- [ ] `TenantInterceptor` — attach `X-Tenant-Id`
- [ ] `LoggingInterceptor` — structured logs
- [ ] `RetryInterceptor` — retry on timeout/network errors
- [ ] Global error mapping to domain `AppException`

### 5.5 Local Database (Drift)

Add packages: `drift`, `drift_flutter`, `sqlcipher_flutter_libs`.

Local tables mirror server tables for offline use:

- `customers`
- `girvi`
- `girvi_items`
- `payments`
- `vault_slots`
- `inventory_items`
- `sync_queue`
- `sync_conflicts`
- `settings`

### 5.6 Models & Serialization

For every entity:

- Freezed model (e.g., `Customer`, `CustomerDto`)
- JSON serialization via `json_serializable`
- Mapper between DTO, entity, and DB row
- Server response wrappers: `{ success, data, error }`

### 5.7 Localization

- Move all hardcoded strings to ARB files
- Languages: English, Marathi, Hindi
- Use `context.l10n.xxx`
- No inline strings anywhere

### 5.8 Route Guards

Implement with `go_router`:

- `AuthGuard` — redirect to login if no token
- `DeviceGuard` — redirect if device not approved
- `PermissionGuard` — block routes by RBAC

### 5.9 Shared Widgets / Design System

Build reusable widgets to replace inline UI:

- `AppButton`, `AppTextField`, `AppDropdown`
- `AppCard`, `AppLoader`, `AppEmptyState`, `AppErrorState`
- `AppSearchBar`, `AppDatePicker`, `AppImagePicker`
- Design tokens: colors, typography, spacing, radius

---

## 6. API Integration Strategy

### 6.1 API Contract Alignment

Base URLs:

- Production: `https://api.jewelleryerp.com/v1`
- Staging: `https://staging-api.jewelleryerp.com/v1`

Standard headers:

```text
Authorization: Bearer <JWT>
X-Tenant-Id: <uuid>
X-Device-Id: <uuid>
Content-Type: application/json
```

Standard response envelope:

```json
{
  "success": true,
  "message": "...",
  "data": {},
  "timestamp": "2026-06-08T10:00:00Z"
}
```

### 6.2 Implementation Order

Per API Contract and Roadmap:

1. Authentication APIs (`/auth/*`, `/devices/*`)
2. Customer APIs (`/customers/*`)
3. Girvi APIs (`/girvi/*`)
4. Interest APIs (`/interest/*`)
5. Vault APIs (`/vaults/*`)
6. Compliance APIs (`/compliance/*`)
7. Dashboard APIs (`/dashboard/*`)
8. Staff APIs (`/staff/*`)
9. Reports APIs (`/reports/*`)
10. Inventory, Purchase, Sales, Savings APIs
11. Sync APIs (`/sync/*`)
12. Backup APIs (`/backup/*`)

---

## 7. Offline-First & Sync Strategy

This is the hardest and most critical part of a jewellery ERP. Follow `DOC-020`.

### 7.1 Write Strategy

```text
User Action → Validate → Save to SQLite → Queue Sync → Show Success
                                            ↓
                                    Background Upload
```

### 7.2 Read Strategy

```text
UI reads from SQLite first → Server refresh in background → Update UI
```

### 7.3 Sync Queue Table

```text
sync_queue
  - id
  - entity_type        (customer, girvi, payment, etc.)
  - entity_id          (local UUID)
  - server_id          (nullable)
  - operation          (CREATE, UPDATE, DELETE, APPROVE)
  - payload            (JSON)
  - status             (PENDING, SYNCING, SYNCED, FAILED, CONFLICT)
  - retry_count
  - error_message
  - created_at
  - updated_at
```

### 7.4 Sync States

`PENDING → SYNCING → (SYNCED | FAILED → retry) | CONFLICT`

### 7.5 Conflict Resolution Rules

| Entity | Rule |
|--------|------|
| Customers | Last write wins |
| Settings | Server wins |
| Payments / Redemptions / Sales / Purchases | Manual review required |
| Financial transactions | Never auto-merge |

### 7.6 Retry Schedule

- Attempt 1: immediate
- Attempt 2: 30s
- Attempt 3: 2m
- Attempt 4: 5m
- Attempt 5: 15m
- Max 5 attempts → FAILED (dead letter queue, manual retry)

### 7.7 Sync Triggers

- App launch
- Connectivity restored
- Periodic timer (every 5 minutes)
- Manual pull-to-refresh
- After creating/updating any record

### 7.8 Media Sync

- Capture photo → save encrypted locally → queue upload
- Upload in background
- Update local record with server URL after upload

### 7.9 Initial Sync

On first login:

```text
Authenticate → Download Settings → Download Master Data → Download Open Transactions
```

---

## 8. Security & Compliance Checklist

Per `DOC-021`:

### 8.1 Authentication

- [ ] Mobile OTP (6 digits, 5 min expiry, 5 attempts, 30 min lockout)
- [ ] Device fingerprint + owner approval
- [ ] JWT access token (24h) + refresh token (30d)
- [ ] Secure token storage (`flutter_secure_storage`)

### 8.2 Authorization

- [ ] RBAC: User → Role → Permissions
- [ ] Backend is the final authority
- [ ] Frontend only hides unauthorized UI

### 8.3 API Security

- [ ] JWT validation on every request
- [ ] Tenant validation (`X-Tenant-Id`)
- [ ] Device validation (`X-Device-Id`)
- [ ] Rate limiting (Redis)
- [ ] Input validation/sanitization
- [ ] HTTPS only

### 8.4 Data Security

- [ ] Local SQLite encrypted (SQLCipher)
- [ ] Sync queue encrypted
- [ ] AES-256 at rest
- [ ] TLS 1.3 in transit
- [ ] No secrets in source code

### 8.5 Audit

- [ ] Every create/update/delete/login/export logged
- [ ] Audit logs immutable
- [ ] Old value + new value captured

### 8.6 Compliance

- [ ] RBI-oriented lending controls
- [ ] KFS generation
- [ ] Pledge forms
- [ ] Auction notices
- [ ] Customer consent

---

## 9. Infrastructure & DevOps Requirements

Per `DOC-022`:

### 9.1 Environments

- Development (local Docker)
- Staging (cloud test)
- Production (cloud live)

### 9.2 Services Needed

- [ ] PostgreSQL (managed: AWS RDS / Supabase / DigitalOcean)
- [ ] Redis (managed: Upstash / Redis Cloud / AWS ElastiCache)
- [ ] Object storage (AWS S3 / MinIO / Cloudflare R2)
- [ ] Container registry (Docker Hub / GitHub Container Registry / AWS ECR)
- [ ] CI/CD (GitHub Actions / GitLab CI)
- [ ] Monitoring (Prometheus + Grafana / Datadog / New Relic)
- [ ] Error tracking (Sentry)
- [ ] Log aggregation (Loki / CloudWatch)

### 9.3 CI/CD Pipeline

For backend:

```text
Lint → Test → Build → Dockerize → Push → Deploy to Staging → Integration Tests
```

For frontend:

```text
Analyze → Test → Build APK/Web → Upload Artifact
```

### 9.4 Local Dev Stack

```yaml
# docker-compose.yml services
- postgres:16
- redis:7
- minio (S3)
- nestjs-app
- flutter-web (optional)
```

---

## 10. Module-wise Backend Readiness Matrix

| Module | Backend API | Local DB | BLoC | Repository | Sync | Offline Priority |
|--------|:-----------:|:--------:|:----:|:----------:|:----:|:----------------:|
| **Auth** | Required | No | High | High | No | Online |
| **Dashboard** | Required | Cache | High | High | Partial | Partial |
| **Customers** | Required | Yes | High | High | Yes | Full |
| **Girvi** | Required | Yes | High | High | Yes | Full |
| **Payments** | Required | Yes | High | High | Yes | Full |
| **Interest** | Required | Yes | Medium | High | Yes | Full |
| **Vault** | Required | Yes | Medium | High | Yes | Full |
| **Compliance** | Required | No | Medium | Medium | No | Online |
| **Inventory** | Required | Yes | Medium | High | Yes | Search/Read |
| **Purchase** | Required | Yes | Medium | High | Yes | Drafts |
| **Sales** | Required | Yes | Medium | High | Yes | Drafts |
| **Savings** | Required | Yes | Medium | High | Yes | Full |
| **Reports** | Required | Cache | Medium | Medium | Partial | Partial |
| **Settings** | Required | Yes | Medium | Medium | Yes | Full |
| **Staff/RBAC** | Required | Cache | Low | Medium | No | Online |
| **Notifications** | Required | Cache | Low | Low | Yes | Partial |
| **Sync Engine** | Required | Yes | High | High | Yes | Core |

---

## 11. Implementation Roadmap

Recommended execution order (based on `DOC-025`):

### Phase 0 — Foundation (2 weeks)

- [ ] Set up NestJS project skeleton
- [ ] Set up PostgreSQL + Prisma
- [ ] Set up Redis + Docker Compose
- [ ] Set up CI/CD
- [ ] Define environment configs

### Phase 1 — Core Platform (4 weeks)

- [ ] Database: tenants, users, roles, permissions, devices, audit logs
- [ ] Auth module: OTP, JWT, refresh, device binding
- [ ] RBAC / Staff module
- [ ] Settings module
- [ ] Flutter: restructure to Clean Architecture, BLoC, DI
- [ ] Flutter: auth screens fully functional

### Phase 2 — Offline Engine (2 weeks)

- [ ] Drift local database
- [ ] Sync queue
- [ ] Connectivity monitor
- [ ] Sync manager + background sync
- [ ] Conflict resolution UI

### Phase 3 — Customer Module (2 weeks)

- [ ] Backend: customer CRUD, search, KYC, documents
- [ ] Flutter: customer list, search, details, create
- [ ] Offline create/update customer
- [ ] QR generation

### Phase 4 — Girvi Operations (5 weeks)

- [ ] Vault module
- [ ] Girvi module (create, items, valuation, LTV, KFS)
- [ ] Interest engine
- [ ] Payments (partial, renewal, redemption)
- [ ] Flutter: all Girvi screens

### Phase 5 — Retail ERP (5 weeks)

- [ ] Inventory
- [ ] Purchase
- [ ] Sales (POS, GST, invoice)
- [ ] Savings scheme

### Phase 6 — Compliance & Reports (4 weeks)

- [ ] Compliance forms
- [ ] Reports foundation + advanced
- [ ] Dashboard

### Phase 7 — Hardening & Launch (4 weeks)

- [ ] Security hardening
- [ ] Performance optimization
- [ ] Full QA
- [ ] Production deployment

---

## 12. Immediate Next Steps (No Code Changes Yet)

Before writing any code, lock down:

1. **Confirm backend stack** — NestJS + PostgreSQL + Prisma is already specified; confirm hosting provider.
2. **Confirm OTP provider** — Firebase vs MSG91 vs Twilio.
3. **Confirm file storage** — AWS S3 vs MinIO vs Cloudflare R2.
4. **Finalize API contract** — Review and approve `API Contract Specification v1`.
5. **Finalize database schema** — Approve `Database Schema Specification v1`.
6. **Decide offline sync scope** — Full offline for Girvi/Payments/Customers is mandatory; clarify Sales/Purchase draft behavior.
7. **Set up repositories/folders** — Create `backend/` and update `lib/` structure.
8. **Create environment config plan** — Dev/staging/prod domains, secrets, DB credentials.
9. **Define API versioning & base URLs** — As per contract.
10. **Plan migration strategy** — Prisma migrations, seed data, initial admin user.

---

## 13. Key Decisions Needed from You

| Decision | Options | Recommendation |
|----------|---------|----------------|
| **Backend hosting** | AWS / DigitalOcean / Render / Railway / Self-managed | Start with Docker on VPS/cloud |
| **OTP service** | Firebase / MSG91 / Twilio | Firebase for push + OTP |
| **File storage** | AWS S3 / MinIO / Cloudflare R2 | MinIO locally, S3/R2 in prod |
| **Push notifications** | Firebase Cloud Messaging | FCM |
| **SMS/WhatsApp** | MSG91 / Twilio / Gupshup | MSG91 for India |
| **Offline sync conflict** | Server wins / hybrid / manual | Hybrid per `DOC-020` |
| **Multi-branch support** | Phase 1 or Phase 2 | Phase 2 (after core Girvi) |

---

## 14. Summary: What is Required to Be Backend-Ready?

To transition from the current hardcoded Flutter app to a backend-connected product, you need:

1. **A NestJS backend** with PostgreSQL + Prisma
2. **Authentication & device binding** (OTP + JWT + device approval)
3. **RBAC** for staff permissions
4. **REST API endpoints** for every module per the API contract
5. **Flutter frontend restructure** to Clean Architecture + BLoC
6. **Local SQLite database** (Drift) for offline-first operation
7. **Sync engine** with queue, retry, conflict resolution
8. **Repository layer** abstracting remote/local data sources
9. **Localization** (ARB files) replacing all hardcoded strings
10. **Shared design system** and reusable widgets
11. **Security layer** (encryption, token management, validation)
12. **Audit logging** on every important action
13. **File upload/storage** for KYC, item photos, invoices
14. **Background jobs** (BullMQ) for reports, notifications, backups
15. **DevOps** (Docker, CI/CD, monitoring, environments)
16. **Comprehensive testing** (unit, bloc, integration, API)

---

## 15. Reference Documents

- `DOC-018 NestJS Backend Architecture Specification`
- `DOC-019 Flutter Frontend Architecture Specification`
- `DOC-020 Offline Sync Engine Specification v1`
- `DOC-021 Security & Compliance Architecture Specification V1`
- `API Contract Specification v1`
- `Database Schema Specification v1`
- `DOC-025 Master Development Roadmap & Build Sequence`
- `DOC-022 DevOps, Deployment & Infrastructure Specification v1`
- `DOC-023 Testing Strategy & Quality Assurance Specification`

---

*End of Guide*
