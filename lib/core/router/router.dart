import 'package:go_router/go_router.dart';
import 'package:todo/features/home/UI/home_page.dart';

// AppRouter class to define and manage app routing
class AppRouter {
  AppRouter();

  // Method to configure and return the GoRouter instance
  GoRouter getRouter() {
    GoRouter router = GoRouter(
      routes: [
        //home route
        GoRoute(
          path: '/',
          name: 'Home',
          builder: (context, state) => HomePage(),
        ),
      ],
    );
    return router;
  }
}
