part of 'form9_bloc.dart';

sealed class Form9State {}

final class Form9Initial extends Form9State {}

final class Form9Loading extends Form9State {}

final class Form9Loaded extends Form9State {
  Form9Loaded({
    required this.register,
    required this.from,
    required this.to,
  });
  final Form9Register register;
  final String from;
  final String to;
}

final class Form9Error extends Form9State {
  Form9Error({required this.message});
  final String message;
}
