part of 'sales_ledger_bloc.dart';

sealed class SalesLedgerState {}

final class SalesLedgerInitial extends SalesLedgerState {}

final class SalesLedgerLoading extends SalesLedgerState {}

final class SalesLedgerLoaded extends SalesLedgerState {
  SalesLedgerLoaded({
    required this.orders,
    required this.filter,
    required this.query,
  });
  final List<SaleOrder> orders;
  final String filter;
  final String query;

  double get totalRevenue =>
      orders.fold(0, (sum, o) => sum + o.totalAmount);
}

final class SalesLedgerError extends SalesLedgerState {
  SalesLedgerError({required this.message});
  final String message;
}
