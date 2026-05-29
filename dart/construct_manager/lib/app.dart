import 'package:go_router/go_router.dart';
import 'presentation/auth/login_screen.dart';
import 'presentation/auth/signup_screen.dart';
import 'presentation/auth/update_email_screen.dart';
import 'presentation/auth/update_password_screen.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/settings/settings_screen.dart';
import 'presentation/constructions/construction_list_screen.dart';
import 'presentation/constructions/construction_form_screen.dart';
import 'presentation/construction_view/construction_view_screen.dart';
import 'presentation/info/info_edit_screen.dart';
import 'presentation/budget/budget_list_screen.dart';
import 'presentation/budget/budget_form_screen.dart';
import 'presentation/schedule/schedule_list_screen.dart';
import 'presentation/schedule/schedule_form_screen.dart';
import 'presentation/schedule/delay_form_screen.dart';
import 'presentation/responsibility/responsibility_list_screen.dart';
import 'presentation/responsibility/responsibility_form_screen.dart';
import 'presentation/photos/photo_form_screen.dart';
import 'presentation/photos/photo_list_screen.dart';
import 'presentation/map/map_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(path: '/update-email', builder: (context, state) => const UpdateEmailScreen()),
    GoRoute(path: '/update-password', builder: (context, state) => const UpdatePasswordScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(path: '/constructions', builder: (context, state) => const ConstructionListScreen()),
    GoRoute(path: '/constructions/new', builder: (context, state) => const ConstructionFormScreen()),
    GoRoute(
      path: '/constructions/:id',
      builder: (context, state) => ConstructionViewScreen(
        constructionUid: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/constructions/:id/info',
      builder: (context, state) => InfoEditScreen(
        constructionUid: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/constructions/:id/budgets',
      builder: (context, state) => BudgetListScreen(
        constructionUid: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/constructions/:id/budgets/new',
      builder: (context, state) => BudgetFormScreen(
        constructionUid: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/constructions/:id/schedules',
      builder: (context, state) => ScheduleListScreen(
        constructionUid: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/constructions/:id/schedules/new',
      builder: (context, state) => ScheduleFormScreen(
        constructionUid: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/constructions/:id/schedules/:scheduleId/delays/new',
      builder: (context, state) => DelayFormScreen(
        constructionUid: state.pathParameters['id']!,
        scheduleUid: state.pathParameters['scheduleId']!,
      ),
    ),
    GoRoute(
      path: '/constructions/:id/responsibilities',
      builder: (context, state) => ResponsibilityListScreen(
        constructionUid: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/constructions/:id/responsibilities/new',
      builder: (context, state) => ResponsibilityFormScreen(
        constructionUid: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/constructions/:id/photos',
      builder: (context, state) => PhotoListScreen(
        constructionUid: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/constructions/:id/photos/new',
      builder: (context, state) => PhotoFormScreen(
        constructionUid: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/constructions/:id/map',
      builder: (context, state) => MapScreen(
        constructionUid: state.pathParameters['id']!,
      ),
    ),
  ],
);
