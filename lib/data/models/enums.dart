/// Persisted by name in the database and in JSON; never reorder-sensitive.
enum AccountType { bank, card, cash, savings }

enum CategoryKind { expense, income }

enum TxnKind { expense, income, transfer }

enum Frequency { monthly, everyNMonths, weekly, yearly }
