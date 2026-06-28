/// Central registry of all API endpoint paths.
///
/// Base URL is configured in [ApiClient] as `https://host/api/v1`.
/// All paths here are relative to that base and must NOT include `/api/v1`.
class ApiEndpoints {
  ApiEndpoints._();

  // ── Auth ──────────────────────────────────────────────────────────────
  static const String sendOtp = '/auth/otp/send';
  static const String verifyOtp = '/auth/otp/verify';
  static const String refreshToken = '/auth/token/refresh';
  static const String setPIN = '/auth/pin/set';
  static const String verifyPIN = '/auth/pin/verify';
  static const String logout = '/auth/logout';
  static const String pendingDevices = '/auth/devices/pending';
  static const String approveDevice = '/auth/devices/approve';

  // ── Customers ─────────────────────────────────────────────────────────
  static const String customers = '/customers';
  static String customerById(String id) => '/customers/$id';
  static String customerByQr(String qrCode) => '/customers/qr/$qrCode';
  static String customerKyc(String id, String status) =>
      '/customers/$id/kyc/$status';

  // ── Girvi (Gold Loans) ────────────────────────────────────────────────
  static const String girvi = '/girvi';
  static String girviById(String id) => '/girvi/$id';
  static const String girviOverdue = '/girvi/overdue';
  static String girviInterest(String id) => '/girvi/$id/interest';
  static String girviPayment(String id) => '/girvi/$id/payment';
  static String girviRenew(String id) => '/girvi/$id/renew';
  static String girviRedeem(String id) => '/girvi/$id/redeem';
  static String girviDisburse(String id) => '/girvi/$id/disburse';
  static String girviKfsGenerate(String id) => '/girvi/$id/kfs/generate';
  static String girviKfsDownload(String id) => '/girvi/$id/kfs/download';
  static const String girviKfsAcknowledge = '/girvi/kfs/acknowledge';
  static String girviPaymentReceipt(String paymentId) =>
      '/girvi/payments/$paymentId/receipt';
  static String girviValuationCert(String id) =>
      '/girvi/$id/valuation-certificate';

  // ── Inventory ─────────────────────────────────────────────────────────
  static const String inventoryCategories = '/inventory/categories';
  static const String inventory = '/inventory';
  static String inventoryById(String id) => '/inventory/$id';
  static String inventoryBySku(String sku) => '/inventory/sku/$sku';
  static const String inventoryLowStock = '/inventory/low-stock';
  static String inventoryAdjustStock(String id) =>
      '/inventory/$id/adjust-stock';
  static const String inventoryRevalue = '/inventory/revalue';

  // ── Sales ─────────────────────────────────────────────────────────────
  static const String sales = '/sales';
  static String saleById(String id) => '/sales/$id';
  static const String salesGstr1 = '/sales/gstr1';
  static const String salesGstr3b = '/sales/gstr3b';

  // ── Purchase & Vendors ────────────────────────────────────────────────
  static const String purchaseVendors = '/purchase/vendors';
  static String purchaseVendorById(String id) => '/purchase/vendors/$id';
  static const String purchaseOrders = '/purchase/orders';
  static String purchaseOrderById(String id) => '/purchase/orders/$id';
  static String purchaseOrderApprove(String id) =>
      '/purchase/orders/$id/approve';
  static const String purchaseGrn = '/purchase/grn';
  static String purchaseGrnByPo(String poId) =>
      '/purchase/orders/$poId/grn';

  // ── Compliance ────────────────────────────────────────────────────────
  static const String complianceForm6 = '/compliance/form6';
  static const String complianceForm9 = '/compliance/form9';
  static const String complianceForm11 = '/compliance/form11';
  static const String complianceForm12 = '/compliance/form12';
  static const String complianceForm13 = '/compliance/form13';
  static const String complianceSection25Notice =
      '/compliance/section25/notice';
  static const String complianceSection25Statement =
      '/compliance/section25/statement';

  // ── Gold Rates ────────────────────────────────────────────────────────
  static const String goldRateCurrent = '/gold-rates/current';
  static const String goldRateHistory = '/gold-rates/history';
  static const String goldRateManual = '/gold-rates/manual';
  static const String goldRateCheckThresholds = '/gold-rates/check-thresholds';

  // ── Barcode ───────────────────────────────────────────────────────────
  static const String barcodeGenerate = '/barcode/generate';
  static String barcodeLookup(String sku) => '/barcode/lookup/$sku';
  static const String barcodeHistory = '/barcode/history';

