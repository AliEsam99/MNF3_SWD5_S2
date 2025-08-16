using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Task_session04
{
    public class CurrentAccount : Account
    {
        public Decimal OverDraftLimit { get; set; }
        public CurrentAccount(decimal accountBalance, DateTime _DateOpened , Decimal _OverDraftLimit) : base(accountBalance, _DateOpened)
        {
            OverDraftLimit = _OverDraftLimit;
        }
        public override decimal calculteOverDraft()
        {
            return (OverDraftLimit + AccountBalance);
        }
        public override void Withdraw(decimal amount)
        {
            if (amount <= 0)
                Console.WriteLine("Invalid withdraw amount");
            else if (amount <= AccountBalance + OverDraftLimit)
            {
                AccountBalance -= amount;
                Transactions.Add(new Transaction { TimeStamp = DateTime.Now, Amount = -amount, Description = "Withdraw (Current)" });
            }
            else
                Console.WriteLine("Exceeds overdraft limit");
        }   
    }
}
