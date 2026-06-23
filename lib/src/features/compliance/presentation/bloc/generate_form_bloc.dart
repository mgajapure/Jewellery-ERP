import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/compliance_repository.dart';

part 'generate_form_event.dart';
part 'generate_form_state.dart';

@injectable
class GenerateFormBloc extends Bloc<GenerateFormEvent, GenerateFormState> {
  GenerateFormBloc({required this.repository}) : super(GenerateFormInitial()) {
    on<GenerateFormSubmitted>(_onSubmitted);
  }

  final ComplianceRepository repository;

  Future<void> _onSubmitted(
    GenerateFormSubmitted event,
    Emitter<GenerateFormState> emit,
  ) async {
    emit(GenerateFormLoading());
    final result = await repository.generateForm(event.formType);
    result.when(
      success: (_) => emit(GenerateFormSuccess(formType: event.formType)),
      failure: (e) => emit(GenerateFormError(message: e.message)),
    );
  }
}
