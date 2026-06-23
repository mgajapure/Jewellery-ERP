part of 'purchase_ledger_bloc.dart';

sealed class PurchaseLedgerState {
  const PurchaseLedgerState();
}

final class PurchaseLedgerInitial extends PurchaseLedgerState {
  const PurchaseLedgerInitial();
}

final class PurchaseLedgerLoading extends PurchaseLedgerState {
  const PurchaseLedgerLoading();
}

final class PurchaseLedgerLoaded extends PurchaseLedgerState {
  const PurchaseLedgerLoaded({
    required this.entries,
    required this.filter,
    required this.query,
  });

  final List<PurchaseEntry> entries;
  final String filter;
  final String query;

  double get totalAmount =>
      entries.fold(0.0, (sum, e) => sum + e.totalAmount);

  PurchaseLedgerLoaded copyWith({
    List<PurchaseEntry>? entries,
    String? filter,
    String? query,
  }) =>
      PurchaseLedgerLoaded(
        entries: entries ?? this.entries,
        filter: filter ?? this.filter,
        query: query ?? this.query,
      );
}

final class PurchaseLedgerError extends PurchaseLedgerState {
  const PurchaseLedgerError(this.message);

  final String message;
}