  // ── Branches ─────────────────────────────────────────────────────────
  static const String branches = '/branches';
  static String branchById(String id) => '/branches/$id';
  static const String branchesConsolidatedPL = '/branches/consolidated-pl';
  static const String branchesTransfer = '/branches/transfer';

  // ── Staff ─────────────────────────────────────────────────────────────
  static const String staff = '/staff';
  static String staffById(String id) => '/staff/$id';
  static const String staffPendingDevices = '/staff/devices/pending';
  static String staffApproveDevice(String deviceId) =>
      '/staff/devices/$deviceId/approve';

  // ── Dashboard ─────────────────────────────────────────────────────────
  static const String dashboardSummary = '/dashboard/summary';
  static const String dashboardSalesTrend = '/dashboard/sales-trend';
  static const String dashboardGirviPortfolio = '/dashboard/girvi-portfolio';
  static const String dashboardTopKarigars = '/dashboard/top-karigars';

  // ── Reports ───────────────────────────────────────────────────────────
  static const String reportsGirvi = '/reports/girvi';
  static const String reportsSales = '/reports/sales';
  static const String reportsKarigar = '/reports/karigar';
  static const String reportsStockValuation = '/reports/stock-valuation';
  static const String reportsGstr1 = '/reports/gstr1';

  // ── Notifications ─────────────────────────────────────────────────────
  static const String notificationsSend = '/notifications/send';
  static const String notificationsSendBulk = '/notifications/send-bulk';
  static const String notificationsHistory = '/notifications/history';

  // ── WhatsApp ──────────────────────────────────────────────────────────
  static const String whatsappSend = '/whatsapp/send';
  static String whatsappGirviBalance(String customerId) =>
      '/whatsapp/girvi-balance/$customerId';
  static const String whatsappWebhook = '/whatsapp/webhook';
  static const String whatsappMessages = '/whatsapp/messages';

  // ── Karigar ───────────────────────────────────────────────────────────
  static const String karigar = '/karigar';
  static String karigarById(String id) => '/karigar/$id';
  static String karigarLedger(String id) => '/karigar/$id/ledger';
  static const String karigarJobsList = '/karigar/jobs/list';
  static String karigarJobById(String id) => '/karigar/jobs/$id';
  static const String karigarJobs = '/karigar/jobs';
  static String karigarIssueMaterial(String id) =>
      '/karigar/jobs/$id/issue-material';
  static String karigarReceiveMaterial(String id) =>
      '/karigar/jobs/$id/receive-material';
  static String karigarCompleteJob(String id) => '/karigar/jobs/$id/complete';
  static String karigarJobPayment(String id) => '/karigar/jobs/$id/payments';

  // ── Savings Schemes ───────────────────────────────────────────────────
  static const String savings = '/savings';
  static const String savingsDefaulters = '/savings/defaulters';
  static String savingsById(String id) => '/savings/$id';
  static String savingsStatement(String id) => '/savings/$id/statement';
  static String savingsCollections(String id) => '/savings/$id/collections';

  // ── Repairs ───────────────────────────────────────────────────────────
  static const String repairs = '/repairs';
  static const String repairAnalytics = '/repairs/analytics';
  static String repairById(String id) => '/repairs/$id';
  static String repairStatus(String id) => '/repairs/$id/status';

  // ── Custom Orders ─────────────────────────────────────────────────────
  static const String customOrders = '/custom-orders';
  static const String customOrdersDelayed = '/custom-orders/delayed';
  static String customOrderById(String id) => '/custom-orders/$id';
  static String customOrderProfit(String id) => '/custom-orders/$id/profit';
  static String customOrderPayment(String id) =>
      '/custom-orders/$id/payments';

  // ── Diamond & Gemstones ───────────────────────────────────────────────
  static const String diamondCertificates = '/diamond/certificates';
  static String diamondCertificateLookup(String certNo) =>
      '/diamond/certificates/lookup/$certNo';
  static String diamondCertificateById(String id) =>
      '/diamond/certificates/$id';
  static String diamondValuation(String id) =>
      '/diamond/certificates/$id/valuation';

  // ── Expenses ─────────────────────────────────────────────────────────
  static const String expenseCategories = '/expenses/categories';
  static const String expenses = '/expenses';
  static const String expensesSummary = '/expenses/summary';
  static String expenseById(String id) => '/expenses/$id';
  static String expenseApprove(String id) => '/expenses/$id/approve';
  static String expenseReject(String id) => '/expenses/$id/reject';

