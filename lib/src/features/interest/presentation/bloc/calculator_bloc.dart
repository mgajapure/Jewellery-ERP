import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/interest_calculation.dart';
import '../../domain/usecases/calculate_interest.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';

@injectable
class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc()
      : _useCase = const CalculateInterest(),
        super(const CalculatorInitial()) {
    on<CalculatorStarted>(_onStarted);
    on<CalculatorInputChanged>(_onInputChanged);
    on<CalculatorRecalculate>(_onRecalculate);
  }

  final CalculateInterest _useCase;

  static const _defaultPrincipal = 100000.0;
  static const _defaultRate = 12.0;
  static const _defaultDays = 180;

  void _onStarted(CalculatorStarted event, Emitter<CalculatorState> emit) {
    final state = CalculatorReady(
      principal: _defaultPrincipal,
      ratePercent: _defaultRate,
      days: _defaultDays,
      startDate: DateTime.now(),
      interestType: InterestType.simple,
    );
    emit(state.copyWith(result: _compute(state)));
  }

  void _onInputChanged(
    CalculatorInputChanged event,
    Emitter<CalculatorState> emit,
  ) {
    if (state is! CalculatorReady) return;
    final current = state as CalculatorReady;
    final updated = current.copyWith(
      principal: event.principal,
      ratePercent: event.ratePercent,
      days: event.days,
      startDate: event.startDate,
      interestType: event.interestType,
    );
    emit(updated.copyWith(result: _compute(updated)));
  }

  void _onRecalculate(
    CalculatorRecalculate event,
    Emitter<CalculatorState> emit,
  ) {
    if (state is! CalculatorReady) return;
    final current = state as CalculatorReady;
    emit(current.copyWith(result: _compute(current)));
  }

  InterestCalculation _compute(CalculatorReady s) {
    return _useCase(
      principal: s.principal,
      ratePercent: s.ratePercent,
      days: s.days,
      startDate: s.startDate,
      interestType: s.interestType,
    );
  }
}
