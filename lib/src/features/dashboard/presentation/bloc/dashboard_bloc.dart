import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({required DashboardRepository repository})
      : _repository = repository,
        super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoad);
    on<RefreshDashboard>(_onRefresh);
  }

  final DashboardRepository _repository;

  Future<void> _onLoad(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    final result = await _repository.getDashboardSummary();
    result.when(
      success: (summary) => emit(DashboardLoaded(summary)),
      failure: (error) => emit(DashboardError(error.message)),
    );
  }

  Future<void> _onRefresh(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    final result = await _repository.getDashboardSummary();
    result.when(
      success: (summary) => emit(DashboardLoaded(summary)),
      failure: (error) => emit(DashboardError(error.message)),
    );
  }
}
