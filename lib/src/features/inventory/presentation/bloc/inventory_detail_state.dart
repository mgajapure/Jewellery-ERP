part of 'inventory_detail_bloc.dart';

sealed class InventoryDetailState {}

final class InventoryDetailInitial extends InventoryDetailState {}

final class InventoryDetailLoading extends InventoryDetailState {}

final class InventoryDetailUpdateSuccess extends InventoryDetailState {
  InventoryDetailUpdateSuccess({required this.item});
  final InventoryItem item;
}

final class InventoryDetailError extends InventoryDetailState {
  InventoryDetailError({required this.message});
  final String message;
}
