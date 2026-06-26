import 'package:equatable/equatable.dart';

import '../../domain/entities/girvi.dart';

sealed class GirviListState extends Equatable {
  const GirviListState();

  @override
  List<Object?> get props => [];
}

class GirviListInitial extends GirviListState {
  const GirviListInitial();
}

class GirviListLoading extends GirviListState {
  const GirviListLoading();
}

class GirviListLoaded extends GirviListState {
  const GirviListLoaded({
    required this.girviList,
    this.activeFilter,
    this.searchQuery = '',
  });

  final List<Girvi> girviList;
  final GirviStatus? activeFilter;
  final String searchQuery;

  @override
  List<Object?> get props => [girviList, activeFilter, searchQuery];
}

class GirviListError extends GirviListState {
  const GirviListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
