import 'package:equatable/equatable.dart';

sealed class LedgerEvent extends Equatable {
  const LedgerEvent();

  @override
  List<Object?> get props => [];
}

class LedgerLoadRequested extends LedgerEvent {
  const LedgerLoadRequested(this.girviId);

  final String girviId;

  @override
  List<Object?> get props => [girviId];
}

class LedgerRefreshRequested extends LedgerEvent {
  const LedgerRefreshRequested(this.girviId);

  final String girviId;

  @override
  List<Object?> get props => [girviId];
}
