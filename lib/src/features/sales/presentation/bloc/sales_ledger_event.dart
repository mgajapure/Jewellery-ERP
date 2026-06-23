part of 'sales_ledger_bloc.dart';

sealed class SalesLedgerEvent {}

final class SalesLedgerStarted extends SalesLedgerEvent {}

final class SalesLedgerFilterChanged extends SalesLedgerEvent {
  SalesLedgerFilterChanged({required this.filter});
  final String filter;
}

final class SalesLedgerSearchChanged extends SalesLedgerEvent {
  SalesLedgerSearchChanged({required this.query});
  final String query;
}

final class SalesLedgerRefreshed extends SalesLedgerEvent {}
