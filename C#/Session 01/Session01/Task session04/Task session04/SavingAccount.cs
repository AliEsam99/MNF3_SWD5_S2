using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Task_session04
{
    internal class SavingAccount : Account
    {
        public SavingAccount(decimal accountBalance, DateTime _DateOpened , Decimal _InterestRate) : base(accountBalance, _DateOpened)
        {
            InterestRate = _InterestRate;
        }

        public Decimal InterestRate { get; set; }

        public override decimal calculteInterest()
        {
            return (AccountBalance * InterestRate / 100);
        }
    }
}
