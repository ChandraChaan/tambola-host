import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../game/domain/claims.dart';
import '../../game/presentation/game_controller.dart';
import '../../tickets/presentation/ticket_view.dart';
import 'claim_controller.dart';

String prizeLabel(AppLocalizations l10n, Prize prize) => switch (prize) {
  Prize.earlyFive => l10n.prizeEarlyFive,
  Prize.topLine => l10n.prizeTopLine,
  Prize.middleLine => l10n.prizeMiddleLine,
  Prize.bottomLine => l10n.prizeBottomLine,
  Prize.corners => l10n.prizeCorners,
  Prize.fullHouse => l10n.prizeFullHouse,
};

class ClaimsScreen extends ConsumerStatefulWidget {
  const ClaimsScreen({super.key});

  @override
  ConsumerState<ClaimsScreen> createState() => _ClaimsScreenState();
}

class _ClaimsScreenState extends ConsumerState<ClaimsScreen> {
  late final TextEditingController _ticket = TextEditingController(
    text: ref.read(claimQueryProvider).ticketNumber?.toString() ?? '',
  );

  @override
  void dispose() {
    _ticket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final ticketCount = ref.watch(gameProvider.select((g) => g.ticketCount));
    final prize = ref.watch(claimQueryProvider.select((q) => q.prize));
    final query = ref.read(claimQueryProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.claimsTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                key: const Key('claim-ticket'),
                controller: _ticket,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                style: text.headlineSmall,
                decoration: InputDecoration(
                  labelText: l10n.claimTicketLabel,
                  hintText: l10n.claimTicketHint(ticketCount),
                  prefixIcon: const Icon(Icons.confirmation_number_outlined),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => query.setTicket(int.tryParse(value)),
              ),
              const SizedBox(height: 16),
              Text(l10n.claimPrizeLabel, style: text.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final p in Prize.values)
                    ChoiceChip(
                      key: ValueKey('prize-${p.name}'),
                      label: Text(prizeLabel(l10n, p)),
                      selected: p == prize,
                      onSelected: (_) => query.setPrize(p),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const _ClaimOutcome(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClaimOutcome extends ConsumerWidget {
  const _ClaimOutcome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final check = ref.watch(claimCheckProvider);
    if (check == null) return Text(l10n.claimEnterTicket);

    final game = ref.watch(gameProvider);
    final prize = ref.watch(claimQueryProvider.select((q) => q.prize));
    final ticket = check.ticket;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Verdict(result: check.result, ticketCount: game.ticketCount),
        if (ticket != null) ...[
          const SizedBox(height: 12),
          TicketView(
            ticket: ticket,
            gameCode: game.code,
            marked: ticket.numbers.where(game.isCalled).toSet(),
            highlighted: ClaimRules.numbersFor(ticket, prize).toSet(),
          ),
          const SizedBox(height: 8),
          Text(l10n.claimLegend, style: Theme.of(context).textTheme.bodySmall),
        ],
      ],
    );
  }
}

class _Verdict extends ConsumerWidget {
  const _Verdict({required this.result, required this.ticketCount});

  final ClaimResult result;
  final int ticketCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final ticketNumber = ref.watch(
      claimQueryProvider.select((q) => q.ticketNumber),
    );

    final (icon, title, lines, background, foreground) = switch (result) {
      ClaimValid(
        :final completedOnCall,
        :final completingNumber,
        :final callsSince,
      ) =>
        (
          Icons.verified,
          l10n.claimValid,
          [
            l10n.claimValidDetail(completedOnCall, completingNumber),
            if (callsSince > 0) l10n.claimLate(callsSince),
          ],
          scheme.primaryContainer,
          scheme.onPrimaryContainer,
        ),
      ClaimNotYet(:final missing, :final stillNeeded) => (
        Icons.cancel_outlined,
        l10n.claimNotYet,
        [
          if (missing.length == stillNeeded)
            l10n.claimMissing(missing.join(', '))
          else
            l10n.claimNeedsMore(stillNeeded),
        ],
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
      ClaimUnknownTicket() => (
        Icons.help_outline,
        l10n.claimNotYet,
        [l10n.claimUnknownTicket(ticketNumber ?? 0, ticketCount)],
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
    };

    return Semantics(
      liveRegion: true,
      child: Card(
        key: Key('verdict-${result.runtimeType}'),
        color: background,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: foreground, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: text.titleLarge?.copyWith(color: foreground),
                    ),
                    for (final line in lines)
                      Text(
                        line,
                        style: text.bodyLarge?.copyWith(color: foreground),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
