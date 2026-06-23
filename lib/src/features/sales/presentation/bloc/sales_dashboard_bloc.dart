import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/sales_dashboard_stats.dart';
import '../../domain/repositories/sales_repository.dart';

part 'sales_dashboard_event.dart';
part 'sales_dashboard_state.dart';

@injectable
class SalesDashboardBloc
    extends Bloc<SalesDashboardEvent, SalesDashboardState> {
  SalesDashboardBloc({required this.repository})
      : super(SalesDashboardInitial()) {
    on<SalesDashboardStarted>(_onStarted);
    on<SalesDashboardRefreshed>(_onRefreshed);
  }

  final SalesRepository repository;

  Future<void> _onStarted(
    SalesDashboardStarted event,
    Emitter<SalesDashboardState> emit,
  ) async {
    emit(SalesDashboardLoading());
    await _load(emit);
  }

  Future<void> _onRefreshed(
    SalesDashboardRefreshed event,
    Emitter<SalesDashboardState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<SalesDashboardState> emit) async {
    final result = await repository.getDashboardStats();
    result.when(
      success: (stats) => emit(SalesDashboardLoaded(stats: stats)),
      failure: (e) => emit(SalesDashboardError(message: e.message)),
    );
  }
}
