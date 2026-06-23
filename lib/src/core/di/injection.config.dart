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
  gh.lazySingleton<_i812.GirviRepository>(
    () => _i731.GirviRepositoryImpl(apiClient: gh<_i277.ApiClient>()),
  );
  gh.factory<_i876.GirviListBloc>(
    () => _i876.GirviListBloc(repository: gh<_i812.GirviRepository>()),
  );
  gh.factory<_i943.GirviDetailBloc>(
    () => _i943.GirviDetailBloc(repository: gh<_i812.GirviRepository>()),
  );
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
