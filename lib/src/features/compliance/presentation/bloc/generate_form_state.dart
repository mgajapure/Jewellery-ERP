part of 'generate_form_bloc.dart';

sealed class GenerateFormState {}

final class GenerateFormInitial extends GenerateFormState {}

final class GenerateFormLoading extends GenerateFormState {}

final class GenerateFormSuccess extends GenerateFormState {
  GenerateFormSuccess({required this.formType});
  final String formType;
}

final class GenerateFormError extends GenerateFormState {
  GenerateFormError({required this.message});
  final String message;
}
