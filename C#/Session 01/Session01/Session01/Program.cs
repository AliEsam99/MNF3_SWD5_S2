namespace Session01
{
    using System;

    class Program
    {
        static void Main()
        {
            Console.WriteLine("Hello!");
            Console.Write("Input the first number: ");
            if (!double.TryParse(Console.ReadLine(), out double num1))
            {
                Console.WriteLine("Invalid input. Exiting.");
                return;
            }

            Console.Write("Input the second number: ");
            if (!double.TryParse(Console.ReadLine(), out double num2))
            {
                Console.WriteLine("Invalid input. Exiting.");
                return;
            }

            Console.WriteLine("What do you want to do with those numbers?");
            Console.WriteLine("[A]dd\n[S]ubtract\n[M]ultiply");
            string choice = Console.ReadLine().Trim().ToUpper();

            switch (choice)
            {
                case "A":
                    Console.WriteLine($"{num1} + {num2} = {num1 + num2}");
                    break;
                case "S":
                    Console.WriteLine($"{num1} - {num2} = {num1 - num2}");
                    break;
                case "M":
                    Console.WriteLine($"{num1} * {num2} = {num1 * num2}");
                    break;
                default:
                    Console.WriteLine("Invalid option");
                    break;
            }

            Console.WriteLine("Press any key to close");
            Console.ReadKey();
        }
    }

}
