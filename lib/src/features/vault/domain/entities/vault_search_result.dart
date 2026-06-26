import 'package:equatable/equatable.dart';

class VaultSearchResult extends Equatable {
  const VaultSearchResult({
    required this.customerName,
    required this.girviId,
    required this.serialId,
    required this.status,
    required this.coordinate,
    required this.mobile,
  });

  final String customerName;
  final String girviId;
  final String serialId;
  final String status;
  final String coordinate;
  final String mobile;

  @override
  List<Object?> get props => [girviId];
}

class VaultOccupancy extends Equatable {
  const VaultOccupancy({
    required this.vaultName,
    required this.occupied,
    required this.total,
  });

  final String vaultName;
  final int occupied;
  final int total;

  double get percentage => total == 0 ? 0 : (occupied / total) * 100;
  int get available => total - occupied;

  @override
  List<Object?> get props => [vaultName, occupied, total];
}
