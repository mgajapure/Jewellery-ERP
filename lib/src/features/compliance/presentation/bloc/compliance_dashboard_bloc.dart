import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/compliance_entities.dart';
import '../../domain/repositories/compliance_repository.dart';

part 'compliance_dashboard_event.dart';
part 'compliance_dashboard_state.dart';

@injectable
class ComplianceDashboardBloc
    extends Bloc<ComplianceDashboardEvent, ComplianceDashboardState> {
  ComplianceDashboardBloc({required this.repository})
      : super(ComplianceDashboardInitial()) {
    on<ComplianceDashboardStarted>(_onStarted);
    on<ComplianceDashboardRefreshed>(_onRefreshed);
  }

  final ComplianceRepository repository;

  Future<void> _onStarted(
    ComplianceDashboardStarted event,
    Emitter<ComplianceDashboardState> emit,
  ) async {
    emit(ComplianceDashboardLoading());
    await _load(emit);
  }

  Future<void> _onRefreshed(
    ComplianceDashboardRefreshed event,
    Emitter<ComplianceDashboardState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<ComplianceDashboardState> emit) async {
    final result = await repository.getDashboardStats();
    result.when(
      success: (stats) => emit(ComplianceDashboardLoaded(stats: stats)),
      failure: (e) => emit(ComplianceDashboardError(message: e.message)),
    );
  }
}
