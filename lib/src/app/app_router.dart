import 'package:go_router/go_router.dart';

import '../features/auth/auth.dart';
import '../features/dashboard/dashboard_page.dart';
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
  ],
);
