// Domain
export 'domain/entities/sale_order.dart';
export 'domain/entities/sales_dashboard_stats.dart';
export 'domain/repositories/sales_repository.dart';

// Data
export 'data/models/sale_order_model.dart';
export 'data/models/sales_dashboard_stats_model.dart';
export 'data/repositories/sales_repository_impl.dart';

// BLoC — export only the bloc files (event/state files are `part of`)
export 'presentation/bloc/sales_dashboard_bloc.dart';
export 'presentation/bloc/sales_ledger_bloc.dart';
export 'presentation/bloc/new_sale_bloc.dart';
export 'presentation/bloc/sales_return_bloc.dart';
export 'presentation/bloc/barcode_sale_bloc.dart';

// Pages & Theme
export 'pages/sales_dashboard_page.dart';
export 'pages/sales_ledger_page.dart';
export 'pages/new_sale_page.dart';
export 'pages/invoice_preview_page.dart';
export 'pages/sales_details_page.dart';
export 'pages/sales_return_page.dart';
export 'pages/barcode_sale_page.dart';
export 'theme/sales_colors.dart';
