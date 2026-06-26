import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/reports_entities.dart';
import '../../domain/repositories/reports_repository.dart';

part 'reports_dashboard_event.dart';
part 'reports_dashboard_state.dart';

@injectable
class ReportsDashboardBloc
    extends Bloc<ReportsDashboardEvent, ReportsDashboardState> {
  ReportsDashboardBloc({required this.repository})
      : super(ReportsDashboardInitial()) {
    on<ReportsDashboardStarted>(_onStarted);
    on<ReportsDashboardPeriodChanged>(_onPeriodChanged);
  }

  final ReportsRepository repository;

  String _period = 'month';

  Future<void> _onStarted(
    ReportsDashboardStarted event,
    Emitter<ReportsDashboardState> emit,
  ) async {
    emit(ReportsDashboardLoading());
    await _load(emit);
  }

  Future<void> _onPeriodChanged(
    ReportsDashboardPeriodChanged event,
    Emitter<ReportsDashboardState> emit,
  ) async {
    _period = event.period;
    emit(ReportsDashboardLoading());
    await _load(emit);
  }

  Future<void> _load(Emitter<ReportsDashboardState> emit) async {
    final result = await repository.getDashboardData(period: _period);
    result.when(
      success: (data) =>
          emit(ReportsDashboardLoaded(data: data, period: _period)),
      failure: (e) => emit(ReportsDashboardError(message: e.message)),
    );
  }
}
