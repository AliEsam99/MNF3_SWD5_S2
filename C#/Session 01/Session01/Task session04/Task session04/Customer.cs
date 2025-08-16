using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Task_session04
{
    public class Customer
    {
        private static int _counter = 1;
        public  int Id { get; set; }
        public string FName { get; set; }
        public string LName { get; set; }

        public int NationalId { get; set; }
        public DateTime Date_Of_Birth { get; set; }
        public List<Account> Accounts { get; set; } = new List<Account>();

        public Customer(string _FName , string _LName , int _NationalId , DateTime _Date_Of_Birth)
        {
            Id = ++_counter;
            FName = _FName;
            LName = _LName;
            NationalId = _NationalId;
            Date_Of_Birth = _Date_Of_Birth;
        }

        public void Update_Customers_Details(string FirstName , string LastName , DateTime date)
        {
            FName = FirstName;
            LName = LastName;
            Date_Of_Birth = date;
        }
        public override string ToString()
        {
            return $"Id {Id} , FirstName{FName}, LastName{LName} , Date Of Birth {Date_Of_Birth} , National Id {NationalId}";
        }
        public string SearchByName(string FirstName , string LastName)
        {
            if(FirstName == FName && LastName == LName)
            {
                return ToString();
            }
            else
            {
                return "no result";
            }
        }

        public string SearchById(int _Id)
        {
            if(!(_Id == Id))
            {
                return "invalid";
            }
            else
            {
                return ToString() ;
            }
        }

        public void UpdateCustomerDetails(string firstName, string lastName, DateTime date)
        {
            FName = firstName;
            LName = lastName;
            Date_Of_Birth = date;
        }

        public decimal GetTotalBalance()
        {
            return Accounts.Sum(B => B.AccountBalance);
        }

    }
}
