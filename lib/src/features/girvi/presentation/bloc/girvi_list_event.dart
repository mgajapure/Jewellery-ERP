import 'package:equatable/equatable.dart';

import '../../domain/entities/girvi.dart';

sealed class GirviListEvent extends Equatable {
  const GirviListEvent();

  @override
  List<Object?> get props => [];
}

class LoadGirviList extends GirviListEvent {
  const LoadGirviList();
}

class FilterGirviByStatus extends GirviListEvent {
  const FilterGirviByStatus(this.status);

  final GirviStatus? status;

  @override
  List<Object?> get props => [status];
}

class SearchGirviList extends GirviListEvent {
  const SearchGirviList(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class RefreshGirviList extends GirviListEvent {
  const RefreshGirviList();
}
