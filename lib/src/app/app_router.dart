import 'package:go_router/go_router.dart';

import '../features/auth/auth.dart';
import '../features/auth/domain/entities/auth_session.dart';
import '../features/customer/customer.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/girvi/girvi.dart';
import '../features/inventory/inventory.dart';
import '../features/compliance/compliance.dart';
import '../features/interest/interest.dart';
import '../features/more/more.dart';
import '../features/purchase/purchase.dart';
import '../features/reports/reports.dart';
import '../features/sales/sales.dart';
import '../features/savings/savings.dart';
import '../features/settings/settings.dart';
import '../features/staff/staff.dart';
import '../features/vault/vault.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: SplashPage.routeName,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      name: MobileNumberPage.routeName,
      builder: (context, state) => const MobileNumberPage(),
    ),
    GoRoute(
      path: '/otp',
      name: OtpVerificationPage.routeName,
      builder: (context, state) =>
          OtpVerificationPage(args: state.extra! as OtpArgs),
    ),
    GoRoute(
      path: '/registration-pending',
      name: RegistrationPendingPage.routeName,
      builder: (context, state) => const RegistrationPendingPage(),
    ),
    GoRoute(
      path: '/',
      name: DashboardPage.routeName,
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/inventory',
      name: InventoryListPage.routeName,
      builder: (context, state) => const InventoryListPage(),
    ),
    GoRoute(
      path: '/inventory/:id',
      name: InventoryDetailsPage.routeName,
      builder: (context, state) => InventoryDetailsPage(
        item: state.extra! as InventoryItem,
      ),
    ),
    GoRoute(
      path: '/customers',
      name: CustomerListPage.routeName,
      builder: (context, state) => const CustomerListPage(),
    ),
    GoRoute(
      path: '/customers/search',
      name: CustomerSearchPage.routeName,
      builder: (context, state) => const CustomerSearchPage(),
    ),
    GoRoute(
      path: '/customers/create',
      name: CreateCustomerPage.routeName,
      builder: (context, state) => const CreateCustomerPage(),
    ),
    GoRoute(
      path: '/customers/:id',
      name: CustomerDetailsPage.routeName,
      builder: (context, state) => const CustomerDetailsPage(),
    ),
    GoRoute(
      path: '/girvi',
      name: GirviListPage.routeName,
      builder: (context, state) => const GirviListPage(),
    ),
    GoRoute(
      path: '/girvi/create',
      name: CreateGirviWizardPage.routeName,
      builder: (context, state) => const CreateGirviWizardPage(),
    ),
    GoRoute(
      path: '/girvi/:id',
      name: GirviDetailsPage.routeName,
      builder: (context, state) => const GirviDetailsPage(),
    ),
    GoRoute(
      path: '/girvi/:id/payment',
      name: PartialPaymentPage.routeName,
      builder: (context, state) => const PartialPaymentPage(),
    ),
    GoRoute(
      path: '/girvi/:id/renewal',
      name: RenewalPage.routeName,
      builder: (context, state) => const RenewalPage(),
    ),
    GoRoute(
      path: '/girvi/:id/redemption',
      name: RedemptionPage.routeName,
      builder: (context, state) => const RedemptionPage(),
    ),
    GoRoute(
      path: '/girvi/:id/auction',
      name: AuctionWorkflowPage.routeName,
      builder: (context, state) => const AuctionWorkflowPage(),
    ),
    GoRoute(
      path: '/due-overdue',
      name: DueOverduePage.routeName,
      builder: (context, state) => const DueOverduePage(),
    ),
    GoRoute(
      path: '/vault/assign',
      name: VaultAssignmentPage.routeName,
      builder: (context, state) => const VaultAssignmentPage(),
    ),
    GoRoute(
      path: '/vault/search',
      name: VaultSearchPage.routeName,
      builder: (context, state) => const VaultSearchPage(),
    ),
    GoRoute(
      path: '/interest/calculator',
      name: InterestCalculatorPage.routeName,
      builder: (context, state) => const InterestCalculatorPage(),
    ),
    GoRoute(
      path: '/interest/ledger',
      name: InterestLedgerPage.routeName,
      builder: (context, state) => const InterestLedgerPage(),
    ),
    GoRoute(
      path: '/compliance',
      name: ComplianceDashboardPage.routeName,
      builder: (context, state) => const ComplianceDashboardPage(),
    ),
    GoRoute(
      path: '/compliance/form6',
      name: Form6GeneratorPage.routeName,
      builder: (context, state) => const Form6GeneratorPage(),
    ),
    GoRoute(
      path: '/compliance/form9',
      name: Form9RegisterPage.routeName,
      builder: (context, state) => const Form9RegisterPage(),
    ),
    GoRoute(
      path: '/compliance/forms11-12',
      name: Forms11_12Page.routeName,
      builder: (context, state) => const Forms11_12Page(),
    ),
    GoRoute(
      path: '/compliance/form13',
      name: Form13GeneratorPage.routeName,
      builder: (context, state) => const Form13GeneratorPage(),
    ),
    GoRoute(
      path: '/purchase',
      name: PurchaseDashboardPage.routeName,
      builder: (context, state) => const PurchaseDashboardPage(),
    ),
    GoRoute(
      path: '/purchase/new',
      name: NewPurchasePage.routeName,
      builder: (context, state) => const NewPurchasePage(),
    ),
    GoRoute(
      path: '/purchase/ledger',
      name: PurchaseLedgerPage.routeName,
      builder: (context, state) => const PurchaseLedgerPage(),
    ),
    GoRoute(
      path: '/purchase/suppliers',
      name: SupplierManagementPage.routeName,
      builder: (context, state) => const SupplierManagementPage(),
    ),
    GoRoute(
      path: '/purchase/:id',
      name: PurchaseDetailsPage.routeName,
      builder: (context, state) => PurchaseDetailsPage(
        entry: state.extra! as PurchaseEntry,
      ),
    ),
    GoRoute(
      path: '/sales',
      name: SalesDashboardPage.routeName,
      builder: (context, state) => const SalesDashboardPage(),
    ),
    GoRoute(
      path: '/sales/new',
      name: NewSalePage.routeName,
      builder: (context, state) => const NewSalePage(),
    ),
    GoRoute(
      path: '/sales/invoice-preview',
      name: InvoicePreviewPage.routeName,
      builder: (context, state) => InvoicePreviewPage(
        order: state.extra! as SaleOrder,
      ),
    ),
    GoRoute(
      path: '/sales/ledger',
      name: SalesLedgerPage.routeName,
      builder: (context, state) => const SalesLedgerPage(),
    ),
    GoRoute(
      path: '/sales/return',
      name: SalesReturnPage.routeName,
      builder: (context, state) => const SalesReturnPage(),
    ),
    GoRoute(
      path: '/sales/barcode',
      name: BarcodeSalePage.routeName,
      builder: (context, state) => const BarcodeSalePage(),
    ),
    GoRoute(
      path: '/sales/:id',
      name: SalesDetailsPage.routeName,
      builder: (context, state) => SalesDetailsPage(
        order: state.extra! as SaleOrder,
      ),
    ),
    GoRoute(
      path: '/more',
      name: MorePage.routeName,
      builder: (context, state) => const MorePage(),
    ),
    GoRoute(
      path: '/savings',
      name: SavingsDashboardPage.routeName,
      builder: (context, state) => const SavingsDashboardPage(),
    ),
    GoRoute(
      path: '/reports',
      name: ReportsDashboardPage.routeName,
      builder: (context, state) => const ReportsDashboardPage(),
    ),
    GoRoute(
      path: '/staff',
      name: StaffDashboardPage.routeName,
      builder: (context, state) => const StaffDashboardPage(),
    ),
    GoRoute(
      path: '/settings',
      name: SettingsDashboardPage.routeName,
      builder: (context, state) => const SettingsDashboardPage(),
    ),
  ],
);
