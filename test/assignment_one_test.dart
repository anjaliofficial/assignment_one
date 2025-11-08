import 'package:assignment_one/assignment_one.dart';

void main() {
  Bank bank = Bank();

  var s1 = SavingsAccount(1234567890123456, "Anjali Bista", 1000);
  var c1 = CheckingAccount(2345678901234567, "Apala Sharma", 300);
  var p1 = PremiumAccount(3456789012345678, "Sneha Thapa", 15000);

  bank.createAccount(s1);
  bank.createAccount(c1);
  bank.createAccount(p1);

  s1.deposit(200);
  s1.withdraw(100);
  s1.withdraw(200);
  s1.withdraw(300); // Savings withdraw → will reach limit of 3
  s1.applyInterest(); // Apply 2% interest

  c1.withdraw(400); // Checking withdraw → may trigger overdraft
  p1.withdraw(6000);
  p1.applyInterest(); // Apply 5% interest

  // Transfer money from Savings to Checking
  bank.transfer(1234567890123456, 2345678901234567, 100);
  bank.report();
}
