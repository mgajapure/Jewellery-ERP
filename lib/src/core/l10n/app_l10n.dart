import 'app_language.dart';

abstract class AppL10n {
  const AppL10n();

  static AppL10n forLanguage(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.mr:
        return const _MrStrings();
      case AppLanguage.hi:
        return const _HiStrings();
      case AppLanguage.en:
        return const _EnStrings();
    }
  }

  // Navigation tab labels
  String get navDashboard;
  String get navGirvi;
  String get navCustomers;
  String get navMore;

  // Screen titles
  String get titleDashboard;
  String get titleGirvi;
  String get titleCustomers;
  String get titleStaff;
  String get titleSettings;
  String get titleMore;

  // Common actions
  String get btnSave;
  String get btnCancel;
  String get btnAdd;
  String get btnEdit;
  String get btnDelete;
  String get btnSearch;
  String get btnClose;
  String get btnLogout;

  // Status words
  String get statusActive;
  String get statusInactive;
  String get statusDue;
  String get statusOverdue;
  String get statusPaid;

  // Units
  String get perGram;
  String get perMonth;

  // Language names
  String get langEnglish;
  String get langMarathi;
  String get langHindi;

  // Dashboard
  String get dashTotal;
  String get dashActive;
  String get dashTodayDue;
  String get dashCustomers;

  // Staff
  String get staffTotal;
  String get staffActive;
  String get staffInactive;
  String get staffSearchHint;
  String get staffAddNew;
  String get staffName;
  String get staffPhone;
  String get staffRole;
  String get staffJoined;

  // Settings sections
  String get settingsShopProfile;
  String get settingsShopName;
  String get settingsAddress;
  String get settingsGstNumber;
  String get settingsPanNumber;
  String get settingsTodaysRates;
  String get settingsGold24k;
  String get settingsGold22k;
  String get settingsSilver;
  String get settingsInterestRates;
  String get settingsGirviInterest;
  String get settingsPenalInterest;
  String get settingsLanguage;
  String get settingsNotifications;
  String get settingsDueReminders;
  String get settingsPaymentAlerts;
  String get settingsExpiryAlerts;
  String get settingsSecurity;
  String get settingsBiometricLock;
  String get settingsChangePIN;
  String get settingsAbout;
  String get settingsVersion;
  String get settingsDeveloper;
  String get settingsPrivacyPolicy;
  String get settingsContactSupport;
}

// ─── English ────────────────────────────────────────────────────────────────

class _EnStrings extends AppL10n {
  const _EnStrings();

  @override
  String get navDashboard => 'Dashboard';
  @override
  String get navGirvi => 'Girvi';
  @override
  String get navCustomers => 'Customers';
  @override
  String get navMore => 'More';

  @override
  String get titleDashboard => 'Dashboard';
  @override
  String get titleGirvi => 'Girvi';
  @override
  String get titleCustomers => 'Customers';
  @override
  String get titleStaff => 'Staff';
  @override
  String get titleSettings => 'Settings';
  @override
  String get titleMore => 'More';

  @override
  String get btnSave => 'Save';
  @override
  String get btnCancel => 'Cancel';
  @override
  String get btnAdd => 'Add';
  @override
  String get btnEdit => 'Edit';
  @override
  String get btnDelete => 'Delete';
  @override
  String get btnSearch => 'Search';
  @override
  String get btnClose => 'Close';
  @override
  String get btnLogout => 'Log Out';

  @override
  String get statusActive => 'Active';
  @override
  String get statusInactive => 'Inactive';
  @override
  String get statusDue => 'Due';
  @override
  String get statusOverdue => 'Overdue';
  @override
  String get statusPaid => 'Paid';

  @override
  String get perGram => 'per gram';
  @override
  String get perMonth => 'per month';

  @override
  String get langEnglish => 'English';
  @override
  String get langMarathi => 'Marathi';
  @override
  String get langHindi => 'Hindi';

  @override
  String get dashTotal => 'Total';
  @override
  String get dashActive => 'Active';
  @override
  String get dashTodayDue => "Today's Due";
  @override
  String get dashCustomers => 'Customers';

  @override
  String get staffTotal => 'Total';
  @override
  String get staffActive => 'Active';
  @override
  String get staffInactive => 'Inactive';
  @override
  String get staffSearchHint => 'Search by name or phone…';
  @override
  String get staffAddNew => 'Add Staff';
  @override
  String get staffName => 'Full Name';
  @override
  String get staffPhone => 'Phone';
  @override
  String get staffRole => 'Role';
  @override
  String get staffJoined => 'Joined';

