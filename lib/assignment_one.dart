// Interface for interest-bearing accounts
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

  // getters
  int get accountNumber => _accountNumber;
  String get accountHolder => _accountHolder;
  double get balance => _balance;

  set accountHolder(String name) {
    _accountHolder = name;
  }

  // abstract methods
  void deposit(double amount);
  void withdraw(double amount);

  // display method
  void displayInfo() {
    print("Account No: $_accountNumber");
    print("Holder: $_accountHolder");
    print("Balance: \$$_balance");
    print("                              ");
  }

  // helper to change balance safely
  void updateBalance(double newBalance) {
    _balance = newBalance;
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
    print(
      "Applied interest \$${interest.toStringAsFixed(2)} to Savings Account.",
    );
  }
}

//  Checking Account
class CheckingAccount extends BankAccount {
  static const double overdraftFee = 35;

  CheckingAccount(int accNo, String holder, double bal)
    : super(accNo, holder, bal);

  @override
  void deposit(double amount) {
    updateBalance(balance + amount);
    print("Deposited \$${amount} in Checking Account.");
  }

  @override
  void withdraw(double amount) {
    updateBalance(balance - amount);
    if (balance < 0) {
      updateBalance(balance - overdraftFee);
      print("Overdraft! \$35 fee applied.");
    }
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
    print("Deposited \$${amount} in Premium Account.");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < minBalance) {
      print("Cannot go below minimum balance (\$10,000).");
      return;
    }
    updateBalance(balance - amount);
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
    print(
      "Applied interest \$${interest.toStringAsFixed(2)} to Premium Account.",
    );
  }
}

// Bank Class
class Bank {
  List<BankAccount> accounts = [];

  // create new account
  void createAccount(BankAccount account) {
    accounts.add(account);
    print("Created new ${account.runtimeType} for ${account.accountHolder}");
  }

  // find account by number
  BankAccount? findAccount(int accNo) {
    for (var acc in accounts) {
      if (acc.accountNumber == accNo) return acc;
    }
    return null;
  }

  // transfer between accounts
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

  void report() {
    print("---- Bank Report -----");
    for (var acc in accounts) {
      acc.displayInfo();
    }
  }
}
