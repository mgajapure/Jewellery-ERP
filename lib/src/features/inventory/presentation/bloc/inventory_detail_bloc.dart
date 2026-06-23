import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';

part 'inventory_detail_event.dart';
part 'inventory_detail_state.dart';

@injectable
class InventoryDetailBloc
    extends Bloc<InventoryDetailEvent, InventoryDetailState> {
  InventoryDetailBloc({required this.repository})
      : super(InventoryDetailInitial()) {
    on<InventoryDetailUpdateStatus>(_onUpdateStatus);
  }

  final InventoryRepository repository;

  Future<void> _onUpdateStatus(
    InventoryDetailUpdateStatus event,
    Emitter<InventoryDetailState> emit,
  ) async {
    emit(InventoryDetailLoading());
    final result = await repository.updateStatus(event.id, event.status);
    result.when(
      success: (item) => emit(InventoryDetailUpdateSuccess(item: item)),
      failure: (e) => emit(InventoryDetailError(message: e.message)),
    );
  }
}
