part of 'supplier_bloc.dart';

sealed class SupplierState {
  const SupplierState();
}

final class SupplierInitial extends SupplierState {
  const SupplierInitial();
}

final class SupplierLoading extends SupplierState {
  const SupplierLoading();
}

final class SupplierLoaded extends SupplierState {
  const SupplierLoaded({
    required this.suppliers,
    required this.filter,
    required this.query,
  });

  final List<Supplier> suppliers;
  final String filter;
  final String query;

  SupplierLoaded copyWith({
    List<Supplier>? suppliers,
    String? filter,
    String? query,
  }) =>
      SupplierLoaded(
        suppliers: suppliers ?? this.suppliers,
        filter: filter ?? this.filter,
        query: query ?? this.query,
      );
}

final class SupplierError extends SupplierState {
  const SupplierError(this.message);

  final String message;
}
