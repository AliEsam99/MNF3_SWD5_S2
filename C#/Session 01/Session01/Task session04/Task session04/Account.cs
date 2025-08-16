using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using Task_session04;

namespace Task_session04
{
    public class Account
    {
        private static int _counter = 1000;
        public  int AccountNumber { get; set; }
        public Decimal AccountBalance { get; set; }
        public DateTime DateOpened { get; set; }
        public List<Transaction> Transactions { get; set; } = new List<Transaction>();


        public Account(decimal accountBalance, DateTime _DateOpened)
        {
            AccountNumber = ++_counter;
            AccountBalance = accountBalance;
            DateOpened = _DateOpened;

        }
        public void Deposit(decimal Money)
        {
            if (Money <= 0)
            {
                Console.WriteLine("invalid input");
            }
            else
            {
                AccountBalance += Money;
                Transactions.Add(new Transaction { TimeStamp = DateTime.Now, Amount = Money, Description = "Deposit" });
            }
        }

        public virtual void Withdraw(decimal amount)
        {
            if(amount < AccountBalance)
            {
                AccountBalance = AccountBalance - amount;
                Transactions.Add(new Transaction { TimeStamp = DateTime.Now, Amount = amount, Description = "Withdraw" });        }
            else
            {
                Console.WriteLine("the amount is grater than balance");
            }
        }
        public virtual decimal calculteInterest()
        {
            return 0;
        }

        public virtual decimal calculteOverDraft()
        {
            return 0;
        }

        public void ShowTransactions()
        {
            Console.WriteLine($"Transaction History for Account {AccountNumber}:");
            foreach (var transaction in Transactions)
                Console.WriteLine(transaction);
        }
        public void Transfer(Account toAccount, decimal amount)
        {
            if (amount > 0 && amount <= AccountBalance)
            {
                this.Withdraw(amount);
                toAccount.Deposit(amount);
                Transactions.Add(new Transaction { TimeStamp = DateTime.Now, Amount = -amount, Description = $"Transfer to {toAccount.AccountNumber}" });
            }
            else
            {
                Console.WriteLine("Transfer not allowed");
            }
        }
    }

}