  @override
  String get settingsShopProfile => 'Shop Profile';
  @override
  String get settingsShopName => 'Shop Name';
  @override
  String get settingsAddress => 'Address';
  @override
  String get settingsGstNumber => 'GST Number';
  @override
  String get settingsPanNumber => 'PAN Number';
  @override
  String get settingsTodaysRates => "Today's Rates";
  @override
  String get settingsGold24k => 'Gold (24K)';
  @override
  String get settingsGold22k => 'Gold (22K)';
  @override
  String get settingsSilver => 'Silver';
  @override
  String get settingsInterestRates => 'Interest Rates';
  @override
  String get settingsGirviInterest => 'Girvi Interest (monthly)';
  @override
  String get settingsPenalInterest => 'Penal Interest';
  @override
  String get settingsLanguage => 'Language';
  @override
  String get settingsNotifications => 'Notifications';
  @override
  String get settingsDueReminders => 'Due date reminders';
  @override
  String get settingsPaymentAlerts => 'Payment alerts';
  @override
  String get settingsExpiryAlerts => 'Expiry alerts';
  @override
  String get settingsSecurity => 'Security';
  @override
  String get settingsBiometricLock => 'Biometric lock';
  @override
  String get settingsChangePIN => 'Change PIN';
  @override
  String get settingsAbout => 'About App';
  @override
  String get settingsVersion => 'Version';
  @override
  String get settingsDeveloper => 'Developer';
  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';
  @override
  String get settingsContactSupport => 'Contact Support';
}

// ─── Marathi ────────────────────────────────────────────────────────────────

class _MrStrings extends AppL10n {
  const _MrStrings();

  @override
  String get navDashboard => 'डॅशबोर्ड';
  @override
  String get navGirvi => 'गिरवी';
  @override
  String get navCustomers => 'ग्राहक';
  @override
  String get navMore => 'अधिक';

  @override
  String get titleDashboard => 'डॅशबोर्ड';
  @override
  String get titleGirvi => 'गिरवी';
  @override
  String get titleCustomers => 'ग्राहक';
  @override
  String get titleStaff => 'कर्मचारी';
  @override
  String get titleSettings => 'सेटिंग्ज';
  @override
  String get titleMore => 'अधिक';

  @override
  String get btnSave => 'जतन करा';
  @override
  String get btnCancel => 'रद्द करा';
  @override
  String get btnAdd => 'जोडा';
  @override
  String get btnEdit => 'संपादित करा';
  @override
  String get btnDelete => 'हटवा';
  @override
  String get btnSearch => 'शोधा';
  @override
  String get btnClose => 'बंद करा';
  @override
  String get btnLogout => 'लॉग आउट';

  @override
  String get statusActive => 'सक्रिय';
  @override
  String get statusInactive => 'निष्क्रिय';
  @override
  String get statusDue => 'देय';
  @override
  String get statusOverdue => 'थकीत';
  @override
  String get statusPaid => 'भरलेले';

  @override
  String get perGram => 'प्रति ग्राम';
  @override
  String get perMonth => 'प्रति महिना';

  @override
  String get langEnglish => 'इंग्रजी';
  @override
  String get langMarathi => 'मराठी';
  @override
  String get langHindi => 'हिंदी';

  @override
  String get dashTotal => 'एकूण';
  @override
  String get dashActive => 'सक्रिय';
  @override
  String get dashTodayDue => 'आजचे देय';
  @override
  String get dashCustomers => 'ग्राहक';

  @override
  String get staffTotal => 'एकूण';
  @override
  String get staffActive => 'सक्रिय';
  @override
  String get staffInactive => 'निष्क्रिय';
  @override
  String get staffSearchHint => 'नाव किंवा फोन शोधा…';
  @override
  String get staffAddNew => 'कर्मचारी जोडा';
  @override
  String get staffName => 'पूर्ण नाव';
  @override
  String get staffPhone => 'फोन';
  @override
  String get staffRole => 'भूमिका';
  @override
  String get staffJoined => 'रुजू';

  @override
  String get settingsShopProfile => 'दुकानाची माहिती';
  @override
  String get settingsShopName => 'दुकानाचे नाव';
  @override
  String get settingsAddress => 'पत्ता';
  @override
  String get settingsGstNumber => 'GST नंबर';
  @override
  String get settingsPanNumber => 'PAN नंबर';
  @override
  String get settingsTodaysRates => 'आजचे भाव';
  @override
  String get settingsGold24k => 'सोने (24K)';
  @override
  String get settingsGold22k => 'सोने (22K)';
  @override
  String get settingsSilver => 'चांदी';
  @override
  String get settingsInterestRates => 'व्याजदर';
  @override
  String get settingsGirviInterest => 'गिर्‍वी व्याज (मासिक)';
  @override
  String get settingsPenalInterest => 'दंड व्याज';
  @override
  String get settingsLanguage => 'भाषा';
  @override
  String get settingsNotifications => 'सूचना';
  @override
  String get settingsDueReminders => 'देय तारीख स्मरणपत्र';
  @override
  String get settingsPaymentAlerts => 'पेमेंट सूचना';
  @override
  String get settingsExpiryAlerts => 'कालबाह्य सूचना';
  @override
  String get settingsSecurity => 'सुरक्षा';
  @override
  String get settingsBiometricLock => 'बायोमेट्रिक लॉक';
  @override
  String get settingsChangePIN => 'पिन बदला';
  @override
  String get settingsAbout => 'अॅपबद्दल';
  @override
  String get settingsVersion => 'आवृत्ती';
  @override
  String get settingsDeveloper => 'डेव्हलपर';
  @override
  String get settingsPrivacyPolicy => 'गोपनीयता धोरण';
  @override
  String get settingsContactSupport => 'सहाय्य';
}

