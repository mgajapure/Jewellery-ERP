# Current Status

Last updated: 2026-06-22 05:38:59 +00:00

## Project State

- Auth flow screens have been created and split into a professional feature structure under `lib/src/features/auth/`.
- Routing has been updated so the app starts at `/splash` and proceeds through:
  - Splash
  - Mobile number entry
  - OTP verification
  - Registration pending
  - Dashboard
- Dashboard has been redesigned as a real full-device Flutter screen with header, gold rate card, key metrics, quick actions, and recent payments.
- Customer module (MOD-CUSTOMER) frontend screens are in place under `lib/src/features/customer/`:
  - Customer List (SCR-010)
  - Customer Search (SCR-011)
  - Create Customer (SCR-012)
  - Customer Details (SCR-014)
- Customer routes are registered in `lib/src/app/app_router.dart`.
- Dashboard `Search Customer` quick action and `Customers` bottom-nav tab navigate to the customer screens.
- Girvi Core module (MOD-GIRVI) frontend screens are in place under `lib/src/features/girvi/`:
  - Girvi List (SCR-017)
  - Create Girvi Wizard (SCR-018)
  - Girvi Details (SCR-027)
- Girvi routes are registered in `lib/src/app/app_router.dart`.
- Dashboard `New Girvi` quick action and `Girvi` bottom-nav tab navigate to the girvi screens.
- Vault Management module (MOD-VAULT) frontend screens are now in place under `lib/src/features/vault/`:
  - Vault Assignment (SCR-034)
  - Vault Search & Occupancy (SCR-035)
- Vault routes are registered in `lib/src/app/app_router.dart`:
  - `/vault/assign` → Vault Assignment
  - `/vault/search` → Vault Search & Occupancy
- Dashboard quick action row now includes `Vault Search` (replacing the placeholder `Due List`) and opens the Vault Search screen.
- Interest Engine module (MOD-INTEREST) frontend screens are now in place under `lib/src/features/interest/`:
  - Interest Calculator (SCR-032)
  - Interest Ledger & Breakdown (SCR-033)
- Interest routes are registered in `lib/src/app/app_router.dart`:
  - `/interest/calculator` → Interest Calculator
  - `/interest/ledger` → Interest Ledger
- Dashboard quick action row now includes `Interest Calc` (replacing the placeholder `Record Payment`) and opens the Interest Calculator.

## Known Issue

- No current analyzer issues known, but `flutter analyze` could not be executed because the Flutter SDK is not installed in this environment.
- Customer, Girvi, Vault, and Interest screens currently use static mock data and placeholder actions for backend integration, OCR, QR scanning, photos, payments, renewal, redemption, auction, automatic slot release, and real date pickers.

## Next Step

- Run `dart format` and `flutter analyze` when the SDK is available.
- Continue with the next modules in the frontend roadmap: Compliance (MOD-COMPLIANCE) and Payments, followed by Inventory (MOD-INVENTORY), Purchase (MOD-PURCHASE), and Sales (MOD-SALES).
- Implement remaining screens: Partial Payment (SCR-028), Renewal (SCR-029), Redemption (SCR-030), Auction Workflow (SCR-031), Due & Overdue Management (SCR-073), Vault Configuration (SCR-091), Insurance Mapping (SCR-092), Movement History (SCR-093), and Compliance forms.

## Verification

- `dart format lib/src/features/dashboard/dashboard_page.dart lib/src/features/auth lib/src/app/app_router.dart` completed successfully.
- `flutter analyze` completed successfully with no issues.
- `dart format lib/src/features/dashboard/dashboard_page.dart` completed successfully after adding recent payments.
- `flutter analyze` completed successfully after adding recent payments.
- All new customer, girvi, vault, and interest files were manually reviewed for syntax and const-correctness.
