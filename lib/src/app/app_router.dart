import 'package:go_router/go_router.dart';

import '../features/auth/auth.dart';
import '../features/customer/customer.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/girvi/girvi.dart';
import '../features/inventory/inventory_page.dart';

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
      builder: (context, state) => const OtpVerificationPage(),
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
      name: InventoryPage.routeName,
      builder: (context, state) => const InventoryPage(),
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
  ],
);