// ─── Hindi ──────────────────────────────────────────────────────────────────

class _HiStrings extends AppL10n {
  const _HiStrings();

  @override
  String get navDashboard => 'डैशबोर्ड';
  @override
  String get navGirvi => 'गिरवी';
  @override
  String get navCustomers => 'ग्राहक';
  @override
  String get navMore => 'और';

  @override
  String get titleDashboard => 'डैशबोर्ड';
  @override
  String get titleGirvi => 'गिरवी';
  @override
  String get titleCustomers => 'ग्राहक';
  @override
  String get titleStaff => 'कर्मचारी';
  @override
  String get titleSettings => 'सेटिंग्स';
  @override
  String get titleMore => 'और अधिक';

  @override
  String get btnSave => 'सहेजें';
  @override
  String get btnCancel => 'रद्द करें';
  @override
  String get btnAdd => 'जोड़ें';
  @override
  String get btnEdit => 'संपादित करें';
  @override
  String get btnDelete => 'हटाएं';
  @override
  String get btnSearch => 'खोजें';
  @override
  String get btnClose => 'बंद करें';
  @override
  String get btnLogout => 'लॉग आउट';

  @override
  String get statusActive => 'सक्रिय';
  @override
  String get statusInactive => 'निष्क्रिय';
  @override
  String get statusDue => 'बकाया';
  @override
  String get statusOverdue => 'अतिदेय';
  @override
  String get statusPaid => 'भुगतान किया';

  @override
  String get perGram => 'प्रति ग्राम';
  @override
  String get perMonth => 'प्रति माह';

  @override
  String get langEnglish => 'अंग्रेज़ी';
  @override
  String get langMarathi => 'मराठी';
  @override
  String get langHindi => 'हिंदी';

  @override
  String get dashTotal => 'कुल';
  @override
  String get dashActive => 'सक्रिय';
  @override
  String get dashTodayDue => 'आज का बकाया';
  @override
  String get dashCustomers => 'ग्राहक';

  @override
  String get staffTotal => 'कुल';
  @override
  String get staffActive => 'सक्रिय';
  @override
  String get staffInactive => 'निष्क्रिय';
  @override
  String get staffSearchHint => 'नाम या फोन खोजें…';
  @override
  String get staffAddNew => 'कर्मचारी जोड़ें';
  @override
  String get staffName => 'पूरा नाम';
  @override
  String get staffPhone => 'फोन';
  @override
  String get staffRole => 'भूमिका';
  @override
  String get staffJoined => 'जुड़े';

  @override
  String get settingsShopProfile => 'दुकान की जानकारी';
  @override
  String get settingsShopName => 'दुकान का नाम';
  @override
  String get settingsAddress => 'पता';
  @override
  String get settingsGstNumber => 'GST नंबर';
  @override
  String get settingsPanNumber => 'PAN नंबर';
  @override
  String get settingsTodaysRates => 'आज के भाव';
  @override
  String get settingsGold24k => 'सोना (24K)';
  @override
  String get settingsGold22k => 'सोना (22K)';
  @override
  String get settingsSilver => 'चांदी';
  @override
  String get settingsInterestRates => 'ब्याज दर';
  @override
  String get settingsGirviInterest => 'गिरवी ब्याज (मासिक)';
  @override
  String get settingsPenalInterest => 'दंड ब्याज';
  @override
  String get settingsLanguage => 'भाषा';
  @override
  String get settingsNotifications => 'सूचनाएं';
  @override
  String get settingsDueReminders => 'देय तिथि अनुस्मारक';
  @override
  String get settingsPaymentAlerts => 'भुगतान अलर्ट';
  @override
  String get settingsExpiryAlerts => 'समाप्ति अलर्ट';
  @override
  String get settingsSecurity => 'सुरक्षा';
  @override
  String get settingsBiometricLock => 'बायोमेट्रिक लॉक';
  @override
  String get settingsChangePIN => 'PIN बदलें';
  @override
  String get settingsAbout => 'ऐप के बारे में';
  @override
  String get settingsVersion => 'संस्करण';
  @override
  String get settingsDeveloper => 'डेवलपर';
  @override
  String get settingsPrivacyPolicy => 'गोपनीयता नीति';
  @override
  String get settingsContactSupport => 'सहायता';
}
