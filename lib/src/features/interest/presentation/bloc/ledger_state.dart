import 'package:equatable/equatable.dart';

import '../../domain/entities/interest_ledger.dart';

sealed class LedgerState extends Equatable {
  const LedgerState();

  @override
  List<Object?> get props => [];
}

class LedgerInitial extends LedgerState {
  const LedgerInitial();
}

class LedgerLoading extends LedgerState {
  const LedgerLoading();
}

class LedgerLoaded extends LedgerState {
  const LedgerLoaded(this.ledger);

  final InterestLedger ledger;

  @override
  List<Object?> get props => [ledger];
}

class LedgerError extends LedgerState {
  const LedgerError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
