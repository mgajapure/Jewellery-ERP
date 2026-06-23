import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';

part 'add_inventory_event.dart';
part 'add_inventory_state.dart';

@injectable
class AddInventoryBloc extends Bloc<AddInventoryEvent, AddInventoryState> {
  AddInventoryBloc({required this.repository}) : super(AddInventoryInitial()) {
    on<AddInventorySubmitted>(_onSubmitted);
  }

  final InventoryRepository repository;

  Future<void> _onSubmitted(
    AddInventorySubmitted event,
    Emitter<AddInventoryState> emit,
  ) async {
    emit(AddInventoryLoading());
    final result = await repository.createItem(event.payload);
    result.when(
      success: (item) => emit(AddInventorySuccess(item: item)),
      failure: (e) => emit(AddInventoryError(message: e.message)),
    );
  }
}
