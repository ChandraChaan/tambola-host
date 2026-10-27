import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tambola Host'**
  String get appTitle;

  /// No description provided for @navCaller.
  ///
  /// In en, this message translates to:
  /// **'Caller'**
  String get navCaller;

  /// No description provided for @navTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get navTickets;

  /// No description provided for @navClaims.
  ///
  /// In en, this message translates to:
  /// **'Claims'**
  String get navClaims;

  /// No description provided for @callerTitle.
  ///
  /// In en, this message translates to:
  /// **'Caller'**
  String get callerTitle;

  /// No description provided for @nextNumber.
  ///
  /// In en, this message translates to:
  /// **'Next number'**
  String get nextNumber;

  /// No description provided for @autoPlay.
  ///
  /// In en, this message translates to:
  /// **'Auto-play'**
  String get autoPlay;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @undoLast.
  ///
  /// In en, this message translates to:
  /// **'Undo last call'**
  String get undoLast;

  /// No description provided for @repeatCall.
  ///
  /// In en, this message translates to:
  /// **'Say it again'**
  String get repeatCall;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get newGame;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @waitingForFirstCall.
  ///
  /// In en, this message translates to:
  /// **'Press “Next number” to make the first call'**
  String get waitingForFirstCall;

  /// No description provided for @callProgress.
  ///
  /// In en, this message translates to:
  /// **'Call {count} of 90'**
  String callProgress(int count);

  /// No description provided for @allCalled.
  ///
  /// In en, this message translates to:
  /// **'All 90 numbers have been called'**
  String get allCalled;

  /// No description provided for @previousCalls.
  ///
  /// In en, this message translates to:
  /// **'Previous calls'**
  String get previousCalls;

  /// No description provided for @noPreviousCalls.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get noPreviousCalls;

  /// No description provided for @intervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Every {seconds} s'**
  String intervalLabel(int seconds);

  /// No description provided for @intervalSemantics.
  ///
  /// In en, this message translates to:
  /// **'Seconds between automatic calls'**
  String get intervalSemantics;

  /// No description provided for @boardTitle.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get boardTitle;

  /// No description provided for @boardCellCalled.
  ///
  /// In en, this message translates to:
  /// **'{number}, called'**
  String boardCellCalled(int number);

  /// No description provided for @boardCellNotCalled.
  ///
  /// In en, this message translates to:
  /// **'{number}, not called'**
  String boardCellNotCalled(int number);

  /// No description provided for @currentNumberSemantics.
  ///
  /// In en, this message translates to:
  /// **'Current number {number}'**
  String currentNumberSemantics(int number);

  /// No description provided for @gameCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Game {code}'**
  String gameCodeLabel(String code);

  /// No description provided for @settingsVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get settingsVoice;

  /// No description provided for @voiceOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get voiceOff;

  /// No description provided for @voiceEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get voiceEnglish;

  /// No description provided for @voiceHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get voiceHindi;

  /// No description provided for @settingsRhymes.
  ///
  /// In en, this message translates to:
  /// **'Rhyming calls'**
  String get settingsRhymes;

  /// No description provided for @settingsRhymesHint.
  ///
  /// In en, this message translates to:
  /// **'Show and say a short rhyme with each number'**
  String get settingsRhymesHint;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsInterval.
  ///
  /// In en, this message translates to:
  /// **'Auto-play speed'**
  String get settingsInterval;

  /// No description provided for @voiceNote.
  ///
  /// In en, this message translates to:
  /// **'Voices come from your browser or phone. If Hindi sounds wrong, install a Hindi voice in your system settings.'**
  String get voiceNote;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @newGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Start a new game?'**
  String get newGameTitle;

  /// No description provided for @newGameBody.
  ///
  /// In en, this message translates to:
  /// **'This clears the calls of game {code}. Tickets come from the game code, so keep the same code to reuse tickets you already printed.'**
  String newGameBody(String code);

  /// No description provided for @ticketCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of tickets'**
  String get ticketCountLabel;

  /// No description provided for @ticketCountError.
  ///
  /// In en, this message translates to:
  /// **'Enter a number from 1 to {max}'**
  String ticketCountError(int max);

  /// No description provided for @gameCodeFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Game code (optional)'**
  String get gameCodeFieldLabel;

  /// No description provided for @gameCodeFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for new tickets'**
  String get gameCodeFieldHint;

  /// No description provided for @gameCodeError.
  ///
  /// In en, this message translates to:
  /// **'Codes are 6 letters and digits, like K7QX2M'**
  String get gameCodeError;

  /// No description provided for @ticketsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get ticketsTitle;

  /// No description provided for @ticketsSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 ticket} other{{count} tickets}} for game {code}'**
  String ticketsSummary(int count, String code);

  /// No description provided for @ticketsExplainer.
  ///
  /// In en, this message translates to:
  /// **'Every group of six tickets (1–6, 7–12, …) uses each number from 1 to 90 exactly once. Tickets are built from the game code, so the claim checker can rebuild any ticket from its number.'**
  String get ticketsExplainer;

  /// No description provided for @changeTicketCount.
  ///
  /// In en, this message translates to:
  /// **'Change number of tickets'**
  String get changeTicketCount;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @ticketHeading.
  ///
  /// In en, this message translates to:
  /// **'Ticket {number}'**
  String ticketHeading(int number);

  /// No description provided for @ticketSemantics.
  ///
  /// In en, this message translates to:
  /// **'Ticket {number}, game {code}'**
  String ticketSemantics(int number, String code);

  /// No description provided for @ticketCellBlank.
  ///
  /// In en, this message translates to:
  /// **'blank'**
  String get ticketCellBlank;

  /// No description provided for @ticketCellMarked.
  ///
  /// In en, this message translates to:
  /// **'{number}, called'**
  String ticketCellMarked(int number);

  /// No description provided for @claimsTitle.
  ///
  /// In en, this message translates to:
  /// **'Check a claim'**
  String get claimsTitle;

  /// No description provided for @claimTicketLabel.
  ///
  /// In en, this message translates to:
  /// **'Ticket number'**
  String get claimTicketLabel;

  /// No description provided for @claimTicketHint.
  ///
  /// In en, this message translates to:
  /// **'1 to {max}'**
  String claimTicketHint(int max);

  /// No description provided for @claimPrizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Prize'**
  String get claimPrizeLabel;

  /// No description provided for @prizeEarlyFive.
  ///
  /// In en, this message translates to:
  /// **'Early Five'**
  String get prizeEarlyFive;

  /// No description provided for @prizeTopLine.
  ///
  /// In en, this message translates to:
  /// **'Top line'**
  String get prizeTopLine;

  /// No description provided for @prizeMiddleLine.
  ///
  /// In en, this message translates to:
  /// **'Middle line'**
  String get prizeMiddleLine;

  /// No description provided for @prizeBottomLine.
  ///
  /// In en, this message translates to:
  /// **'Bottom line'**
  String get prizeBottomLine;

  /// No description provided for @prizeCorners.
  ///
  /// In en, this message translates to:
  /// **'Corners'**
  String get prizeCorners;

  /// No description provided for @prizeFullHouse.
  ///
  /// In en, this message translates to:
  /// **'Full House'**
  String get prizeFullHouse;

  /// No description provided for @claimEnterTicket.
  ///
  /// In en, this message translates to:
  /// **'Enter the ticket number the player is holding.'**
  String get claimEnterTicket;

  /// No description provided for @claimValid.
  ///
  /// In en, this message translates to:
  /// **'Valid claim'**
  String get claimValid;

  /// No description provided for @claimValidDetail.
  ///
  /// In en, this message translates to:
  /// **'Completed on call {call} with number {number}.'**
  String claimValidDetail(int call, int number);

  /// No description provided for @claimLate.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{It was already complete 1 call ago.} other{It was already complete {count} calls ago.}}'**
  String claimLate(int count);

  /// No description provided for @claimNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get claimNotYet;

  /// No description provided for @claimMissing.
  ///
  /// In en, this message translates to:
  /// **'Still needs: {numbers}'**
  String claimMissing(String numbers);

  /// No description provided for @claimNeedsMore.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Needs 1 more called number.} other{Needs {count} more called numbers.}}'**
  String claimNeedsMore(int count);

  /// No description provided for @claimUnknownTicket.
  ///
  /// In en, this message translates to:
  /// **'Ticket {number} is not in this game. Tickets run from 1 to {max}.'**
  String claimUnknownTicket(int number, int max);

  /// No description provided for @claimLegend.
  ///
  /// In en, this message translates to:
  /// **'Filled numbers have been called. Outlined numbers count for this prize.'**
  String get claimLegend;

  /// No description provided for @printTickets.
  ///
  /// In en, this message translates to:
  /// **'Print tickets (PDF)'**
  String get printTickets;

  /// No description provided for @printFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the PDF. Please try again.'**
  String get printFailed;

  /// No description provided for @pdfTitle.
  ///
  /// In en, this message translates to:
  /// **'Tambola tickets, game {code}'**
  String pdfTitle(String code);

  /// No description provided for @pdfFooter.
  ///
  /// In en, this message translates to:
  /// **'Tickets {first} to {last}. Each full page of six tickets uses every number from 1 to 90 once.'**
  String pdfFooter(int first, int last);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
