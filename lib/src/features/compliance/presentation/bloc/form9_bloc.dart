import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/compliance_entities.dart';
import '../../domain/repositories/compliance_repository.dart';

part 'form9_event.dart';
part 'form9_state.dart';

@injectable
class Form9Bloc extends Bloc<Form9Event, Form9State> {
  Form9Bloc({required this.repository}) : super(Form9Initial()) {
    on<Form9Started>(_onStarted);
    on<Form9DateRangeChanged>(_onDateRangeChanged);
  }

  final ComplianceRepository repository;

  String _from = '01 Jan 2026';
  String _to = '31 Jan 2026';

  Future<void> _onStarted(
    Form9Started event,
    Emitter<Form9State> emit,
  ) async {
    emit(Form9Loading());
    await _load(emit);
  }

  Future<void> _onDateRangeChanged(
    Form9DateRangeChanged event,
    Emitter<Form9State> emit,
  ) async {
    _from = event.from;
    _to = event.to;
    emit(Form9Loading());
    await _load(emit);
  }

  Future<void> _load(Emitter<Form9State> emit) async {
    final result = await repository.getForm9Register(from: _from, to: _to);
    result.when(
      success: (register) =>
          emit(Form9Loaded(register: register, from: _from, to: _to)),
      failure: (e) => emit(Form9Error(message: e.message)),
    );
  }
}
