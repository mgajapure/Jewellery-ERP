// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i301;
import '../../features/auth/domain/repositories/auth_repository.dart'
    as _i302;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i303;
import '../../features/auth/presentation/bloc/mobile_bloc.dart' as _i304;
import '../../features/auth/presentation/bloc/otp_bloc.dart' as _i305;
import '../../features/customer/data/repositories/customer_repository_impl.dart'
    as _i101;
import '../../features/customer/domain/repositories/customer_repository.dart'
    as _i102;
import '../../features/customer/presentation/bloc/customer_detail_bloc.dart'
    as _i103;
import '../../features/customer/presentation/bloc/customer_list_bloc.dart'
    as _i104;
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i201;
import '../../features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i202;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i203;
import '../../features/girvi/data/repositories/girvi_repository_impl.dart'
    as _i731;
import '../../features/girvi/domain/repositories/girvi_repository.dart'
    as _i812;
import '../../features/girvi/presentation/bloc/girvi_detail_bloc.dart'
    as _i943;
import '../../features/girvi/presentation/bloc/girvi_list_bloc.dart' as _i876;
import '../api/api_client.dart' as _i277;
import '../storage/prefs_storage.dart' as _i223;
import '../storage/secure_storage.dart' as _i619;
import 'register_module.dart' as _i291;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.prefs,
    preResolve: true,
  );
  gh.singleton<_i558.FlutterSecureStorage>(() => registerModule.secureStorage);
  gh.lazySingleton<_i223.PrefsStorage>(
    () => _i223.PrefsStorage(prefs: gh<_i460.SharedPreferences>()),
  );
  gh.lazySingleton<_i619.SecureStorage>(
    () => _i619.SecureStorage(storage: gh<_i558.FlutterSecureStorage>()),
  );
  gh.lazySingleton<_i277.ApiClient>(
    () => _i277.ApiClient(secureStorage: gh<_i619.SecureStorage>()),
  );
  // Auth
  gh.lazySingleton<_i302.AuthRepository>(
    () => _i301.AuthRepositoryImpl(
      apiClient: gh<_i277.ApiClient>(),
      secureStorage: gh<_i619.SecureStorage>(),
    ),
  );
  gh.lazySingleton<_i303.AuthBloc>(
    () => _i303.AuthBloc(repository: gh<_i302.AuthRepository>()),
  );
  gh.factory<_i304.MobileBloc>(
    () => _i304.MobileBloc(repository: gh<_i302.AuthRepository>()),
  );
  gh.factory<_i305.OtpBloc>(
    () => _i305.OtpBloc(repository: gh<_i302.AuthRepository>()),
  );
  // Girvi
  gh.lazySingleton<_i812.GirviRepository>(
    () => _i731.GirviRepositoryImpl(apiClient: gh<_i277.ApiClient>()),
  );
  gh.factory<_i876.GirviListBloc>(
    () => _i876.GirviListBloc(repository: gh<_i812.GirviRepository>()),
  );
  gh.factory<_i943.GirviDetailBloc>(
    () => _i943.GirviDetailBloc(repository: gh<_i812.GirviRepository>()),
  );
  // Customer
  gh.lazySingleton<_i102.CustomerRepository>(
    () => _i101.CustomerRepositoryImpl(apiClient: gh<_i277.ApiClient>()),
  );
  gh.factory<_i104.CustomerListBloc>(
    () => _i104.CustomerListBloc(repository: gh<_i102.CustomerRepository>()),
  );
  gh.factory<_i103.CustomerDetailBloc>(
    () =>
        _i103.CustomerDetailBloc(repository: gh<_i102.CustomerRepository>()),
  );
  // Dashboard
  gh.lazySingleton<_i202.DashboardRepository>(
    () => _i201.DashboardRepositoryImpl(apiClient: gh<_i277.ApiClient>()),
  );
  gh.factory<_i203.DashboardBloc>(
    () => _i203.DashboardBloc(repository: gh<_i202.DashboardRepository>()),
  );
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
