part of 'purchase_ledger_bloc.dart';

sealed class PurchaseLedgerEvent {
  const PurchaseLedgerEvent();
}

final class PurchaseLedgerStarted extends PurchaseLedgerEvent {
  const PurchaseLedgerStarted();
}

final class PurchaseLedgerFilterChanged extends PurchaseLedgerEvent {
  const PurchaseLedgerFilterChanged(this.filter);

  final String filter;
}

final class PurchaseLedgerSearchChanged extends PurchaseLedgerEvent {
  const PurchaseLedgerSearchChanged(this.query);

  final String query;
}

final class PurchaseLedgerRefreshed extends PurchaseLedgerEvent {
  const PurchaseLedgerRefreshed();
}
