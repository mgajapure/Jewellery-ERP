import 'package:equatable/equatable.dart';

import '../../domain/entities/vault_search_result.dart';

sealed class VaultSearchState extends Equatable {
  const VaultSearchState();

  @override
  List<Object?> get props => [];
}

class VaultSearchInitial extends VaultSearchState {
  const VaultSearchInitial();
}

class VaultSearchLoading extends VaultSearchState {
  const VaultSearchLoading();
}

class VaultSearchReady extends VaultSearchState {
  const VaultSearchReady({
    required this.occupancy,
    required this.query,
    required this.searchMode,
    this.searchResults,
    this.isSearching = false,
  });

  final List<VaultOccupancy> occupancy;
  final String query;
  final String searchMode;
  final List<VaultSearchResult>? searchResults;
  final bool isSearching;

  int get totalSlots => occupancy.fold(0, (sum, v) => sum + v.total);
  int get occupiedSlots => occupancy.fold(0, (sum, v) => sum + v.occupied);
  int get availableSlots => totalSlots - occupiedSlots;
  double get occupancyPercentage =>
      totalSlots == 0 ? 0 : (occupiedSlots / totalSlots) * 100;

  VaultSearchReady copyWith({
    List<VaultOccupancy>? occupancy,
    String? query,
    String? searchMode,
    List<VaultSearchResult>? searchResults,
    bool? isSearching,
    bool clearResults = false,
  }) {
    return VaultSearchReady(
      occupancy: occupancy ?? this.occupancy,
      query: query ?? this.query,
      searchMode: searchMode ?? this.searchMode,
      searchResults: clearResults ? null : searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props =>
      [occupancy, query, searchMode, searchResults, isSearching];
}

class VaultSearchError extends VaultSearchState {
  const VaultSearchError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
