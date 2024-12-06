import 'package:get_it/get_it.dart';
import 'package:todo/core/services/api_service.dart';
import 'package:todo/core/services/database.dart';
import 'package:todo/features/home/bloc/home_bloc.dart';
import 'package:todo/features/home/repository/home_repository.dart';

import 'core/router/router.dart';

GetIt sl = GetIt.instance;
void setup() {
  // Register ApiService as a singleton
  sl.registerSingleton<ApiService>(ApiService());

  // Register AppRouter as a singleton
  sl.registerSingleton<AppRouter>(AppRouter());

  // Register HomeBloc as a factory (creates a new instance each time)
  sl.registerFactory(() => HomeBloc());

  // Register HomeRepository as a singleton with ApiService dependency
  sl.registerSingleton<HomeRepository>(HomeRepository(apiService: sl()));

  // Register Database as a singleton
  sl.registerSingleton<Database>(Database());
}
