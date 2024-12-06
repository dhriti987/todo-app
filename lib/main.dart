import 'package:flutter/material.dart';
import 'package:todo/core/router/router.dart';
import 'package:todo/service_locater.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set up dependency injection
  setup();

  // Wait for all services to be ready before launching the app
  sl.allReady().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Set up router configuration
      routerConfig: sl.get<AppRouter>().getRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}
