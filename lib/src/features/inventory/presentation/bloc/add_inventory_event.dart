part of 'add_inventory_bloc.dart';

sealed class AddInventoryEvent {}

final class AddInventorySubmitted extends AddInventoryEvent {
  AddInventorySubmitted({required this.payload});
  final Map<String, dynamic> payload;
}
