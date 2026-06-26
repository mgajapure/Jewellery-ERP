import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/purchase_dashboard_stats.dart';
import '../../domain/repositories/purchase_repository.dart';

part 'purchase_dashboard_event.dart';
part 'purchase_dashboard_state.dart';

@injectable
class PurchaseDashboardBloc
    extends Bloc<PurchaseDashboardEvent, PurchaseDashboardState> {
  PurchaseDashboardBloc({required PurchaseRepository repository})
      : _repository = repository,
        super(const PurchaseDashboardInitial()) {
    on<PurchaseDashboardStarted>(_onStarted);
    on<PurchaseDashboardRefreshed>(_onRefreshed);
  }

  final PurchaseRepository _repository;

  Future<void> _onStarted(
    PurchaseDashboardStarted event,
    Emitter<PurchaseDashboardState> emit,
  ) async {
    emit(const PurchaseDashboardLoading());
    await _load(emit);
  }

  Future<void> _onRefreshed(
    PurchaseDashboardRefreshed event,
    Emitter<PurchaseDashboardState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<PurchaseDashboardState> emit) async {
    final result = await _repository.getDashboardStats();
    result.when(
      success: (stats) => emit(PurchaseDashboardLoaded(stats)),
      failure: (e) => emit(PurchaseDashboardError(e.message)),
    );
  }
}
