// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tambola Host';

  @override
  String get navCaller => 'Caller';

  @override
  String get navTickets => 'Tickets';

  @override
  String get navClaims => 'Claims';

  @override
  String get callerTitle => 'Caller';

  @override
  String get nextNumber => 'Next number';

  @override
  String get autoPlay => 'Auto-play';

  @override
  String get pause => 'Pause';

  @override
  String get undoLast => 'Undo last call';

  @override
  String get repeatCall => 'Say it again';

  @override
  String get newGame => 'New game';

  @override
  String get settings => 'Settings';

  @override
  String get waitingForFirstCall =>
      'Press “Next number” to make the first call';

  @override
  String callProgress(int count) {
    return 'Call $count of 90';
  }

  @override
  String get allCalled => 'All 90 numbers have been called';

  @override
  String get previousCalls => 'Previous calls';

  @override
  String get noPreviousCalls => 'None yet';

  @override
  String intervalLabel(int seconds) {
    return 'Every $seconds s';
  }

  @override
  String get intervalSemantics => 'Seconds between automatic calls';

  @override
  String get boardTitle => 'Board';

  @override
  String boardCellCalled(int number) {
    return '$number, called';
  }

  @override
  String boardCellNotCalled(int number) {
    return '$number, not called';
  }

  @override
  String currentNumberSemantics(int number) {
    return 'Current number $number';
  }

  @override
  String gameCodeLabel(String code) {
    return 'Game $code';
  }

  @override
  String get settingsVoice => 'Voice';

  @override
  String get voiceOff => 'Off';

  @override
  String get voiceEnglish => 'English';

  @override
  String get voiceHindi => 'हिन्दी';

  @override
  String get settingsRhymes => 'Rhyming calls';

  @override
  String get settingsRhymesHint =>
      'Show and say a short rhyme with each number';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'Auto';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsInterval => 'Auto-play speed';

  @override
  String get voiceNote =>
      'Voices come from your browser or phone. If Hindi sounds wrong, install a Hindi voice in your system settings.';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get start => 'Start';

  @override
  String get newGameTitle => 'Start a new game?';

  @override
  String newGameBody(String code) {
    return 'This clears the calls of game $code. Tickets come from the game code, so keep the same code to reuse tickets you already printed.';
  }

  @override
  String get ticketCountLabel => 'Number of tickets';

  @override
  String ticketCountError(int max) {
    return 'Enter a number from 1 to $max';
  }

  @override
  String get gameCodeFieldLabel => 'Game code (optional)';

  @override
  String get gameCodeFieldHint => 'Leave empty for new tickets';

  @override
  String get gameCodeError => 'Codes are 6 letters and digits, like K7QX2M';

  @override
  String get ticketsTitle => 'Tickets';

  @override
  String ticketsSummary(int count, String code) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tickets',
      one: '1 ticket',
    );
    return '$_temp0 for game $code';
  }

  @override
  String get ticketsExplainer =>
      'Every group of six tickets (1–6, 7–12, …) uses each number from 1 to 90 exactly once. Tickets are built from the game code, so the claim checker can rebuild any ticket from its number.';

  @override
  String get changeTicketCount => 'Change number of tickets';

  @override
  String get save => 'Save';

  @override
  String ticketHeading(int number) {
    return 'Ticket $number';
  }

  @override
  String ticketSemantics(int number, String code) {
    return 'Ticket $number, game $code';
  }

  @override
  String get ticketCellBlank => 'blank';

  @override
  String ticketCellMarked(int number) {
    return '$number, called';
  }

  @override
  String get claimsTitle => 'Check a claim';

  @override
  String get claimTicketLabel => 'Ticket number';

  @override
  String claimTicketHint(int max) {
    return '1 to $max';
  }

  @override
  String get claimPrizeLabel => 'Prize';

  @override
  String get prizeEarlyFive => 'Early Five';

  @override
  String get prizeTopLine => 'Top line';

  @override
  String get prizeMiddleLine => 'Middle line';

  @override
  String get prizeBottomLine => 'Bottom line';

  @override
  String get prizeCorners => 'Corners';

  @override
  String get prizeFullHouse => 'Full House';

  @override
  String get claimEnterTicket =>
      'Enter the ticket number the player is holding.';

  @override
  String get claimValid => 'Valid claim';

  @override
  String claimValidDetail(int call, int number) {
    return 'Completed on call $call with number $number.';
  }

  @override
  String claimLate(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'It was already complete $count calls ago.',
      one: 'It was already complete 1 call ago.',
    );
    return '$_temp0';
  }

  @override
  String get claimNotYet => 'Not yet';

  @override
  String claimMissing(String numbers) {
    return 'Still needs: $numbers';
  }

  @override
  String claimNeedsMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Needs $count more called numbers.',
      one: 'Needs 1 more called number.',
    );
    return '$_temp0';
  }

  @override
  String claimUnknownTicket(int number, int max) {
    return 'Ticket $number is not in this game. Tickets run from 1 to $max.';
  }

  @override
  String get claimLegend =>
      'Filled numbers have been called. Outlined numbers count for this prize.';
}
