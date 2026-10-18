import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_el.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('el')];

  /// No description provided for @appTitle.
  ///
  /// In el, this message translates to:
  /// **'Pulse'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In el, this message translates to:
  /// **'Αρχική'**
  String get navHome;

  /// No description provided for @navInsights.
  ///
  /// In el, this message translates to:
  /// **'Αναλύσεις'**
  String get navInsights;

  /// No description provided for @navBudgets.
  ///
  /// In el, this message translates to:
  /// **'Budgets'**
  String get navBudgets;

  /// No description provided for @navAdd.
  ///
  /// In el, this message translates to:
  /// **'Νέα κίνηση'**
  String get navAdd;

  /// No description provided for @navMore.
  ///
  /// In el, this message translates to:
  /// **'Περισσότερα'**
  String get navMore;

  /// No description provided for @mainNavigation.
  ///
  /// In el, this message translates to:
  /// **'Κύρια πλοήγηση'**
  String get mainNavigation;

  /// No description provided for @themeToLight.
  ///
  /// In el, this message translates to:
  /// **'Φωτεινό θέμα'**
  String get themeToLight;

  /// No description provided for @themeToDark.
  ///
  /// In el, this message translates to:
  /// **'Σκοτεινό θέμα'**
  String get themeToDark;

  /// No description provided for @actionBack.
  ///
  /// In el, this message translates to:
  /// **'Πίσω'**
  String get actionBack;

  /// No description provided for @actionClose.
  ///
  /// In el, this message translates to:
  /// **'Κλείσιμο'**
  String get actionClose;

  /// No description provided for @actionCancel.
  ///
  /// In el, this message translates to:
  /// **'Ακύρωση'**
  String get actionCancel;

  /// No description provided for @actionSave.
  ///
  /// In el, this message translates to:
  /// **'Αποθήκευση'**
  String get actionSave;

  /// No description provided for @actionDelete.
  ///
  /// In el, this message translates to:
  /// **'Διαγραφή'**
  String get actionDelete;

  /// No description provided for @actionEditShort.
  ///
  /// In el, this message translates to:
  /// **'Επεξ.'**
  String get actionEditShort;

  /// No description provided for @actionUndo.
  ///
  /// In el, this message translates to:
  /// **'Αναίρεση'**
  String get actionUndo;

  /// No description provided for @actionContinue.
  ///
  /// In el, this message translates to:
  /// **'Συνέχεια'**
  String get actionContinue;

  /// No description provided for @actionStart.
  ///
  /// In el, this message translates to:
  /// **'Ξεκίνα'**
  String get actionStart;

  /// No description provided for @actionSkip.
  ///
  /// In el, this message translates to:
  /// **'Παράλειψη'**
  String get actionSkip;

  /// No description provided for @actionDone.
  ///
  /// In el, this message translates to:
  /// **'Τέλος'**
  String get actionDone;

  /// No description provided for @actionArchive.
  ///
  /// In el, this message translates to:
  /// **'Αρχειοθέτηση'**
  String get actionArchive;

  /// No description provided for @actionRetry.
  ///
  /// In el, this message translates to:
  /// **'Δοκίμασε ξανά'**
  String get actionRetry;

  /// No description provided for @errorTitle.
  ///
  /// In el, this message translates to:
  /// **'Κάτι πήγε στραβά'**
  String get errorTitle;

  /// No description provided for @errorBody.
  ///
  /// In el, this message translates to:
  /// **'Δοκίμασε ξανά. Αν το πρόβλημα επιμένει, επανεκκίνησε την εφαρμογή.'**
  String get errorBody;

  /// No description provided for @deletedToast.
  ///
  /// In el, this message translates to:
  /// **'Διαγράφηκε: {name}'**
  String deletedToast(String name);

  /// No description provided for @dayToday.
  ///
  /// In el, this message translates to:
  /// **'Σήμερα'**
  String get dayToday;

  /// No description provided for @dayYesterday.
  ///
  /// In el, this message translates to:
  /// **'Χθες'**
  String get dayYesterday;

  /// No description provided for @dayTomorrow.
  ///
  /// In el, this message translates to:
  /// **'Αύριο'**
  String get dayTomorrow;

  /// No description provided for @daysLeft.
  ///
  /// In el, this message translates to:
  /// **'{count, plural, =1{1 μέρα ακόμα} other{{count} μέρες ακόμα}}'**
  String daysLeft(int count);

  /// No description provided for @vsPrevious.
  ///
  /// In el, this message translates to:
  /// **'{change} vs {period}'**
  String vsPrevious(String change, String period);

  /// No description provided for @ofAmount.
  ///
  /// In el, this message translates to:
  /// **'από {amount}'**
  String ofAmount(String amount);

  /// No description provided for @homeSpentLabel.
  ///
  /// In el, this message translates to:
  /// **'ΞΟΔΕΥΤΗΚΑΝ'**
  String get homeSpentLabel;

  /// No description provided for @homeTodayCanSpend.
  ///
  /// In el, this message translates to:
  /// **'Σήμερα μπορείς'**
  String get homeTodayCanSpend;

  /// No description provided for @homeSavings.
  ///
  /// In el, this message translates to:
  /// **'Αποταμίευση'**
  String get homeSavings;

  /// No description provided for @homeThisWeek.
  ///
  /// In el, this message translates to:
  /// **'Αυτή την εβδομάδα'**
  String get homeThisWeek;

  /// No description provided for @homeRecent.
  ///
  /// In el, this message translates to:
  /// **'Πρόσφατες κινήσεις'**
  String get homeRecent;

  /// No description provided for @homeSeeAll.
  ///
  /// In el, this message translates to:
  /// **'Όλες'**
  String get homeSeeAll;

  /// No description provided for @homeSpendSplitSemantics.
  ///
  /// In el, this message translates to:
  /// **'Κατανομή εξόδων ανά κατηγορία: {summary}'**
  String homeSpendSplitSemantics(String summary);

  /// No description provided for @homeWeekBarsSemantics.
  ///
  /// In el, this message translates to:
  /// **'Έξοδα ανά ημέρα της εβδομάδας: {summary}'**
  String homeWeekBarsSemantics(String summary);

  /// No description provided for @homeSavingsSemantics.
  ///
  /// In el, this message translates to:
  /// **'Αποταμίευση {amount}'**
  String homeSavingsSemantics(String amount);

  /// No description provided for @homePeriodPicker.
  ///
  /// In el, this message translates to:
  /// **'Επιλογή περιόδου'**
  String get homePeriodPicker;

  /// No description provided for @otherCategories.
  ///
  /// In el, this message translates to:
  /// **'Άλλα'**
  String get otherCategories;

  /// No description provided for @noSpendingYet.
  ///
  /// In el, this message translates to:
  /// **'Χωρίς έξοδα ακόμα'**
  String get noSpendingYet;

  /// No description provided for @homeWelcome.
  ///
  /// In el, this message translates to:
  /// **'Καλώς ήρθες'**
  String get homeWelcome;

  /// No description provided for @homeWholeMonthAhead.
  ///
  /// In el, this message translates to:
  /// **'Ολόκληρος ο {month} μπροστά σου.'**
  String homeWholeMonthAhead(String month);

  /// No description provided for @homeEmptyHint.
  ///
  /// In el, this message translates to:
  /// **'Εδώ θα βλέπεις πού πηγαίνουν τα χρήματά σου.'**
  String get homeEmptyHint;

  /// No description provided for @firstStepsTitle.
  ///
  /// In el, this message translates to:
  /// **'Πρώτα βήματα'**
  String get firstStepsTitle;

  /// No description provided for @progressOf.
  ///
  /// In el, this message translates to:
  /// **'{done} από {total}'**
  String progressOf(int done, int total);

  /// No description provided for @firstStepIncome.
  ///
  /// In el, this message translates to:
  /// **'Εισόδημα και όρια'**
  String get firstStepIncome;

  /// No description provided for @firstStepIncomeSub.
  ///
  /// In el, this message translates to:
  /// **'{income} / μήνα · {count, plural, =1{1 κατηγορία} other{{count} κατηγορίες}}'**
  String firstStepIncomeSub(String income, int count);

  /// No description provided for @firstStepTxn.
  ///
  /// In el, this message translates to:
  /// **'Πρώτη κίνηση'**
  String get firstStepTxn;

  /// No description provided for @firstStepTxnSub.
  ///
  /// In el, this message translates to:
  /// **'Ένα καφέ μετράει κι αυτό'**
  String get firstStepTxnSub;

  /// No description provided for @firstStepRecurring.
  ///
  /// In el, this message translates to:
  /// **'Πάγια και συνδρομές'**
  String get firstStepRecurring;

  /// No description provided for @firstStepRecurringSub.
  ///
  /// In el, this message translates to:
  /// **'Ενοίκιο, ρεύμα, streaming'**
  String get firstStepRecurringSub;

  /// No description provided for @firstStepAccounts.
  ///
  /// In el, this message translates to:
  /// **'Υπόλοιπα λογαριασμών'**
  String get firstStepAccounts;

  /// No description provided for @firstStepAccountsSub.
  ///
  /// In el, this message translates to:
  /// **'Για σωστό συνολικό υπόλοιπο'**
  String get firstStepAccountsSub;

  /// No description provided for @stepDone.
  ///
  /// In el, this message translates to:
  /// **'Ολοκληρώθηκε'**
  String get stepDone;

  /// No description provided for @emptyNoTxnsTitle.
  ///
  /// In el, this message translates to:
  /// **'Καμία κίνηση ακόμα'**
  String get emptyNoTxnsTitle;

  /// No description provided for @emptyNoTxnsBody.
  ///
  /// In el, this message translates to:
  /// **'Πάτα το + για να καταγράψεις την πρώτη.'**
  String get emptyNoTxnsBody;

  /// No description provided for @emptyStartHere.
  ///
  /// In el, this message translates to:
  /// **'Ξεκίνα από εδώ'**
  String get emptyStartHere;

  /// No description provided for @insightsTitle.
  ///
  /// In el, this message translates to:
  /// **'Αναλύσεις'**
  String get insightsTitle;

  /// No description provided for @periodWeek.
  ///
  /// In el, this message translates to:
  /// **'Εβδομάδα'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In el, this message translates to:
  /// **'Μήνας'**
  String get periodMonth;

  /// No description provided for @periodYear.
  ///
  /// In el, this message translates to:
  /// **'Έτος'**
  String get periodYear;

  /// No description provided for @periodControl.
  ///
  /// In el, this message translates to:
  /// **'Περίοδος'**
  String get periodControl;

  /// No description provided for @insightsSpendingLabel.
  ///
  /// In el, this message translates to:
  /// **'ΕΞΟΔΑ {period}'**
  String insightsSpendingLabel(String period);

  /// No description provided for @insightsThisWeek.
  ///
  /// In el, this message translates to:
  /// **'ΕΒΔΟΜΑΔΑΣ'**
  String get insightsThisWeek;

  /// No description provided for @insightsChartSemantics.
  ///
  /// In el, this message translates to:
  /// **'Έξοδα ανά περίοδο: {summary}'**
  String insightsChartSemantics(String summary);

  /// No description provided for @insightIncreaseTitle.
  ///
  /// In el, this message translates to:
  /// **'{category} {change}'**
  String insightIncreaseTitle(String category, String change);

  /// No description provided for @insightIncreaseBody.
  ///
  /// In el, this message translates to:
  /// **'{amount} περισσότερα από την προηγούμενη περίοδο.'**
  String insightIncreaseBody(String amount);

  /// No description provided for @insightTopWeekday.
  ///
  /// In el, this message translates to:
  /// **'Τα περισσότερα έξοδα γίνονται {weekday}.'**
  String insightTopWeekday(String weekday);

  /// No description provided for @insightNoIncrease.
  ///
  /// In el, this message translates to:
  /// **'Καμία κατηγορία δεν ξεπέρασε την προηγούμενη περίοδο. Μπράβο!'**
  String get insightNoIncrease;

  /// No description provided for @topCategories.
  ///
  /// In el, this message translates to:
  /// **'Κορυφαίες κατηγορίες'**
  String get topCategories;

  /// No description provided for @insightsEmpty.
  ///
  /// In el, this message translates to:
  /// **'Δεν υπάρχουν έξοδα σε αυτή την περίοδο.'**
  String get insightsEmpty;

  /// No description provided for @noPreviousData.
  ///
  /// In el, this message translates to:
  /// **'Χωρίς σύγκριση'**
  String get noPreviousData;

  /// No description provided for @budgetsTitle.
  ///
  /// In el, this message translates to:
  /// **'Budgets'**
  String get budgetsTitle;

  /// No description provided for @budgetsWithinLimit.
  ///
  /// In el, this message translates to:
  /// **'{within} από {total} εντός ορίου'**
  String budgetsWithinLimit(int within, int total);

  /// No description provided for @budgetsNewCategory.
  ///
  /// In el, this message translates to:
  /// **'Νέα κατηγορία'**
  String get budgetsNewCategory;

  /// No description provided for @budgetOverBy.
  ///
  /// In el, this message translates to:
  /// **'Πάνω από το όριο κατά {amount}'**
  String budgetOverBy(String amount);

  /// No description provided for @budgetRemaining.
  ///
  /// In el, this message translates to:
  /// **'Απομένουν {amount}'**
  String budgetRemaining(String amount);

  /// No description provided for @budgetNearLimit.
  ///
  /// In el, this message translates to:
  /// **'Κοντά στο όριο'**
  String get budgetNearLimit;

  /// No description provided for @budgetSpentOfLimit.
  ///
  /// In el, this message translates to:
  /// **'{spent} / {limit}'**
  String budgetSpentOfLimit(String spent, String limit);

  /// No description provided for @budgetsSummarySemantics.
  ///
  /// In el, this message translates to:
  /// **'Ξοδεύτηκαν {spent} από {limit}'**
  String budgetsSummarySemantics(String spent, String limit);

  /// No description provided for @budgetRingSemantics.
  ///
  /// In el, this message translates to:
  /// **'{name}: {percent}% του ορίου'**
  String budgetRingSemantics(String name, int percent);

  /// No description provided for @budgetsEmpty.
  ///
  /// In el, this message translates to:
  /// **'Δεν έχεις ορίσει όρια ακόμα. Πρόσθεσε μηνιαίο όριο σε μια κατηγορία.'**
  String get budgetsEmpty;

  /// No description provided for @addExpense.
  ///
  /// In el, this message translates to:
  /// **'Έξοδο'**
  String get addExpense;

  /// No description provided for @addIncome.
  ///
  /// In el, this message translates to:
  /// **'Έσοδο'**
  String get addIncome;

  /// No description provided for @addTransfer.
  ///
  /// In el, this message translates to:
  /// **'Μεταφορά'**
  String get addTransfer;

  /// No description provided for @addTypeGroup.
  ///
  /// In el, this message translates to:
  /// **'Τύπος'**
  String get addTypeGroup;

  /// No description provided for @addNewExpenseLabel.
  ///
  /// In el, this message translates to:
  /// **'ΝΕΟ ΕΞΟΔΟ'**
  String get addNewExpenseLabel;

  /// No description provided for @addNewIncomeLabel.
  ///
  /// In el, this message translates to:
  /// **'ΝΕΟ ΕΣΟΔΟ'**
  String get addNewIncomeLabel;

  /// No description provided for @addNewTransferLabel.
  ///
  /// In el, this message translates to:
  /// **'ΝΕΑ ΜΕΤΑΦΟΡΑ'**
  String get addNewTransferLabel;

  /// No description provided for @addNote.
  ///
  /// In el, this message translates to:
  /// **'Σημείωση'**
  String get addNote;

  /// No description provided for @addNoteHint.
  ///
  /// In el, this message translates to:
  /// **'Προσθήκη σημείωσης'**
  String get addNoteHint;

  /// No description provided for @addSaveAmount.
  ///
  /// In el, this message translates to:
  /// **'Αποθήκευση {amount}'**
  String addSaveAmount(String amount);

  /// No description provided for @amountSemantics.
  ///
  /// In el, this message translates to:
  /// **'Ποσό {amount}'**
  String amountSemantics(String amount);

  /// No description provided for @keypadDelete.
  ///
  /// In el, this message translates to:
  /// **'Διαγραφή ψηφίου'**
  String get keypadDelete;

  /// No description provided for @keypadComma.
  ///
  /// In el, this message translates to:
  /// **'Υποδιαστολή'**
  String get keypadComma;

  /// No description provided for @pickDate.
  ///
  /// In el, this message translates to:
  /// **'Ημερομηνία'**
  String get pickDate;

  /// No description provided for @pickAccount.
  ///
  /// In el, this message translates to:
  /// **'Λογαριασμός'**
  String get pickAccount;

  /// No description provided for @pickCategory.
  ///
  /// In el, this message translates to:
  /// **'Κατηγορία'**
  String get pickCategory;

  /// No description provided for @validationAmountRequired.
  ///
  /// In el, this message translates to:
  /// **'Συμπλήρωσε ποσό μεγαλύτερο από 0.'**
  String get validationAmountRequired;

  /// No description provided for @validationAmountMax.
  ///
  /// In el, this message translates to:
  /// **'Το μέγιστο ποσό είναι €99.999,99.'**
  String get validationAmountMax;

  /// No description provided for @validationSameAccount.
  ///
  /// In el, this message translates to:
  /// **'Διάλεξε δύο διαφορετικούς λογαριασμούς.'**
  String get validationSameAccount;

  /// No description provided for @validationCategoryRequired.
  ///
  /// In el, this message translates to:
  /// **'Διάλεξε κατηγορία.'**
  String get validationCategoryRequired;

  /// No description provided for @validationAccountRequired.
  ///
  /// In el, this message translates to:
  /// **'Πρόσθεσε πρώτα έναν λογαριασμό.'**
  String get validationAccountRequired;

  /// No description provided for @validationNameRequired.
  ///
  /// In el, this message translates to:
  /// **'Συμπλήρωσε όνομα.'**
  String get validationNameRequired;

  /// No description provided for @editTitle.
  ///
  /// In el, this message translates to:
  /// **'Επεξεργασία'**
  String get editTitle;

  /// No description provided for @editTitleHint.
  ///
  /// In el, this message translates to:
  /// **'Τίτλος'**
  String get editTitleHint;

  /// No description provided for @editAmountTap.
  ///
  /// In el, this message translates to:
  /// **'Αλλαγή ποσού'**
  String get editAmountTap;

  /// No description provided for @editRepeatMonthly.
  ///
  /// In el, this message translates to:
  /// **'Επανάληψη κάθε μήνα'**
  String get editRepeatMonthly;

  /// No description provided for @editAttachReceipt.
  ///
  /// In el, this message translates to:
  /// **'Επισύναψη απόδειξης'**
  String get editAttachReceipt;

  /// No description provided for @editReceiptAttached.
  ///
  /// In el, this message translates to:
  /// **'Απόδειξη επισυνάφθηκε'**
  String get editReceiptAttached;

  /// No description provided for @editRemoveReceipt.
  ///
  /// In el, this message translates to:
  /// **'Αφαίρεση απόδειξης'**
  String get editRemoveReceipt;

  /// No description provided for @editSaveChanges.
  ///
  /// In el, this message translates to:
  /// **'Αποθήκευση αλλαγών'**
  String get editSaveChanges;

  /// No description provided for @editDeleteTxn.
  ///
  /// In el, this message translates to:
  /// **'Διαγραφή κίνησης'**
  String get editDeleteTxn;

  /// No description provided for @editNotFound.
  ///
  /// In el, this message translates to:
  /// **'Η κίνηση δεν βρέθηκε.'**
  String get editNotFound;

  /// No description provided for @receiptFromCamera.
  ///
  /// In el, this message translates to:
  /// **'Κάμερα'**
  String get receiptFromCamera;

  /// No description provided for @receiptFromGallery.
  ///
  /// In el, this message translates to:
  /// **'Συλλογή'**
  String get receiptFromGallery;

  /// No description provided for @deleteDialogTitle.
  ///
  /// In el, this message translates to:
  /// **'Διαγραφή της κίνησης;'**
  String get deleteDialogTitle;

  /// No description provided for @deleteDialogBodyExpense.
  ///
  /// In el, this message translates to:
  /// **'Το «{name} {amount}» θα αφαιρεθεί από τον {month} και το υπόλοιπο του λογαριασμού «{account}» θα αυξηθεί αντίστοιχα.'**
  String deleteDialogBodyExpense(String name, String amount, String month, String account);

  /// No description provided for @deleteDialogBodyIncome.
  ///
  /// In el, this message translates to:
  /// **'Το «{name} {amount}» θα αφαιρεθεί από τον {month} και το υπόλοιπο του λογαριασμού «{account}» θα μειωθεί αντίστοιχα.'**
  String deleteDialogBodyIncome(String name, String amount, String month, String account);

  /// No description provided for @deleteDialogBodyTransfer.
  ///
  /// In el, this message translates to:
  /// **'Η μεταφορά {amount} θα ακυρωθεί και τα υπόλοιπα των λογαριασμών «{from}» και «{to}» θα επανέλθουν.'**
  String deleteDialogBodyTransfer(String amount, String from, String to);

  /// No description provided for @txnsTitle.
  ///
  /// In el, this message translates to:
  /// **'Κινήσεις'**
  String get txnsTitle;

  /// No description provided for @txnsSearchHint.
  ///
  /// In el, this message translates to:
  /// **'Αναζήτηση'**
  String get txnsSearchHint;

  /// No description provided for @filterAll.
  ///
  /// In el, this message translates to:
  /// **'Όλες'**
  String get filterAll;

  /// No description provided for @filterExpenses.
  ///
  /// In el, this message translates to:
  /// **'Έξοδα'**
  String get filterExpenses;

  /// No description provided for @filterIncome.
  ///
  /// In el, this message translates to:
  /// **'Έσοδα'**
  String get filterIncome;

  /// No description provided for @txnsSwipeHint.
  ///
  /// In el, this message translates to:
  /// **'Σύρε αριστερά μια κίνηση για επεξεργασία ή διαγραφή'**
  String get txnsSwipeHint;

  /// No description provided for @txnsEmpty.
  ///
  /// In el, this message translates to:
  /// **'Δεν βρέθηκαν κινήσεις.'**
  String get txnsEmpty;

  /// No description provided for @transferTitle.
  ///
  /// In el, this message translates to:
  /// **'Μεταφορά'**
  String get transferTitle;

  /// No description provided for @transferRoute.
  ///
  /// In el, this message translates to:
  /// **'{from} → {to}'**
  String transferRoute(String from, String to);

  /// No description provided for @txnSemantics.
  ///
  /// In el, this message translates to:
  /// **'{title}, {subtitle}, {amount}'**
  String txnSemantics(String title, String subtitle, String amount);

  /// No description provided for @recurringTitle.
  ///
  /// In el, this message translates to:
  /// **'Επαναλαμβανόμενα'**
  String get recurringTitle;

  /// No description provided for @recurringMonthlyLabel.
  ///
  /// In el, this message translates to:
  /// **'ΠΑΓΙΑ / ΜΗΝΑ'**
  String get recurringMonthlyLabel;

  /// No description provided for @recurringShareOfIncome.
  ///
  /// In el, this message translates to:
  /// **'{percent}% του εισοδήματος'**
  String recurringShareOfIncome(int percent);

  /// No description provided for @recurringNext7Days.
  ///
  /// In el, this message translates to:
  /// **'Επόμενες 7 ημέρες'**
  String get recurringNext7Days;

  /// No description provided for @recurringListTitle.
  ///
  /// In el, this message translates to:
  /// **'Συνδρομές & πάγια'**
  String get recurringListTitle;

  /// No description provided for @recurringActiveCount.
  ///
  /// In el, this message translates to:
  /// **'{count, plural, =1{1 ενεργό} other{{count} ενεργά}}'**
  String recurringActiveCount(int count);

  /// No description provided for @freqMonthly.
  ///
  /// In el, this message translates to:
  /// **'Μηνιαία, {day}'**
  String freqMonthly(String day);

  /// No description provided for @freqEveryNMonths.
  ///
  /// In el, this message translates to:
  /// **'Κάθε {count} μήνες'**
  String freqEveryNMonths(int count);

  /// No description provided for @freqWeekly.
  ///
  /// In el, this message translates to:
  /// **'Κάθε {weekday}'**
  String freqWeekly(String weekday);

  /// No description provided for @freqYearly.
  ///
  /// In el, this message translates to:
  /// **'Ετήσια, {date}'**
  String freqYearly(String date);

  /// No description provided for @dueIn.
  ///
  /// In el, this message translates to:
  /// **'{count, plural, =0{σήμερα} =1{αύριο} other{σε {count} μέρες}}'**
  String dueIn(int count);

  /// No description provided for @recurringPaused.
  ///
  /// In el, this message translates to:
  /// **'Σε παύση'**
  String get recurringPaused;

  /// No description provided for @recurringNew.
  ///
  /// In el, this message translates to:
  /// **'Νέο επαναλαμβανόμενο'**
  String get recurringNew;

  /// No description provided for @recurringEdit.
  ///
  /// In el, this message translates to:
  /// **'Επεξεργασία επαναλαμβανόμενου'**
  String get recurringEdit;

  /// No description provided for @recurringEmpty.
  ///
  /// In el, this message translates to:
  /// **'Δεν υπάρχουν επαναλαμβανόμενες κινήσεις ακόμα.'**
  String get recurringEmpty;

  /// No description provided for @recurringToggle.
  ///
  /// In el, this message translates to:
  /// **'{name}: ενεργό'**
  String recurringToggle(String name);

  /// No description provided for @recurringDueDaySemantics.
  ///
  /// In el, this message translates to:
  /// **'{day}: {names}'**
  String recurringDueDaySemantics(String day, String names);

  /// No description provided for @fieldName.
  ///
  /// In el, this message translates to:
  /// **'Όνομα'**
  String get fieldName;

  /// No description provided for @fieldAmount.
  ///
  /// In el, this message translates to:
  /// **'Ποσό'**
  String get fieldAmount;

  /// No description provided for @fieldFrequency.
  ///
  /// In el, this message translates to:
  /// **'Συχνότητα'**
  String get fieldFrequency;

  /// No description provided for @fieldFirstDue.
  ///
  /// In el, this message translates to:
  /// **'Επόμενη χρέωση'**
  String get fieldFirstDue;

  /// No description provided for @freqOptionMonthly.
  ///
  /// In el, this message translates to:
  /// **'Μηνιαία'**
  String get freqOptionMonthly;

  /// No description provided for @freqOptionEveryN.
  ///
  /// In el, this message translates to:
  /// **'Κάθε N μήνες'**
  String get freqOptionEveryN;

  /// No description provided for @freqOptionWeekly.
  ///
  /// In el, this message translates to:
  /// **'Εβδομαδιαία'**
  String get freqOptionWeekly;

  /// No description provided for @freqOptionYearly.
  ///
  /// In el, this message translates to:
  /// **'Ετήσια'**
  String get freqOptionYearly;

  /// No description provided for @fieldIntervalMonths.
  ///
  /// In el, this message translates to:
  /// **'Κάθε πόσους μήνες'**
  String get fieldIntervalMonths;

  /// No description provided for @recurringDelete.
  ///
  /// In el, this message translates to:
  /// **'Διαγραφή επαναλαμβανόμενου'**
  String get recurringDelete;

  /// No description provided for @accountsTitle.
  ///
  /// In el, this message translates to:
  /// **'Λογαριασμοί'**
  String get accountsTitle;

  /// No description provided for @accountsTotalLabel.
  ///
  /// In el, this message translates to:
  /// **'ΣΥΝΟΛΙΚΟ ΥΠΟΛΟΙΠΟ'**
  String get accountsTotalLabel;

  /// No description provided for @accountsTransfer.
  ///
  /// In el, this message translates to:
  /// **'Μεταφορά'**
  String get accountsTransfer;

  /// No description provided for @accountsNew.
  ///
  /// In el, this message translates to:
  /// **'Νέος'**
  String get accountsNew;

  /// No description provided for @accountTypeBank.
  ///
  /// In el, this message translates to:
  /// **'Τρεχούμενος'**
  String get accountTypeBank;

  /// No description provided for @accountTypeCard.
  ///
  /// In el, this message translates to:
  /// **'Κάρτα'**
  String get accountTypeCard;

  /// No description provided for @accountTypeCash.
  ///
  /// In el, this message translates to:
  /// **'Μετρητά'**
  String get accountTypeCash;

  /// No description provided for @accountTypeSavings.
  ///
  /// In el, this message translates to:
  /// **'Αποταμίευση'**
  String get accountTypeSavings;

  /// No description provided for @accountTypeBankHint.
  ///
  /// In el, this message translates to:
  /// **'Τραπεζικός λογαριασμός'**
  String get accountTypeBankHint;

  /// No description provided for @accountTypeCardHint.
  ///
  /// In el, this message translates to:
  /// **'Χρεωστική ή πιστωτική'**
  String get accountTypeCardHint;

  /// No description provided for @accountTypeCashHint.
  ///
  /// In el, this message translates to:
  /// **'Πορτοφόλι'**
  String get accountTypeCashHint;

  /// No description provided for @accountTypeSavingsHint.
  ///
  /// In el, this message translates to:
  /// **'Κουμπαράς / ταμιευτήριο'**
  String get accountTypeSavingsHint;

  /// No description provided for @accountSubBank.
  ///
  /// In el, this message translates to:
  /// **'Τράπεζα'**
  String get accountSubBank;

  /// No description provided for @accountSubBankLast4.
  ///
  /// In el, this message translates to:
  /// **'Τράπεζα · ••{last4}'**
  String accountSubBankLast4(String last4);

  /// No description provided for @accountSubCredit.
  ///
  /// In el, this message translates to:
  /// **'Όριο {limit} · λήξη {date}'**
  String accountSubCredit(String limit, String date);

  /// No description provided for @accountSubCreditNoDate.
  ///
  /// In el, this message translates to:
  /// **'Όριο {limit}'**
  String accountSubCreditNoDate(String limit);

  /// No description provided for @accountSubCard.
  ///
  /// In el, this message translates to:
  /// **'Χρεωστική κάρτα'**
  String get accountSubCard;

  /// No description provided for @accountSubCash.
  ///
  /// In el, this message translates to:
  /// **'Πορτοφόλι'**
  String get accountSubCash;

  /// No description provided for @accountSubSavingsGoal.
  ///
  /// In el, this message translates to:
  /// **'Στόχος {goal} · {percent}%'**
  String accountSubSavingsGoal(String goal, int percent);

  /// No description provided for @accountSubSavings.
  ///
  /// In el, this message translates to:
  /// **'Κουμπαράς'**
  String get accountSubSavings;

  /// No description provided for @accountNegativeSemantics.
  ///
  /// In el, this message translates to:
  /// **'αρνητικό υπόλοιπο'**
  String get accountNegativeSemantics;

  /// No description provided for @transferFrom.
  ///
  /// In el, this message translates to:
  /// **'ΑΠΟ'**
  String get transferFrom;

  /// No description provided for @transferTo.
  ///
  /// In el, this message translates to:
  /// **'ΠΡΟΣ'**
  String get transferTo;

  /// No description provided for @transferNote.
  ///
  /// In el, this message translates to:
  /// **'Οι μεταφορές δεν μετράνε ως έσοδα ή έξοδα.'**
  String get transferNote;

  /// No description provided for @transferSubmit.
  ///
  /// In el, this message translates to:
  /// **'Μεταφορά {amount}'**
  String transferSubmit(String amount);

  /// No description provided for @transferSwap.
  ///
  /// In el, this message translates to:
  /// **'Αντιστροφή λογαριασμών'**
  String get transferSwap;

  /// No description provided for @transferNeedsTwo.
  ///
  /// In el, this message translates to:
  /// **'Χρειάζεσαι τουλάχιστον δύο λογαριασμούς για μεταφορά.'**
  String get transferNeedsTwo;

  /// No description provided for @newAccountTitle.
  ///
  /// In el, this message translates to:
  /// **'Νέος λογαριασμός'**
  String get newAccountTitle;

  /// No description provided for @editAccountTitle.
  ///
  /// In el, this message translates to:
  /// **'Επεξεργασία λογαριασμού'**
  String get editAccountTitle;

  /// No description provided for @fieldAccountType.
  ///
  /// In el, this message translates to:
  /// **'Τύπος'**
  String get fieldAccountType;

  /// No description provided for @fieldOpeningBalance.
  ///
  /// In el, this message translates to:
  /// **'Αρχικό υπόλοιπο'**
  String get fieldOpeningBalance;

  /// No description provided for @fieldIsCredit.
  ///
  /// In el, this message translates to:
  /// **'Πιστωτική κάρτα'**
  String get fieldIsCredit;

  /// No description provided for @fieldCreditLimit.
  ///
  /// In el, this message translates to:
  /// **'Όριο'**
  String get fieldCreditLimit;

  /// No description provided for @fieldStatementDay.
  ///
  /// In el, this message translates to:
  /// **'Ημέρα λήξης'**
  String get fieldStatementDay;

  /// No description provided for @fieldLast4.
  ///
  /// In el, this message translates to:
  /// **'Τελευταία 4 ψηφία'**
  String get fieldLast4;

  /// No description provided for @fieldSavingsGoal.
  ///
  /// In el, this message translates to:
  /// **'Στόχος'**
  String get fieldSavingsGoal;

  /// No description provided for @fieldOptional.
  ///
  /// In el, this message translates to:
  /// **'(προαιρετικό)'**
  String get fieldOptional;

  /// No description provided for @accountArchiveConfirm.
  ///
  /// In el, this message translates to:
  /// **'Ο λογαριασμός έχει κινήσεις, οπότε θα αρχειοθετηθεί.'**
  String get accountArchiveConfirm;

  /// No description provided for @categoriesTitle.
  ///
  /// In el, this message translates to:
  /// **'Κατηγορίες'**
  String get categoriesTitle;

  /// No description provided for @categoryLimit.
  ///
  /// In el, this message translates to:
  /// **'Όριο {amount}'**
  String categoryLimit(String amount);

  /// No description provided for @categoryNoLimit.
  ///
  /// In el, this message translates to:
  /// **'Χωρίς όριο'**
  String get categoryNoLimit;

  /// No description provided for @txnCount.
  ///
  /// In el, this message translates to:
  /// **'{count, plural, =1{1 κίνηση} other{{count} κινήσεις}}'**
  String txnCount(int count);

  /// No description provided for @newCategoryTitle.
  ///
  /// In el, this message translates to:
  /// **'Νέα κατηγορία'**
  String get newCategoryTitle;

  /// No description provided for @editCategoryTitle.
  ///
  /// In el, this message translates to:
  /// **'Επεξεργασία κατηγορίας'**
  String get editCategoryTitle;

  /// No description provided for @categoryNameLabel.
  ///
  /// In el, this message translates to:
  /// **'ΟΝΟΜΑ'**
  String get categoryNameLabel;

  /// No description provided for @categoryNameHint.
  ///
  /// In el, this message translates to:
  /// **'π.χ. Κατοικίδιο'**
  String get categoryNameHint;

  /// No description provided for @categoryColor.
  ///
  /// In el, this message translates to:
  /// **'Χρώμα'**
  String get categoryColor;

  /// No description provided for @categoryIcon.
  ///
  /// In el, this message translates to:
  /// **'Εικονίδιο'**
  String get categoryIcon;

  /// No description provided for @categoryMonthlyLimit.
  ///
  /// In el, this message translates to:
  /// **'Μηνιαίο όριο'**
  String get categoryMonthlyLimit;

  /// No description provided for @categoryCreate.
  ///
  /// In el, this message translates to:
  /// **'Δημιουργία κατηγορίας'**
  String get categoryCreate;

  /// No description provided for @categoryKindExpense.
  ///
  /// In el, this message translates to:
  /// **'Έξοδα'**
  String get categoryKindExpense;

  /// No description provided for @categoryKindIncome.
  ///
  /// In el, this message translates to:
  /// **'Έσοδα'**
  String get categoryKindIncome;

  /// No description provided for @categoryArchivedNotice.
  ///
  /// In el, this message translates to:
  /// **'Η κατηγορία έχει κινήσεις, οπότε αρχειοθετήθηκε.'**
  String get categoryArchivedNotice;

  /// No description provided for @categoryDeleteOrArchive.
  ///
  /// In el, this message translates to:
  /// **'Διαγραφή κατηγορίας'**
  String get categoryDeleteOrArchive;

  /// No description provided for @categoryReorderHint.
  ///
  /// In el, this message translates to:
  /// **'Κράτησε πατημένο για αλλαγή σειράς'**
  String get categoryReorderHint;

  /// No description provided for @colorLime.
  ///
  /// In el, this message translates to:
  /// **'Λάιμ'**
  String get colorLime;

  /// No description provided for @colorCoral.
  ///
  /// In el, this message translates to:
  /// **'Κοραλί'**
  String get colorCoral;

  /// No description provided for @colorSky.
  ///
  /// In el, this message translates to:
  /// **'Γαλάζιο'**
  String get colorSky;

  /// No description provided for @colorViolet.
  ///
  /// In el, this message translates to:
  /// **'Μωβ'**
  String get colorViolet;

  /// No description provided for @colorAmber.
  ///
  /// In el, this message translates to:
  /// **'Κεχριμπαρί'**
  String get colorAmber;

  /// No description provided for @colorTeal.
  ///
  /// In el, this message translates to:
  /// **'Τιρκουάζ'**
  String get colorTeal;

  /// No description provided for @colorPink.
  ///
  /// In el, this message translates to:
  /// **'Ροζ'**
  String get colorPink;

  /// No description provided for @colorGrey.
  ///
  /// In el, this message translates to:
  /// **'Γκρι'**
  String get colorGrey;

  /// No description provided for @iconCart.
  ///
  /// In el, this message translates to:
  /// **'Καλάθι'**
  String get iconCart;

  /// No description provided for @iconFood.
  ///
  /// In el, this message translates to:
  /// **'Φαγητό'**
  String get iconFood;

  /// No description provided for @iconCar.
  ///
  /// In el, this message translates to:
  /// **'Αυτοκίνητο'**
  String get iconCar;

  /// No description provided for @iconHome.
  ///
  /// In el, this message translates to:
  /// **'Σπίτι'**
  String get iconHome;

  /// No description provided for @iconFilm.
  ///
  /// In el, this message translates to:
  /// **'Ψυχαγωγία'**
  String get iconFilm;

  /// No description provided for @iconHeart.
  ///
  /// In el, this message translates to:
  /// **'Καρδιά'**
  String get iconHeart;

  /// No description provided for @iconGift.
  ///
  /// In el, this message translates to:
  /// **'Δώρο'**
  String get iconGift;

  /// No description provided for @iconPlane.
  ///
  /// In el, this message translates to:
  /// **'Ταξίδι'**
  String get iconPlane;

  /// No description provided for @iconBook.
  ///
  /// In el, this message translates to:
  /// **'Βιβλίο'**
  String get iconBook;

  /// No description provided for @iconShirt.
  ///
  /// In el, this message translates to:
  /// **'Ρούχα'**
  String get iconShirt;

  /// No description provided for @iconBolt.
  ///
  /// In el, this message translates to:
  /// **'Ρεύμα'**
  String get iconBolt;

  /// No description provided for @iconSalary.
  ///
  /// In el, this message translates to:
  /// **'Χαρτοφύλακας'**
  String get iconSalary;

  /// No description provided for @iconLaptop.
  ///
  /// In el, this message translates to:
  /// **'Υπολογιστής'**
  String get iconLaptop;

  /// No description provided for @iconTag.
  ///
  /// In el, this message translates to:
  /// **'Ετικέτα'**
  String get iconTag;

  /// No description provided for @catGroceries.
  ///
  /// In el, this message translates to:
  /// **'Σούπερ μάρκετ'**
  String get catGroceries;

  /// No description provided for @catDining.
  ///
  /// In el, this message translates to:
  /// **'Εστίαση'**
  String get catDining;

  /// No description provided for @catBills.
  ///
  /// In el, this message translates to:
  /// **'Λογαριασμοί'**
  String get catBills;

  /// No description provided for @catTransport.
  ///
  /// In el, this message translates to:
  /// **'Μετακίνηση'**
  String get catTransport;

  /// No description provided for @catEntertainment.
  ///
  /// In el, this message translates to:
  /// **'Ψυχαγωγία'**
  String get catEntertainment;

  /// No description provided for @catHousing.
  ///
  /// In el, this message translates to:
  /// **'Στέγαση'**
  String get catHousing;

  /// No description provided for @catSalary.
  ///
  /// In el, this message translates to:
  /// **'Μισθός'**
  String get catSalary;

  /// No description provided for @catFreelance.
  ///
  /// In el, this message translates to:
  /// **'Freelance'**
  String get catFreelance;

  /// No description provided for @catGift.
  ///
  /// In el, this message translates to:
  /// **'Δώρο'**
  String get catGift;

  /// No description provided for @catOther.
  ///
  /// In el, this message translates to:
  /// **'Άλλο'**
  String get catOther;

  /// No description provided for @settingsTitle.
  ///
  /// In el, this message translates to:
  /// **'Περισσότερα'**
  String get settingsTitle;

  /// No description provided for @settingsSectionData.
  ///
  /// In el, this message translates to:
  /// **'Δεδομένα'**
  String get settingsSectionData;

  /// No description provided for @settingsSectionApp.
  ///
  /// In el, this message translates to:
  /// **'Εφαρμογή'**
  String get settingsSectionApp;

  /// No description provided for @settingsIncome.
  ///
  /// In el, this message translates to:
  /// **'Εισόδημα και ημέρα πληρωμής'**
  String get settingsIncome;

  /// No description provided for @settingsTheme.
  ///
  /// In el, this message translates to:
  /// **'Θέμα'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In el, this message translates to:
  /// **'Σύστημα'**
  String get themeSystem;

  /// No description provided for @themeDark.
  ///
  /// In el, this message translates to:
  /// **'Σκούρο'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In el, this message translates to:
  /// **'Φωτεινό'**
  String get themeLight;

  /// No description provided for @settingsBiometric.
  ///
  /// In el, this message translates to:
  /// **'Κλείδωμα με Face ID'**
  String get settingsBiometric;

  /// No description provided for @settingsCurrency.
  ///
  /// In el, this message translates to:
  /// **'Νόμισμα'**
  String get settingsCurrency;

  /// No description provided for @currencyEur.
  ///
  /// In el, this message translates to:
  /// **'EUR · Ευρώ'**
  String get currencyEur;

  /// No description provided for @settingsExportCsv.
  ///
  /// In el, this message translates to:
  /// **'Εξαγωγή CSV'**
  String get settingsExportCsv;

  /// No description provided for @settingsReset.
  ///
  /// In el, this message translates to:
  /// **'Επαναφορά δεδομένων'**
  String get settingsReset;

  /// No description provided for @resetDialogTitle.
  ///
  /// In el, this message translates to:
  /// **'Επαναφορά δεδομένων;'**
  String get resetDialogTitle;

  /// No description provided for @resetDialogBody.
  ///
  /// In el, this message translates to:
  /// **'Θα διαγραφούν όλες οι κινήσεις, οι λογαριασμοί, οι κατηγορίες και τα επαναλαμβανόμενα. Η ενέργεια δεν αναιρείται.'**
  String get resetDialogBody;

  /// No description provided for @resetConfirm.
  ///
  /// In el, this message translates to:
  /// **'Επαναφορά'**
  String get resetConfirm;

  /// No description provided for @exportEmpty.
  ///
  /// In el, this message translates to:
  /// **'Δεν υπάρχουν κινήσεις για εξαγωγή.'**
  String get exportEmpty;

  /// No description provided for @exportSubject.
  ///
  /// In el, this message translates to:
  /// **'Pulse — κινήσεις'**
  String get exportSubject;

  /// No description provided for @biometricUnavailable.
  ///
  /// In el, this message translates to:
  /// **'Η συσκευή δεν υποστηρίζει βιομετρικό κλείδωμα.'**
  String get biometricUnavailable;

  /// No description provided for @biometricReason.
  ///
  /// In el, this message translates to:
  /// **'Ξεκλείδωσε για να δεις τα οικονομικά σου'**
  String get biometricReason;

  /// No description provided for @lockTitle.
  ///
  /// In el, this message translates to:
  /// **'Το Pulse είναι κλειδωμένο'**
  String get lockTitle;

  /// No description provided for @lockUnlock.
  ///
  /// In el, this message translates to:
  /// **'Ξεκλείδωμα'**
  String get lockUnlock;

  /// No description provided for @incomeSheetTitle.
  ///
  /// In el, this message translates to:
  /// **'Εισόδημα και ημέρα πληρωμής'**
  String get incomeSheetTitle;

  /// No description provided for @settingsName.
  ///
  /// In el, this message translates to:
  /// **'Όνομα'**
  String get settingsName;

  /// No description provided for @settingsNameHint.
  ///
  /// In el, this message translates to:
  /// **'Πώς να σε λέμε;'**
  String get settingsNameHint;

  /// No description provided for @settingsLicenses.
  ///
  /// In el, this message translates to:
  /// **'Άδειες λογισμικού'**
  String get settingsLicenses;

  /// No description provided for @settingsLockOn.
  ///
  /// In el, this message translates to:
  /// **'Ζητείται Face ID ή δακτυλικό αποτύπωμα στο άνοιγμα.'**
  String get settingsLockOn;

  /// No description provided for @onbStep.
  ///
  /// In el, this message translates to:
  /// **'ΒΗΜΑ {step} ΑΠΟ {total}'**
  String onbStep(int step, int total);

  /// No description provided for @onbProgress.
  ///
  /// In el, this message translates to:
  /// **'Πρόοδος ρύθμισης: βήμα {step} από {total}'**
  String onbProgress(int step, int total);

  /// No description provided for @onbIncomeTitle.
  ///
  /// In el, this message translates to:
  /// **'Πόσα μπαίνουν κάθε μήνα;'**
  String get onbIncomeTitle;

  /// No description provided for @onbIncomeSubtitle.
  ///
  /// In el, this message translates to:
  /// **'Με βάση αυτό προτείνουμε όρια και υπολογίζουμε πόσα μπορείς να ξοδεύεις κάθε μέρα.'**
  String get onbIncomeSubtitle;

  /// No description provided for @onbIncomeLabel.
  ///
  /// In el, this message translates to:
  /// **'Μηνιαίο καθαρό εισόδημα'**
  String get onbIncomeLabel;

  /// No description provided for @onbPaydayQuestion.
  ///
  /// In el, this message translates to:
  /// **'Πότε πληρώνεσαι;'**
  String get onbPaydayQuestion;

  /// No description provided for @paydayFirst.
  ///
  /// In el, this message translates to:
  /// **'1η του μήνα'**
  String get paydayFirst;

  /// No description provided for @paydayFifteenth.
  ///
  /// In el, this message translates to:
  /// **'15η'**
  String get paydayFifteenth;

  /// No description provided for @paydayLast.
  ///
  /// In el, this message translates to:
  /// **'Τέλος μήνα'**
  String get paydayLast;

  /// No description provided for @paydayOther.
  ///
  /// In el, this message translates to:
  /// **'Άλλη'**
  String get paydayOther;

  /// No description provided for @paydayCustomValue.
  ///
  /// In el, this message translates to:
  /// **'{day} του μήνα'**
  String paydayCustomValue(String day);

  /// No description provided for @paydayGroup.
  ///
  /// In el, this message translates to:
  /// **'Ημέρα πληρωμής'**
  String get paydayGroup;

  /// No description provided for @onbPaydayHelper.
  ///
  /// In el, this message translates to:
  /// **'Ο «μήνας» στο app θα ξεκινά από αυτή την ημέρα.'**
  String get onbPaydayHelper;

  /// No description provided for @onbLimitsTitle.
  ///
  /// In el, this message translates to:
  /// **'Όρισε όρια ανά κατηγορία'**
  String get onbLimitsTitle;

  /// No description provided for @onbLimitsSubtitle.
  ///
  /// In el, this message translates to:
  /// **'Ξεκίνα με τις προτάσεις μας. Θα μπορείς να τα αλλάξεις όποτε θέλεις.'**
  String get onbLimitsSubtitle;

  /// No description provided for @onbLeftForSavings.
  ///
  /// In el, this message translates to:
  /// **'Μένουν για αποταμίευση'**
  String get onbLeftForSavings;

  /// No description provided for @onbAccountsTitle.
  ///
  /// In el, this message translates to:
  /// **'Πού κρατάς τα χρήματά σου;'**
  String get onbAccountsTitle;

  /// No description provided for @onbAccountsSubtitle.
  ///
  /// In el, this message translates to:
  /// **'Διάλεξε τους λογαριασμούς σου, για να βλέπεις το υπόλοιπο του καθενός.'**
  String get onbAccountsSubtitle;

  /// No description provided for @onbWelcomeTitle.
  ///
  /// In el, this message translates to:
  /// **'Μάθε κάθε μέρα πόσα μπορείς να ξοδέψεις.'**
  String get onbWelcomeTitle;

  /// No description provided for @onbWelcomeBody.
  ///
  /// In el, this message translates to:
  /// **'Βάζεις εισόδημα και όρια, καταγράφεις τα έξοδα, και το Pulse σου λέει πόσα μένουν για σήμερα.'**
  String get onbWelcomeBody;

  /// No description provided for @onbWelcomePrivacy.
  ///
  /// In el, this message translates to:
  /// **'Τα δεδομένα μένουν στο κινητό σου. Χωρίς λογαριασμό.'**
  String get onbWelcomePrivacy;

  /// No description provided for @stepperDecrease.
  ///
  /// In el, this message translates to:
  /// **'Μείωση ορίου για {name}'**
  String stepperDecrease(String name);

  /// No description provided for @stepperIncrease.
  ///
  /// In el, this message translates to:
  /// **'Αύξηση ορίου για {name}'**
  String stepperIncrease(String name);

  /// No description provided for @selected.
  ///
  /// In el, this message translates to:
  /// **'επιλεγμένο'**
  String get selected;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['el'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'el':
      return AppLocalizationsEl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
