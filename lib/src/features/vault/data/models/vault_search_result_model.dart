import '../../domain/entities/vault_search_result.dart';

class VaultSearchResultModel extends VaultSearchResult {
  const VaultSearchResultModel({
    required super.customerName,
    required super.girviId,
    required super.serialId,
    required super.status,
    required super.coordinate,
    required super.mobile,
  });

  factory VaultSearchResultModel.fromJson(Map<String, dynamic> json) {
    return VaultSearchResultModel(
      customerName: json['customerName'] as String,
      girviId: json['girviId'] as String,
      serialId: json['serialId'] as String,
      status: json['status'] as String,
      coordinate: json['coordinate'] as String,
      mobile: json['mobile'] as String,
    );
  }
}

class VaultOccupancyModel extends VaultOccupancy {
  const VaultOccupancyModel({
    required super.vaultName,
    required super.occupied,
    required super.total,
  });

  factory VaultOccupancyModel.fromJson(Map<String, dynamic> json) {
    return VaultOccupancyModel(
      vaultName: json['vaultName'] as String,
      occupied: json['occupied'] as int,
      total: json['total'] as int,
    );
  }
}
