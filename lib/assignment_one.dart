// --- : Interface for interest-bearing accounts
abstract class InterestBearing {
  double calculateInterest();
  void applyInterest();
}

// Abstract base class BankAccount
abstract class BankAccount {
  int _accountNumber;
  String _accountHolder;
  double _balance;
  List<String> _transactions = [];

  BankAccount(this._accountNumber, this._accountHolder, this._balance);

  int get accountNumber => _accountNumber;
  String get accountHolder => _accountHolder;
  double get balance => _balance;

  set accountHolder(String name) {
    _accountHolder = name;
  }

  void deposit(double amount);
  void withdraw(double amount);

  void displayInfo() {
    print("Account No: $_accountNumber");
    print("Holder: $_accountHolder");
    print("Balance: \$${_balance.toStringAsFixed(2)}");
    print("---------------------------");
  }

  void updateBalance(double newBalance) {
    _balance = newBalance;
  }

  void addTransaction(String t) {
    _transactions.add(t);
  }

  void showTransactions() {
    print("Transaction History for $accountHolder:");
    if (_transactions.isEmpty) {
      print("No transactions yet.");
    } else {
      for (var t in _transactions) {
        print(t);
      }
    }
    print("---------------------------");
  }
}

// Savings Account
class SavingsAccount extends BankAccount implements InterestBearing {
  int _withdrawCount = 0;
  static const double minBalance = 500;
  static const double interestRate = 0.02;

  SavingsAccount(int accNo, String holder, double bal)
    : super(accNo, holder, bal);

  @override
  void deposit(double amount) {
    updateBalance(balance + amount);
    addTransaction("Deposited \$${amount}");
    print("Deposited \$${amount} in Savings Account.");
  }

  @override
  void withdraw(double amount) {
    if (_withdrawCount >= 3) {
      print("You reached withdrawal limit (3 per month).");
      return;
    }
    if (balance - amount < minBalance) {
      print("Cannot withdraw below minimum balance (\$500).");
      return;
    }
    updateBalance(balance - amount);
    _withdrawCount++;
    addTransaction("Withdrew \$${amount}");
    print("Withdrew \$${amount} from Savings Account.");
  }

  @override
  double calculateInterest() {
    return balance * interestRate;
  }

  @override
  void applyInterest() {
    double interest = calculateInterest();
    updateBalance(balance + interest);
    addTransaction("Applied interest \$${interest.toStringAsFixed(2)}");
    print(
      "Applied interest \$${interest.toStringAsFixed(2)} to Savings Account.",
    );
  }
}

// Checking Account
class CheckingAccount extends BankAccount {
  static const double overdraftFee = 35;

  CheckingAccount(int accNo, String holder, double bal)
    : super(accNo, holder, bal);

  @override
  void deposit(double amount) {
    updateBalance(balance + amount);
    addTransaction("Deposited \$${amount}");
    print("Deposited \$${amount} in Checking Account.");
  }

  @override
  void withdraw(double amount) {
    updateBalance(balance - amount);
    if (balance < 0) {
      updateBalance(balance - overdraftFee);
      addTransaction("Overdraft fee applied \$${overdraftFee}");
      print("Overdraft! \$35 fee applied.");
    }
    addTransaction("Withdrew \$${amount}");
    print("Withdrew \$${amount} from Checking Account.");
  }
}

// Premium Account
class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000;
  static const double interestRate = 0.05;

  PremiumAccount(int accNo, String holder, double bal)
    : super(accNo, holder, bal);

  @override
  void deposit(double amount) {
    updateBalance(balance + amount);
    addTransaction("Deposited \$${amount}");
    print("Deposited \$${amount} in Premium Account.");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < minBalance) {
      print("Cannot go below minimum balance (\$10,000).");
      return;
    }
    updateBalance(balance - amount);
    addTransaction("Withdrew \$${amount}");
    print("Withdrew \$${amount} from Premium Account.");
  }

  @override
  double calculateInterest() {
    return balance * interestRate;
  }

  @override
  void applyInterest() {
    double interest = calculateInterest();
    updateBalance(balance + interest);
    addTransaction("Applied interest \$${interest.toStringAsFixed(2)}");
    print(
      "Applied interest \$${interest.toStringAsFixed(2)} to Premium Account.",
    );
  }
}

// Student Account
class StudentAccount extends BankAccount implements InterestBearing {
  static const double maxBalance = 5000;
  static const double interestRate = 0.01;

  StudentAccount(int accNo, String holder, double bal)
    : super(accNo, holder, bal);

  @override
  void deposit(double amount) {
    if (balance + amount > maxBalance) {
      print("Cannot deposit. Exceeds maximum balance (\$5,000).");
      return;
    }
    updateBalance(balance + amount);
    addTransaction("Deposited \$${amount}");
    print("Deposited \$${amount} in Student Account.");
  }

  @override
  void withdraw(double amount) {
    if (amount > balance) {
      print("Insufficient funds.");
      return;
    }
    updateBalance(balance - amount);
    addTransaction("Withdrew \$${amount}");
    print("Withdrew \$${amount} from Student Account.");
  }

  @override
  double calculateInterest() {
    return balance * interestRate;
  }

  @override
  void applyInterest() {
    double interest = calculateInterest();
    updateBalance(balance + interest);
    addTransaction("Applied interest \$${interest.toStringAsFixed(2)}");
    print(
      "Applied interest \$${interest.toStringAsFixed(2)} to Student Account.",
    );
  }
}

// Bank Class
class Bank {
  List<BankAccount> accounts = [];

  void createAccount(BankAccount account) {
    accounts.add(account);
    print("Created new ${account.runtimeType} for ${account.accountHolder}");
  }

  BankAccount? findAccount(int accNo) {
    for (var acc in accounts) {
      if (acc.accountNumber == accNo) return acc;
    }
    return null;
  }

  void transfer(int fromAcc, int toAcc, double amount) {
    var from = findAccount(fromAcc);
    var to = findAccount(toAcc);

    if (from == null || to == null) {
      print("Account not found!");
      return;
    }

    print(
      "Transferring \$${amount} from ${from.accountNumber} to ${to.accountNumber}",
    );
    from.withdraw(amount);
    to.deposit(amount);
  }

  void applyMonthlyInterest() {
    print("=== Applying monthly interest to all interest-bearing accounts ===");
    for (var acc in accounts) {
      if (acc is InterestBearing) {
        (acc as InterestBearing).applyInterest(); // cast is required
      }
    }
  }

  void report() {
    print("---- Bank Report -----");
    for (var acc in accounts) {
      acc.displayInfo();
    }
  }
}
