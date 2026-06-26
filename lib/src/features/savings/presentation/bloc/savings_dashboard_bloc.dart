import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/savings_entities.dart';
import '../../domain/repositories/savings_repository.dart';

part 'savings_dashboard_event.dart';
part 'savings_dashboard_state.dart';

@injectable
class SavingsDashboardBloc
    extends Bloc<SavingsDashboardEvent, SavingsDashboardState> {
  SavingsDashboardBloc({required this.repository})
      : super(SavingsDashboardInitial()) {
    on<SavingsDashboardStarted>(_onStarted);
    on<SavingsDashboardRefreshed>(_onRefreshed);
  }

  final SavingsRepository repository;

  Future<void> _onStarted(
    SavingsDashboardStarted event,
    Emitter<SavingsDashboardState> emit,
  ) async {
    emit(SavingsDashboardLoading());
    await _load(emit);
  }

  Future<void> _onRefreshed(
    SavingsDashboardRefreshed event,
    Emitter<SavingsDashboardState> emit,
  ) async {
    emit(SavingsDashboardLoading());
    await _load(emit);
  }

  Future<void> _load(Emitter<SavingsDashboardState> emit) async {
    final result = await repository.getDashboardStats();
    result.when(
      success: (stats) => emit(SavingsDashboardLoaded(stats: stats)),
      failure: (e) => emit(SavingsDashboardError(message: e.message)),
    );
  }
}
