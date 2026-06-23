part of 'supplier_bloc.dart';

sealed class SupplierEvent {
  const SupplierEvent();
}

final class SupplierListStarted extends SupplierEvent {
  const SupplierListStarted();
}

final class SupplierFilterChanged extends SupplierEvent {
  const SupplierFilterChanged(this.filter);

  final String filter;
}

final class SupplierSearchChanged extends SupplierEvent {
  const SupplierSearchChanged(this.query);

  final String query;
}

final class SupplierListRefreshed extends SupplierEvent {
  const SupplierListRefreshed();
}
