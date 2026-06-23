enum SavingsSubscriptionStatus {
  active,
  completed,
  defaulted,
  cancelled;

  String get labelMr {
    switch (this) {
      case active:
        return 'सक्रिय';
      case completed:
        return 'पूर्ण';
      case defaulted:
        return 'थकबाकी';
      case cancelled:
        return 'रद्द';
    }
  }

  String get labelEn {
    switch (this) {
      case active:
        return 'Active';
      case completed:
        return 'Completed';
      case defaulted:
        return 'Defaulted';
      case cancelled:
        return 'Cancelled';
    }
  }
}

class SavingsPlan {
  const SavingsPlan({
    required this.id,
    required this.nameMr,
    required this.nameEn,
    required this.durationMonths,
    required this.monthlyAmount,
    required this.bonusMonths,
    required this.activeSubscribers,
    required this.isActive,
  });

  final String id;
  final String nameMr;
  final String nameEn;
  final int durationMonths;
  final double monthlyAmount;
  final int bonusMonths;
  final int activeSubscribers;
  final bool isActive;

  double get totalAmount => monthlyAmount * (durationMonths + bonusMonths);
  double get clientContribution => monthlyAmount * durationMonths;
}

class SavingsSubscription {
  const SavingsSubscription({
    required this.id,
    required this.customerName,
    required this.customerId,
    required this.planNameMr,
    required this.planNameEn,
    required this.monthlyAmount,
    required this.paidInstallments,
    required this.totalInstallments,
    required this.nextDueDate,
    required this.totalPaid,
    required this.status,
  });

  final String id;
  final String customerName;
  final String customerId;
  final String planNameMr;
  final String planNameEn;
  final double monthlyAmount;
  final int paidInstallments;
  final int totalInstallments;
  final String nextDueDate;
  final double totalPaid;
  final SavingsSubscriptionStatus status;

  double get completionPercent =>
      totalInstallments == 0 ? 0 : paidInstallments / totalInstallments;
}

class SavingsDashboardStats {
  const SavingsDashboardStats({
    required this.activeSubscriptions,
    required this.collectedThisMonth,
    required this.totalCollected,
    required this.activePlans,
    required this.plans,
    required this.recentSubscriptions,
  });

  final int activeSubscriptions;
  final double collectedThisMonth;
  final double totalCollected;
  final int activePlans;
  final List<SavingsPlan> plans;
  final List<SavingsSubscription> recentSubscriptions;
}
