import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/party/presentation/screens/create_party_screen.dart';
import '../../features/party/presentation/screens/join_party_screen.dart';
import '../../features/party/presentation/screens/party_lobby_screen.dart';
import '../../features/settings/presentation/about_screen.dart';
import '../../features/settings/presentation/contact_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/create-party',
      builder: (context, state) => const CreatePartyScreen(),
    ),

    GoRoute(
      path: '/join-party',
      builder: (context, state) => const JoinPartyScreen(),
    ),

    GoRoute(
      path: '/party/:roomCode',
      builder: (context, state) {
        final roomCode = state.pathParameters['roomCode']!;

        return PartyLobbyScreen(roomCode: roomCode);
      },
    ),

    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),

    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactScreen(),
    ),
  ],
);
