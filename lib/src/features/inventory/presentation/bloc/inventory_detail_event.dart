part of 'inventory_detail_bloc.dart';

sealed class InventoryDetailEvent {}

final class InventoryDetailUpdateStatus extends InventoryDetailEvent {
  InventoryDetailUpdateStatus({required this.id, required this.status});
  final String id;
  final InventoryStatus status;
}
