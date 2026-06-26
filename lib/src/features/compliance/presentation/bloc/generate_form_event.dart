part of 'generate_form_bloc.dart';

sealed class GenerateFormEvent {}

final class GenerateFormSubmitted extends GenerateFormEvent {
  GenerateFormSubmitted({required this.formType});
  final String formType;
}
