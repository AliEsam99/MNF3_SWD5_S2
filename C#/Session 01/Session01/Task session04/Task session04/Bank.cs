using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Task_session04
{
    public class Bank
    {
        public string Name { get; set; }
        public string BranchCode { get; set; }
        public List<Customer> Customers { get; set; } = new List<Customer>();

        public Bank(string name, string branchCode)
        {
            Name = name;
            BranchCode = branchCode;
        }

        public void AddCustomer(Customer  customer)
        {
            Customers.Add(customer);
        }

        public void RemoveCustomer(int id)
        {
            var customer = Customers.FirstOrDefault(c => c.Id == id);
            if (customer == null)
                Console.WriteLine("Customer not found.");
            else if (customer.GetTotalBalance() != 0)
                Console.WriteLine("Cannot remove customer with non-zero balance.");
            else
                Customers.Remove(customer);
        }
        public Customer FindCustomerByNationalId(int nationalId)
        {
            return Customers.FirstOrDefault(N => N.Id == nationalId);
        }

        public Customer FindCustomerByName(string name)
        { 
           return Customers.FirstOrDefault(c => (c.FName + " " + c.LName).Contains(name, StringComparison.OrdinalIgnoreCase));
        }

        public void ShowReport()
        {
            Console.WriteLine($" Bank Report: {Name} (Branch {BranchCode})");
            foreach (var c in Customers)
            {
                Console.WriteLine(c);
                foreach (var acc in c.Accounts)
                {
                    Console.WriteLine($"Account {acc.AccountNumber}, Balance: {acc.AccountBalance}, Opened: {acc.DateOpened}");
                }
            }
        }
    }

}
