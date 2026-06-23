import 'package:equatable/equatable.dart';

sealed class VaultSearchEvent extends Equatable {
  const VaultSearchEvent();

  @override
  List<Object?> get props => [];
}

class VaultSearchStarted extends VaultSearchEvent {
  const VaultSearchStarted();
}

class VaultSearchQueryChanged extends VaultSearchEvent {
  const VaultSearchQueryChanged({required this.query, required this.searchMode});

  final String query;
  final String searchMode;

  @override
  List<Object?> get props => [query, searchMode];
}

class VaultSearchRefreshed extends VaultSearchEvent {
  const VaultSearchRefreshed();
}
