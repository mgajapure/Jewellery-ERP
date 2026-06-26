// Domain
export 'domain/entities/purchase_entry.dart';
export 'domain/entities/purchase_dashboard_stats.dart';
export 'domain/entities/supplier.dart';
export 'domain/repositories/purchase_repository.dart';

// Data
export 'data/models/purchase_entry_model.dart';
export 'data/models/purchase_dashboard_stats_model.dart';
export 'data/models/supplier_model.dart';
export 'data/repositories/purchase_repository_impl.dart';

// BLoC — export only the bloc files (event/state files are `part of`)
export 'presentation/bloc/purchase_dashboard_bloc.dart';
export 'presentation/bloc/purchase_ledger_bloc.dart';
export 'presentation/bloc/new_purchase_bloc.dart';
export 'presentation/bloc/supplier_bloc.dart';

// Pages & Theme
export 'pages/purchase_dashboard_page.dart';
export 'pages/purchase_ledger_page.dart';
export 'pages/new_purchase_page.dart';
export 'pages/purchase_details_page.dart';
export 'pages/supplier_management_page.dart';
export 'theme/purchase_colors.dart';
