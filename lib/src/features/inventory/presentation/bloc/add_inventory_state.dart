part of 'add_inventory_bloc.dart';

sealed class AddInventoryState {}

final class AddInventoryInitial extends AddInventoryState {}

final class AddInventoryLoading extends AddInventoryState {}

final class AddInventorySuccess extends AddInventoryState {
  AddInventorySuccess({required this.item});
  final InventoryItem item;
}

final class AddInventoryError extends AddInventoryState {
  AddInventoryError({required this.message});
  final String message;
}
