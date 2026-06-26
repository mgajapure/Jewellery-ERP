part of 'inventory_list_bloc.dart';

sealed class InventoryListEvent {}

final class InventoryListStarted extends InventoryListEvent {}

final class InventoryListFilterChanged extends InventoryListEvent {
  InventoryListFilterChanged({required this.filter});
  final String filter;
}

final class InventoryListSearchChanged extends InventoryListEvent {
  InventoryListSearchChanged({required this.query});
  final String query;
}

final class InventoryListRefreshed extends InventoryListEvent {}
