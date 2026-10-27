import 'package:go_router/go_router.dart';

import '../features/caller/presentation/caller_screen.dart';
import '../features/claims/presentation/claims_screen.dart';
import '../features/shell/presentation/home_shell.dart';
import '../features/tickets/presentation/tickets_screen.dart';

abstract final class Routes {
  static const String caller = '/';
  static const String tickets = '/tickets';
  static const String claims = '/claims';
}

GoRouter buildRouter() => GoRouter(
  initialLocation: Routes.caller,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => HomeShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.caller,
              builder: (context, state) => const CallerScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.tickets,
              builder: (context, state) => const TicketsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.claims,
              builder: (context, state) => const ClaimsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
