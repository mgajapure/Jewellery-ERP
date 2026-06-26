import '../../domain/entities/savings_entities.dart';

class SavingsPlanModel extends SavingsPlan {
  const SavingsPlanModel({
    required super.id,
    required super.nameMr,
    required super.nameEn,
    required super.durationMonths,
    required super.monthlyAmount,
    required super.bonusMonths,
    required super.activeSubscribers,
    required super.isActive,
  });

  factory SavingsPlanModel.fromJson(Map<String, dynamic> json) {
    return SavingsPlanModel(
      id: json['id'] as String,
      nameMr: json['nameMr'] as String,
      nameEn: json['nameEn'] as String,
      durationMonths: json['durationMonths'] as int,
      monthlyAmount: (json['monthlyAmount'] as num).toDouble(),
      bonusMonths: json['bonusMonths'] as int? ?? 1,
      activeSubscribers: json['activeSubscribers'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

class SavingsSubscriptionModel extends SavingsSubscription {
  const SavingsSubscriptionModel({
    required super.id,
    required super.customerName,
    required super.customerId,
    required super.planNameMr,
    required super.planNameEn,
    required super.monthlyAmount,
    required super.paidInstallments,
    required super.totalInstallments,
    required super.nextDueDate,
    required super.totalPaid,
    required super.status,
  });

  factory SavingsSubscriptionModel.fromJson(Map<String, dynamic> json) {
    final statusStr =
        (json['status'] as String? ?? 'active').toLowerCase();
    final status = SavingsSubscriptionStatus.values.firstWhere(
      (s) => s.name == statusStr,
      orElse: () => SavingsSubscriptionStatus.active,
    );
    return SavingsSubscriptionModel(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      customerId: json['customerId'] as String,
      planNameMr: json['planNameMr'] as String,
      planNameEn: json['planNameEn'] as String,
      monthlyAmount: (json['monthlyAmount'] as num).toDouble(),
      paidInstallments: json['paidInstallments'] as int,
      totalInstallments: json['totalInstallments'] as int,
      nextDueDate: json['nextDueDate'] as String,
      totalPaid: (json['totalPaid'] as num).toDouble(),
      status: status,
    );
  }
}

class SavingsDashboardStatsModel extends SavingsDashboardStats {
  const SavingsDashboardStatsModel({
    required super.activeSubscriptions,
    required super.collectedThisMonth,
    required super.totalCollected,
    required super.activePlans,
    required super.plans,
    required super.recentSubscriptions,
  });

  factory SavingsDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final plansList = (json['plans'] as List<dynamic>? ?? [])
        .map((p) =>
            SavingsPlanModel.fromJson(p as Map<String, dynamic>))
        .toList();
    final subsList = (json['recentSubscriptions'] as List<dynamic>? ?? [])
        .map((s) =>
            SavingsSubscriptionModel.fromJson(s as Map<String, dynamic>))
        .toList();
    return SavingsDashboardStatsModel(
      activeSubscriptions: json['activeSubscriptions'] as int,
      collectedThisMonth:
          (json['collectedThisMonth'] as num).toDouble(),
      totalCollected: (json['totalCollected'] as num).toDouble(),
      activePlans: json['activePlans'] as int,
      plans: plansList,
      recentSubscriptions: subsList,
    );
  }
}
