part of 'form9_bloc.dart';

sealed class Form9Event {}

final class Form9Started extends Form9Event {}

final class Form9DateRangeChanged extends Form9Event {
  Form9DateRangeChanged({required this.from, required this.to});
  final String from;
  final String to;
}
