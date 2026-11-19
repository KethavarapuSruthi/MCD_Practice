import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/registration_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/registration',
      builder: (context, state) => RegistrationScreen()
    )
  ]
);