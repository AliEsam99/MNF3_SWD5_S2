namespace Task_session04
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Bank bank = new Bank("AliBank", "001");

            while (true)
            {
                Console.WriteLine("\n=== Bank System Menu ===");
                Console.WriteLine("1. Add Customer");
                Console.WriteLine("2. Open Account");
                Console.WriteLine("3. Deposit");
                Console.WriteLine("4. Withdraw");
                Console.WriteLine("5. Transfer");
                Console.WriteLine("6. Show Bank Report");
                Console.WriteLine("7. Show Account Transactions");
                Console.WriteLine("8. Update Customer");
                Console.WriteLine("9. Remove Customer");
                Console.WriteLine("0. Exit");
                Console.Write("Choose: ");

                string choice = Console.ReadLine();
                switch (choice)
                {
                    case "1": // Add Customer
                        Console.Write("First Name: ");
                        string fn = Console.ReadLine();
                        Console.Write("Last Name: ");
                        string ln = Console.ReadLine();
                        Console.Write("National Id: ");
                        int nid = int.Parse(Console.ReadLine());
                        Console.Write("Date of Birth (yyyy-mm-dd): ");
                        DateTime dob = DateTime.Parse(Console.ReadLine());
                        bank.AddCustomer(new Customer(fn, ln, nid, dob));
                        Console.WriteLine("Customer Added!");
                        break;

                    case "2": // Open Account
                        Console.Write("Customer Id: ");
                        int cid = int.Parse(Console.ReadLine());
                        var cust = bank.Customers.FirstOrDefault(c => c.Id == cid);
                        if (cust == null) { Console.WriteLine("Not found!"); break; }
                        Console.Write("Account Type (1=Saving, 2=Current): ");
                        string t = Console.ReadLine();
                        Console.Write("Initial Balance: ");
                        decimal bal = decimal.Parse(Console.ReadLine());
                        if (t == "1")
                        {
                            Console.Write("Interest Rate: ");
                            decimal rate = decimal.Parse(Console.ReadLine());
                            cust.Accounts.Add(new SavingAccount(bal, DateTime.Now, rate));
                        }
                        else
                        {
                            Console.Write("Overdraft Limit: ");
                            decimal od = decimal.Parse(Console.ReadLine());
                            cust.Accounts.Add(new CurrentAccount(bal, DateTime.Now, od));
                        }
                        Console.WriteLine("Account opened!");
                        break;

                    case "3": // Deposit
                        Console.Write("Account Number: ");
                        int accNumD = int.Parse(Console.ReadLine());
                        var accD = bank.Customers.SelectMany(c => c.Accounts).FirstOrDefault(a => a.AccountNumber == accNumD);
                        if (accD == null)
                        {
                            Console.WriteLine("Not found!");
                        }
                        else
                        {
                            break;
                        }
                        
                        
                        Console.Write("Amount: ");
                        decimal damt = decimal.Parse(Console.ReadLine());
                        accD.Deposit(damt);
                        Console.WriteLine("Deposit done.");
                        break;

                    case "4": // Withdraw
                        Console.Write("Account Number: ");
                        int accNumW = int.Parse(Console.ReadLine());
                        var accW = bank.Customers.SelectMany(c => c.Accounts).FirstOrDefault(a => a.AccountNumber == accNumW);
                        if (accW == null) { Console.WriteLine("Not found!"); break; }
                        Console.Write("Amount: ");
                        decimal wamt = decimal.Parse(Console.ReadLine());
                        accW.Withdraw(wamt);
                        Console.WriteLine("Withdraw done.");
                        break;

                    case "5": // Transfer
                        Console.Write("From Account: ");
                        int from = int.Parse(Console.ReadLine());
                        Console.Write("To Account: ");
                        int to = int.Parse(Console.ReadLine());
                        Console.Write("Amount: ");
                        decimal tamt = decimal.Parse(Console.ReadLine());
                        var accFrom = bank.Customers.SelectMany(c => c.Accounts).FirstOrDefault(a => a.AccountNumber == from);
                        var accTo = bank.Customers.SelectMany(c => c.Accounts).FirstOrDefault(a => a.AccountNumber == to);
                        if (accFrom == null || accTo == null) { Console.WriteLine("Invalid accounts"); break; }
                        accFrom.Transfer(accTo, tamt);
                        Console.WriteLine("Transfer done.");
                        break;

                    case "6": // Report
                        bank.ShowReport();
                        break;

                    case "7": // Transactions
                        Console.Write("Account Number: ");
                        int accNumT = int.Parse(Console.ReadLine());
                        var accT = bank.Customers.SelectMany(c => c.Accounts).FirstOrDefault(a => a.AccountNumber == accNumT);
                        if (accT == null) { Console.WriteLine("Not found!"); break; }
                        accT.ShowTransactions();
                        break;

                    case "8": // Update Customer
                        Console.Write("Customer Id: ");
                        int uid = int.Parse(Console.ReadLine());
                        var uc = bank.Customers.FirstOrDefault(c => c.Id == uid);
                        if (uc == null) { Console.WriteLine("Not found!"); break; }
                        Console.Write("New First Name: ");
                        string nfn = Console.ReadLine();
                        Console.Write("New Last Name: ");
                        string nln = Console.ReadLine();
                        Console.Write("New DOB (yyyy-mm-dd): ");
                        DateTime ndob = DateTime.Parse(Console.ReadLine());
                        uc.UpdateCustomerDetails(nfn, nln, ndob);
                        Console.WriteLine("Customer updated!");
                        break;

                    case "9": // Remove Customer
                        Console.Write("Customer Id: ");
                        int rid = int.Parse(Console.ReadLine());
                        bank.RemoveCustomer(rid);
                        break;

                    case "0": 
                        return;

                    default:
                        Console.WriteLine("Invalid choice");
                        break;
                }
            }
        }
    }
}

