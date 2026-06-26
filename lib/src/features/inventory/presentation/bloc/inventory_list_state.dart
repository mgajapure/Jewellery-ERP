part of 'inventory_list_bloc.dart';

sealed class InventoryListState {}

final class InventoryListInitial extends InventoryListState {}

final class InventoryListLoading extends InventoryListState {}

final class InventoryListLoaded extends InventoryListState {
  InventoryListLoaded({
    required this.items,
    required this.filter,
    required this.query,
  });

  final List<InventoryItem> items;
  final String filter;
  final String query;

  int get availableCount =>
      items.where((i) => i.status == InventoryStatus.available).length;
  double get totalValue =>
      items.fold(0, (s, i) => s + i.sellingPrice);
}

final class InventoryListError extends InventoryListState {
  InventoryListError({required this.message});
  final String message;
}
