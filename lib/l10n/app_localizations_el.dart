// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get navHome => 'Αρχική';

  @override
  String get navInsights => 'Αναλύσεις';

  @override
  String get navBudgets => 'Budgets';

  @override
  String get navAdd => 'Νέα κίνηση';

  @override
  String get navMore => 'Περισσότερα';

  @override
  String get mainNavigation => 'Κύρια πλοήγηση';

  @override
  String get themeToLight => 'Φωτεινό θέμα';

  @override
  String get themeToDark => 'Σκοτεινό θέμα';

  @override
  String get actionBack => 'Πίσω';

  @override
  String get actionClose => 'Κλείσιμο';

  @override
  String get actionCancel => 'Ακύρωση';

  @override
  String get actionSave => 'Αποθήκευση';

  @override
  String get actionDelete => 'Διαγραφή';

  @override
  String get actionEditShort => 'Επεξ.';

  @override
  String get actionUndo => 'Αναίρεση';

  @override
  String get actionContinue => 'Συνέχεια';

  @override
  String get actionStart => 'Ξεκίνα';

  @override
  String get actionSkip => 'Παράλειψη';

  @override
  String get actionDone => 'Τέλος';

  @override
  String get actionArchive => 'Αρχειοθέτηση';

  @override
  String deletedToast(String name) {
    return 'Διαγράφηκε: $name';
  }

  @override
  String get dayToday => 'Σήμερα';

  @override
  String get dayYesterday => 'Χθες';

  @override
  String get dayTomorrow => 'Αύριο';

  @override
  String daysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count μέρες ακόμα', one: '1 μέρα ακόμα');
    return '$_temp0';
  }

  @override
  String vsPrevious(String change, String period) {
    return '$change vs $period';
  }

  @override
  String ofAmount(String amount) {
    return 'από $amount';
  }

  @override
  String get homeBalanceLabel => 'ΥΠΟΛΟΙΠΟ ΜΗΝΑ';

  @override
  String get homeTodayCanSpend => 'Σήμερα μπορείς';

  @override
  String get homeSavings => 'Αποταμίευση';

  @override
  String get homeThisWeek => 'Αυτή την εβδομάδα';

  @override
  String get homeRecent => 'Πρόσφατες κινήσεις';

  @override
  String get homeSeeAll => 'Όλες';

  @override
  String homeSpendSplitSemantics(String summary) {
    return 'Κατανομή εξόδων ανά κατηγορία: $summary';
  }

  @override
  String homeWeekBarsSemantics(String summary) {
    return 'Έξοδα ανά ημέρα της εβδομάδας: $summary';
  }

  @override
  String homeSavingsSemantics(String amount) {
    return 'Αποταμίευση $amount';
  }

  @override
  String get homePeriodPicker => 'Επιλογή περιόδου';

  @override
  String get otherCategories => 'Άλλα';

  @override
  String get noSpendingYet => 'Χωρίς έξοδα ακόμα';

  @override
  String get homeWelcome => 'Καλώς ήρθες';

  @override
  String get homeAvailableToSpend => 'ΔΙΑΘΕΣΙΜΑ ΓΙΑ ΝΑ ΞΟΔΕΨΕΙΣ';

  @override
  String homeWholeMonthAhead(String month) {
    return 'Ολόκληρος ο $month μπροστά σου.';
  }

  @override
  String get homeEmptyHint => 'Εδώ θα βλέπεις πού πηγαίνουν τα χρήματά σου.';

  @override
  String get firstStepsTitle => 'Πρώτα βήματα';

  @override
  String progressOf(int done, int total) {
    return '$done από $total';
  }

  @override
  String get firstStepIncome => 'Εισόδημα και όρια';

  @override
  String firstStepIncomeSub(String income, int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count κατηγορίες', one: '1 κατηγορία');
    return '$income / μήνα · $_temp0';
  }

  @override
  String get firstStepTxn => 'Πρώτη κίνηση';

  @override
  String get firstStepTxnSub => 'Ένα καφέ μετράει κι αυτό';

  @override
  String get firstStepRecurring => 'Πάγια και συνδρομές';

  @override
  String get firstStepRecurringSub => 'Ενοίκιο, ρεύμα, streaming';

  @override
  String get firstStepAccounts => 'Υπόλοιπα λογαριασμών';

  @override
  String get firstStepAccountsSub => 'Για σωστό συνολικό υπόλοιπο';

  @override
  String get stepDone => 'Ολοκληρώθηκε';

  @override
  String get emptyNoTxnsTitle => 'Καμία κίνηση ακόμα';

  @override
  String get emptyNoTxnsBody => 'Πάτα το + για να καταγράψεις την πρώτη.';

  @override
  String get emptyStartHere => 'Ξεκίνα από εδώ';

  @override
  String get insightsTitle => 'Αναλύσεις';

  @override
  String get periodWeek => 'Εβδομάδα';

  @override
  String get periodMonth => 'Μήνας';

  @override
  String get periodYear => 'Έτος';

  @override
  String get periodControl => 'Περίοδος';

  @override
  String insightsSpendingLabel(String period) {
    return 'ΕΞΟΔΑ $period';
  }

  @override
  String get insightsThisWeek => 'ΕΒΔΟΜΑΔΑΣ';

  @override
  String insightsChartSemantics(String summary) {
    return 'Έξοδα ανά περίοδο: $summary';
  }

  @override
  String insightIncreaseTitle(String category, String change) {
    return '$category $change';
  }

  @override
  String insightIncreaseBody(String amount) {
    return '$amount περισσότερα από την προηγούμενη περίοδο.';
  }

  @override
  String insightTopWeekday(String weekday) {
    return 'Τα περισσότερα έξοδα γίνονται $weekday.';
  }

  @override
  String get insightNoIncrease => 'Καμία κατηγορία δεν ξεπέρασε την προηγούμενη περίοδο. Μπράβο!';

  @override
  String get topCategories => 'Κορυφαίες κατηγορίες';

  @override
  String get insightsEmpty => 'Δεν υπάρχουν έξοδα σε αυτή την περίοδο.';

  @override
  String get noPreviousData => 'Χωρίς σύγκριση';

  @override
  String get budgetsTitle => 'Budgets';

  @override
  String budgetsWithinLimit(int within, int total) {
    return '$within από $total εντός ορίου';
  }

  @override
  String get budgetsNewCategory => 'Νέα κατηγορία';

  @override
  String budgetOverBy(String amount) {
    return 'Πάνω από το όριο κατά $amount';
  }

  @override
  String budgetRemaining(String amount) {
    return 'Απομένουν $amount';
  }

  @override
  String get budgetNearLimit => 'Κοντά στο όριο';

  @override
  String budgetSpentOfLimit(String spent, String limit) {
    return '$spent / $limit';
  }

  @override
  String budgetsSummarySemantics(String spent, String limit) {
    return 'Ξοδεύτηκαν $spent από $limit';
  }

  @override
  String budgetRingSemantics(String name, int percent) {
    return '$name: $percent% του ορίου';
  }

  @override
  String get budgetsEmpty => 'Δεν έχεις ορίσει όρια ακόμα. Πρόσθεσε μηνιαίο όριο σε μια κατηγορία.';

  @override
  String get addExpense => 'Έξοδο';

  @override
  String get addIncome => 'Έσοδο';

  @override
  String get addTransfer => 'Μεταφορά';

  @override
  String get addTypeGroup => 'Τύπος';

  @override
  String get addNewExpenseLabel => 'ΝΕΟ ΕΞΟΔΟ';

  @override
  String get addNewIncomeLabel => 'ΝΕΟ ΕΣΟΔΟ';

  @override
  String get addNewTransferLabel => 'ΝΕΑ ΜΕΤΑΦΟΡΑ';

  @override
  String get addNote => 'Σημείωση';

  @override
  String get addNoteHint => 'Προσθήκη σημείωσης';

  @override
  String addSaveAmount(String amount) {
    return 'Αποθήκευση $amount';
  }

  @override
  String amountSemantics(String amount) {
    return 'Ποσό $amount';
  }

  @override
  String get keypadDelete => 'Διαγραφή ψηφίου';

  @override
  String get keypadComma => 'Υποδιαστολή';

  @override
  String get pickDate => 'Ημερομηνία';

  @override
  String get pickAccount => 'Λογαριασμός';

  @override
  String get pickCategory => 'Κατηγορία';

  @override
  String get validationAmountRequired => 'Συμπλήρωσε ποσό μεγαλύτερο από 0.';

  @override
  String get validationAmountMax => 'Το μέγιστο ποσό είναι €99.999,99.';

  @override
  String get validationSameAccount => 'Διάλεξε δύο διαφορετικούς λογαριασμούς.';

  @override
  String get validationCategoryRequired => 'Διάλεξε κατηγορία.';

  @override
  String get validationAccountRequired => 'Πρόσθεσε πρώτα έναν λογαριασμό.';

  @override
  String get validationNameRequired => 'Συμπλήρωσε όνομα.';

  @override
  String get editTitle => 'Επεξεργασία';

  @override
  String get editTitleHint => 'Τίτλος';

  @override
  String get editAmountTap => 'Αλλαγή ποσού';

  @override
  String get editRepeatMonthly => 'Επανάληψη κάθε μήνα';

  @override
  String get editAttachReceipt => 'Επισύναψη απόδειξης';

  @override
  String get editReceiptAttached => 'Απόδειξη επισυνάφθηκε';

  @override
  String get editRemoveReceipt => 'Αφαίρεση απόδειξης';

  @override
  String get editSaveChanges => 'Αποθήκευση αλλαγών';

  @override
  String get editDeleteTxn => 'Διαγραφή κίνησης';

  @override
  String get editNotFound => 'Η κίνηση δεν βρέθηκε.';

  @override
  String get receiptFromCamera => 'Κάμερα';

  @override
  String get receiptFromGallery => 'Συλλογή';

  @override
  String get deleteDialogTitle => 'Διαγραφή της κίνησης;';

  @override
  String deleteDialogBodyExpense(String name, String amount, String month, String account) {
    return 'Το «$name $amount» θα αφαιρεθεί από τον $month και το υπόλοιπο του λογαριασμού «$account» θα αυξηθεί αντίστοιχα.';
  }

  @override
  String deleteDialogBodyIncome(String name, String amount, String month, String account) {
    return 'Το «$name $amount» θα αφαιρεθεί από τον $month και το υπόλοιπο του λογαριασμού «$account» θα μειωθεί αντίστοιχα.';
  }

  @override
  String deleteDialogBodyTransfer(String amount, String from, String to) {
    return 'Η μεταφορά $amount θα ακυρωθεί και τα υπόλοιπα των λογαριασμών «$from» και «$to» θα επανέλθουν.';
  }

  @override
  String get txnsTitle => 'Κινήσεις';

  @override
  String get txnsSearchHint => 'Αναζήτηση';

  @override
  String get filterAll => 'Όλες';

  @override
  String get filterExpenses => 'Έξοδα';

  @override
  String get filterIncome => 'Έσοδα';

  @override
  String get txnsSwipeHint => 'Σύρε αριστερά μια κίνηση για επεξεργασία ή διαγραφή';

  @override
  String get txnsEmpty => 'Δεν βρέθηκαν κινήσεις.';

  @override
  String get transferTitle => 'Μεταφορά';

  @override
  String transferRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String txnSemantics(String title, String subtitle, String amount) {
    return '$title, $subtitle, $amount';
  }

  @override
  String get recurringTitle => 'Επαναλαμβανόμενα';

  @override
  String get recurringMonthlyLabel => 'ΠΑΓΙΑ / ΜΗΝΑ';

  @override
  String recurringShareOfIncome(int percent) {
    return '$percent% του εισοδήματος';
  }

  @override
  String get recurringNext7Days => 'Επόμενες 7 ημέρες';

  @override
  String get recurringListTitle => 'Συνδρομές & πάγια';

  @override
  String recurringActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count ενεργά', one: '1 ενεργό');
    return '$_temp0';
  }

  @override
  String freqMonthly(String day) {
    return 'Μηνιαία, $day';
  }

  @override
  String freqEveryNMonths(int count) {
    return 'Κάθε $count μήνες';
  }

  @override
  String freqWeekly(String weekday) {
    return 'Κάθε $weekday';
  }

  @override
  String freqYearly(String date) {
    return 'Ετήσια, $date';
  }

  @override
  String dueIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'σε $count μέρες',
      one: 'αύριο',
      zero: 'σήμερα',
    );
    return '$_temp0';
  }

  @override
  String get recurringPaused => 'Σε παύση';

  @override
  String get recurringNew => 'Νέο επαναλαμβανόμενο';

  @override
  String get recurringEdit => 'Επεξεργασία επαναλαμβανόμενου';

  @override
  String get recurringEmpty => 'Δεν υπάρχουν επαναλαμβανόμενες κινήσεις ακόμα.';

  @override
  String recurringToggle(String name) {
    return '$name: ενεργό';
  }

  @override
  String recurringDueDaySemantics(String day, String names) {
    return '$day: $names';
  }

  @override
  String get fieldName => 'Όνομα';

  @override
  String get fieldAmount => 'Ποσό';

  @override
  String get fieldFrequency => 'Συχνότητα';

  @override
  String get fieldFirstDue => 'Επόμενη χρέωση';

  @override
  String get freqOptionMonthly => 'Μηνιαία';

  @override
  String get freqOptionEveryN => 'Κάθε N μήνες';

  @override
  String get freqOptionWeekly => 'Εβδομαδιαία';

  @override
  String get freqOptionYearly => 'Ετήσια';

  @override
  String get fieldIntervalMonths => 'Κάθε πόσους μήνες';

  @override
  String get recurringDelete => 'Διαγραφή επαναλαμβανόμενου';

  @override
  String get accountsTitle => 'Λογαριασμοί';

  @override
  String get accountsTotalLabel => 'ΣΥΝΟΛΙΚΟ ΥΠΟΛΟΙΠΟ';

  @override
  String get accountsTransfer => 'Μεταφορά';

  @override
  String get accountsNew => 'Νέος';

  @override
  String get accountTypeBank => 'Τρεχούμενος';

  @override
  String get accountTypeCard => 'Κάρτα';

  @override
  String get accountTypeCash => 'Μετρητά';

  @override
  String get accountTypeSavings => 'Αποταμίευση';

  @override
  String get accountTypeBankHint => 'Τραπεζικός λογαριασμός';

  @override
  String get accountTypeCardHint => 'Χρεωστική ή πιστωτική';

  @override
  String get accountTypeCashHint => 'Πορτοφόλι';

  @override
  String get accountTypeSavingsHint => 'Κουμπαράς / ταμιευτήριο';

  @override
  String get accountSubBank => 'Τράπεζα';

  @override
  String accountSubBankLast4(String last4) {
    return 'Τράπεζα · ••$last4';
  }

  @override
  String accountSubCredit(String limit, String date) {
    return 'Όριο $limit · λήξη $date';
  }

  @override
  String accountSubCreditNoDate(String limit) {
    return 'Όριο $limit';
  }

  @override
  String get accountSubCard => 'Χρεωστική κάρτα';

  @override
  String get accountSubCash => 'Πορτοφόλι';

  @override
  String accountSubSavingsGoal(String goal, int percent) {
    return 'Στόχος $goal · $percent%';
  }

  @override
  String get accountSubSavings => 'Κουμπαράς';

  @override
  String get accountNegativeSemantics => 'αρνητικό υπόλοιπο';

  @override
  String get transferFrom => 'ΑΠΟ';

  @override
  String get transferTo => 'ΠΡΟΣ';

  @override
  String get transferNote => 'Οι μεταφορές δεν μετράνε ως έσοδα ή έξοδα.';

  @override
  String transferSubmit(String amount) {
    return 'Μεταφορά $amount';
  }

  @override
  String get transferSwap => 'Αντιστροφή λογαριασμών';

  @override
  String get transferNeedsTwo => 'Χρειάζεσαι τουλάχιστον δύο λογαριασμούς για μεταφορά.';

  @override
  String get newAccountTitle => 'Νέος λογαριασμός';

  @override
  String get editAccountTitle => 'Επεξεργασία λογαριασμού';

  @override
  String get fieldAccountType => 'Τύπος';

  @override
  String get fieldOpeningBalance => 'Αρχικό υπόλοιπο';

  @override
  String get fieldIsCredit => 'Πιστωτική κάρτα';

  @override
  String get fieldCreditLimit => 'Όριο';

  @override
  String get fieldStatementDay => 'Ημέρα λήξης';

  @override
  String get fieldLast4 => 'Τελευταία 4 ψηφία';

  @override
  String get fieldSavingsGoal => 'Στόχος';

  @override
  String get fieldOptional => '(προαιρετικό)';

  @override
  String get accountArchiveConfirm => 'Ο λογαριασμός έχει κινήσεις, οπότε θα αρχειοθετηθεί.';

  @override
  String get categoriesTitle => 'Κατηγορίες';

  @override
  String categoryLimit(String amount) {
    return 'Όριο $amount';
  }

  @override
  String get categoryNoLimit => 'Χωρίς όριο';

  @override
  String txnCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count κινήσεις', one: '1 κίνηση');
    return '$_temp0';
  }

  @override
  String get newCategoryTitle => 'Νέα κατηγορία';

  @override
  String get editCategoryTitle => 'Επεξεργασία κατηγορίας';

  @override
  String get categoryNameLabel => 'ΟΝΟΜΑ';

  @override
  String get categoryNameHint => 'π.χ. Κατοικίδιο';

  @override
  String get categoryColor => 'Χρώμα';

  @override
  String get categoryIcon => 'Εικονίδιο';

  @override
  String get categoryMonthlyLimit => 'Μηνιαίο όριο';

  @override
  String get categoryCreate => 'Δημιουργία κατηγορίας';

  @override
  String get categoryKindExpense => 'Έξοδα';

  @override
  String get categoryKindIncome => 'Έσοδα';

  @override
  String get categoryArchivedNotice => 'Η κατηγορία έχει κινήσεις, οπότε αρχειοθετήθηκε.';

  @override
  String get categoryDeleteOrArchive => 'Διαγραφή κατηγορίας';

  @override
  String get categoryReorderHint => 'Κράτησε πατημένο για αλλαγή σειράς';

  @override
  String get colorLime => 'Λάιμ';

  @override
  String get colorCoral => 'Κοραλί';

  @override
  String get colorSky => 'Γαλάζιο';

  @override
  String get colorViolet => 'Μωβ';

  @override
  String get colorAmber => 'Κεχριμπαρί';

  @override
  String get colorTeal => 'Τιρκουάζ';

  @override
  String get colorPink => 'Ροζ';

  @override
  String get colorGrey => 'Γκρι';

  @override
  String get iconCart => 'Καλάθι';

  @override
  String get iconFood => 'Φαγητό';

  @override
  String get iconCar => 'Αυτοκίνητο';

  @override
  String get iconHome => 'Σπίτι';

  @override
  String get iconFilm => 'Ψυχαγωγία';

  @override
  String get iconHeart => 'Καρδιά';

  @override
  String get iconGift => 'Δώρο';

  @override
  String get iconPlane => 'Ταξίδι';

  @override
  String get iconBook => 'Βιβλίο';

  @override
  String get iconShirt => 'Ρούχα';

  @override
  String get iconBolt => 'Ρεύμα';

  @override
  String get iconSalary => 'Χαρτοφύλακας';

  @override
  String get iconLaptop => 'Υπολογιστής';

  @override
  String get iconTag => 'Ετικέτα';

  @override
  String get catGroceries => 'Σούπερ μάρκετ';

  @override
  String get catDining => 'Εστίαση';

  @override
  String get catBills => 'Λογαριασμοί';

  @override
  String get catTransport => 'Μετακίνηση';

  @override
  String get catEntertainment => 'Ψυχαγωγία';

  @override
  String get catHousing => 'Στέγαση';

  @override
  String get catSalary => 'Μισθός';

  @override
  String get catFreelance => 'Freelance';

  @override
  String get catGift => 'Δώρο';

  @override
  String get catOther => 'Άλλο';

  @override
  String get settingsTitle => 'Περισσότερα';

  @override
  String get settingsSectionData => 'Δεδομένα';

  @override
  String get settingsSectionApp => 'Εφαρμογή';

  @override
  String get settingsIncome => 'Εισόδημα και ημέρα πληρωμής';

  @override
  String get settingsTheme => 'Θέμα';

  @override
  String get themeSystem => 'Σύστημα';

  @override
  String get themeDark => 'Σκούρο';

  @override
  String get themeLight => 'Φωτεινό';

  @override
  String get settingsBiometric => 'Κλείδωμα με Face ID';

  @override
  String get settingsCurrency => 'Νόμισμα';

  @override
  String get currencyEur => 'EUR · Ευρώ';

  @override
  String get settingsExportCsv => 'Εξαγωγή CSV';

  @override
  String get settingsReset => 'Επαναφορά δεδομένων';

  @override
  String get resetDialogTitle => 'Επαναφορά δεδομένων;';

  @override
  String get resetDialogBody =>
      'Θα διαγραφούν όλες οι κινήσεις, οι λογαριασμοί, οι κατηγορίες και τα επαναλαμβανόμενα. Η ενέργεια δεν αναιρείται.';

  @override
  String get resetConfirm => 'Επαναφορά';

  @override
  String get exportEmpty => 'Δεν υπάρχουν κινήσεις για εξαγωγή.';

  @override
  String get exportSubject => 'Pulse — κινήσεις';

  @override
  String get biometricUnavailable => 'Η συσκευή δεν υποστηρίζει βιομετρικό κλείδωμα.';

  @override
  String get biometricReason => 'Ξεκλείδωσε για να δεις τα οικονομικά σου';

  @override
  String get lockTitle => 'Το Pulse είναι κλειδωμένο';

  @override
  String get lockUnlock => 'Ξεκλείδωμα';

  @override
  String get incomeSheetTitle => 'Εισόδημα και ημέρα πληρωμής';

  @override
  String onbStep(int step, int total) {
    return 'ΒΗΜΑ $step ΑΠΟ $total';
  }

  @override
  String onbProgress(int step, int total) {
    return 'Πρόοδος ρύθμισης: βήμα $step από $total';
  }

  @override
  String get onbIncomeTitle => 'Πόσα μπαίνουν κάθε μήνα;';

  @override
  String get onbIncomeSubtitle => 'Με βάση αυτό προτείνουμε όρια και υπολογίζουμε πόσα μπορείς να ξοδεύεις κάθε μέρα.';

  @override
  String get onbIncomeLabel => 'Μηνιαίο καθαρό εισόδημα';

  @override
  String get onbPaydayQuestion => 'Πότε πληρώνεσαι;';

  @override
  String get paydayFirst => '1η του μήνα';

  @override
  String get paydayFifteenth => '15η';

  @override
  String get paydayLast => 'Τέλος μήνα';

  @override
  String get paydayOther => 'Άλλη';

  @override
  String paydayCustomValue(String day) {
    return '$day του μήνα';
  }

  @override
  String get paydayGroup => 'Ημέρα πληρωμής';

  @override
  String get onbPaydayHelper => 'Ο «μήνας» στο app θα ξεκινά από αυτή την ημέρα.';

  @override
  String get onbLimitsTitle => 'Όρισε όρια ανά κατηγορία';

  @override
  String get onbLimitsSubtitle => 'Ξεκίνα με τις προτάσεις μας. Θα μπορείς να τα αλλάξεις όποτε θέλεις.';

  @override
  String get onbLeftForSavings => 'Μένουν για αποταμίευση';

  @override
  String get onbAccountsTitle => 'Πού κρατάς τα χρήματά σου;';

  @override
  String get onbAccountsSubtitle => 'Διάλεξε τους λογαριασμούς σου, για να βλέπεις το υπόλοιπο του καθενός.';

  @override
  String stepperDecrease(String name) {
    return 'Μείωση ορίου για $name';
  }

  @override
  String stepperIncrease(String name) {
    return 'Αύξηση ορίου για $name';
  }

  @override
  String get selected => 'επιλεγμένο';

  @override
  String placeholderScreen(String name) {
    return '$name — σύντομα';
  }
}
