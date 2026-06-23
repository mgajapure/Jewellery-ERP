part of 'sales_return_bloc.dart';

sealed class SalesReturnState {}

final class SalesReturnInitial extends SalesReturnState {}

final class SalesReturnLookupLoading extends SalesReturnState {}

final class SalesReturnLookupLoaded extends SalesReturnState {
  SalesReturnLookupLoaded({
    required this.order,
    required this.selectedItemIds,
  });
  final SaleOrder order;
  final Set<String> selectedItemIds;

  SalesReturnLookupLoaded copyWith({Set<String>? selectedItemIds}) =>
      SalesReturnLookupLoaded(
        order: order,
        selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      );
}

final class SalesReturnSubmitting extends SalesReturnState {}

final class SalesReturnSuccess extends SalesReturnState {}

final class SalesReturnError extends SalesReturnState {
  SalesReturnError({required this.message});
  final String message;
}
