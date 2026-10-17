import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/app/app_providers.dart';
import 'package:pulse/app/app_shell.dart';
import 'package:pulse/features/accounts/accounts_screen.dart';
import 'package:pulse/features/budgets/budgets_screen.dart';
import 'package:pulse/features/categories/categories_screen.dart';
import 'package:pulse/features/home/home_screen.dart';
import 'package:pulse/features/insights/insights_screen.dart';
import 'package:pulse/features/onboarding/onboarding_screen.dart';
import 'package:pulse/features/recurring/recurring_screen.dart';
import 'package:pulse/features/settings/settings_screen.dart';
import 'package:pulse/features/transactions/add_transaction_screen.dart';
import 'package:pulse/features/transactions/edit_transaction_screen.dart';
import 'package:pulse/features/transactions/transactions_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

abstract final class Routes {
  static const home = '/home';
  static const insights = '/insights';
  static const budgets = '/budgets';
  static const add = '/add';
  static const transactions = '/transactions';
  static const accounts = '/accounts';
  static const categories = '/categories';
  static const recurring = '/recurring';
  static const settings = '/settings';
  static const onboarding = '/onboarding';

  static String editTransaction(String id) => '$transactions/$id';

  /// Opens "Νέα κίνηση" directly in transfer mode.
  static const addTransfer = '$add?mode=transfer';
}

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final onboarded = ValueNotifier<bool>(ref.read(onboardingDoneProvider));
  ref
    ..listen(onboardingDoneProvider, (_, next) => onboarded.value = next)
    ..onDispose(onboarded.dispose);

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.home,
    refreshListenable: onboarded,
    redirect: (context, state) {
      final atOnboarding = state.matchedLocation == Routes.onboarding;
      if (!onboarded.value && !atOnboarding) return Routes.onboarding;
      if (onboarded.value && atOnboarding) return Routes.home;
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.insights, builder: (_, _) => const InsightsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.budgets, builder: (_, _) => const BudgetsScreen())],
          ),
        ],
      ),
      GoRoute(
        path: Routes.add,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => MaterialPage(
          fullscreenDialog: true,
          child: AddTransactionScreen(
            transfer: state.uri.queryParameters['mode'] == 'transfer',
          ),
        ),
      ),
      GoRoute(
        path: Routes.transactions,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const TransactionsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            parentNavigatorKey: rootNavigatorKey,
            builder: (_, state) => EditTransactionScreen(id: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: Routes.accounts,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const AccountsScreen(),
      ),
      GoRoute(
        path: Routes.categories,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const CategoriesScreen(),
      ),
      GoRoute(
        path: Routes.recurring,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const RecurringScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.onboarding,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, _) => const OnboardingScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
