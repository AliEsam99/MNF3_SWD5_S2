using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Task_session04
{
    public class Transaction
    {
        public DateTime TimeStamp { get; set; }
        public Decimal Amount { get; set; }
        public string Description { get; set; }



        public override string ToString()
        {
            return $"TimeStamp: {TimeStamp} |amount: {Amount}| Description: {Description}";
        }
    }
}