  // ── GST Filing ────────────────────────────────────────────────────────
  static const String gstReturns = '/gst-filing/returns';
  static const String gstItcSummary = '/gst-filing/itc-summary';
  static String gstReturnById(String id) => '/gst-filing/returns/$id';
  static String gstFileReturn(String id) => '/gst-filing/returns/$id/file';

  // ── Payroll ───────────────────────────────────────────────────────────
  static const String payroll = '/payroll';
  static const String payrollSummary = '/payroll/summary';
  static String payrollById(String id) => '/payroll/$id';
  static String payrollApprove(String id) => '/payroll/$id/approve';
  static String payrollPaid(String id) => '/payroll/$id/paid';

  // ── Old Gold ──────────────────────────────────────────────────────────
  static const String oldGoldPurchases = '/old-gold/purchases';
  static const String oldGoldReport = '/old-gold/purchases/report';
  static String oldGoldById(String id) => '/old-gold/purchases/$id';
  static String oldGoldPurityTest(String id) =>
      '/old-gold/purchases/$id/purity-test';
  static String oldGoldMelt(String id) => '/old-gold/purchases/$id/melt';
  static String oldGoldSettle(String id) => '/old-gold/purchases/$id/settle';
  static String oldGoldReturn(String id) => '/old-gold/purchases/$id/return';

  // ── Loyalty ───────────────────────────────────────────────────────────
  static const String loyaltyAccounts = '/loyalty/accounts';
  static const String loyaltyTiers = '/loyalty/tiers';
  static String loyaltyByCustomer(String customerId) =>
      '/loyalty/accounts/$customerId';
  static String loyaltyTransactions(String customerId) =>
      '/loyalty/accounts/$customerId/transactions';
  static String loyaltyPoints(String customerId) =>
      '/loyalty/accounts/$customerId/points';

  // ── Franchise ─────────────────────────────────────────────────────────
  static const String franchisees = '/franchise/franchisees';
  static const String franchiseDashboard = '/franchise/dashboard';
  static String franchiseeById(String id) => '/franchise/franchisees/$id';
  static String franchiseeSuspend(String id) =>
      '/franchise/franchisees/$id/suspend';
  static String franchiseeRoyalties(String id) =>
      '/franchise/franchisees/$id/royalties';
  static String franchiseRoyaltyPaid(String royaltyId) =>
      '/franchise/royalties/$royaltyId/paid';

  // ── Helpdesk ─────────────────────────────────────────────────────────
  static const String helpdeskTickets = '/helpdesk/tickets';
  static const String helpdeskAnalytics = '/helpdesk/tickets/analytics';
  static String helpdeskTicketById(String id) => '/helpdesk/tickets/$id';
  static String helpdeskTicketComments(String id) =>
      '/helpdesk/tickets/$id/comments';
  static String helpdeskEscalate(String id) =>
      '/helpdesk/tickets/$id/escalate';
  static String helpdeskResolve(String id) => '/helpdesk/tickets/$id/resolve';
  static String helpdeskClose(String id) => '/helpdesk/tickets/$id/close';

  // ── Data Import / Export ──────────────────────────────────────────────
  static const String dataImportModules = '/data-import/modules';
  static const String dataImportJobs = '/data-import/jobs';
  static String dataImportJobById(String id) => '/data-import/jobs/$id';
  static String dataImportJobRetry(String id) =>
      '/data-import/jobs/$id/retry';
  static const String dataExport = '/data-import/export';

  // ── Sync (Offline) ────────────────────────────────────────────────────
  static const String syncPush = '/sync/push';
  static const String syncQueue = '/sync/queue';
  static const String syncStatus = '/sync/status';

  // ── Search ────────────────────────────────────────────────────────────
  static const String searchGlobal = '/search/global';
  static const String searchCustomers = '/search/customers';
  static const String searchQr = '/search/qr';

  // ── Settings ──────────────────────────────────────────────────────────
  static const String settingsProfile = '/settings/profile';
  static const String settings = '/settings';
  static const String settingsInterest = '/settings/interest';

  // ── Vault (managed internally by Girvi lifecycle in backend) ──────────
  static const String vaults = '/vaults';
  static const String vaultList = '/vaults/list';
  static const String vaultAssign = '/vaults/assign';
  static const String vaultSearch = '/vaults/search';
  static String vaultSafes(String vault) => '/vaults/$vault/safes';
  static String vaultTrays(String vault, String safe) =>
      '/vaults/$vault/safes/$safe/trays';
  static String vaultSlots(String vault, String safe, String tray) =>
      '/vaults/$vault/safes/$safe/trays/$tray/slots';

  // ── Health ────────────────────────────────────────────────────────────
  static const String health = '/';
}
