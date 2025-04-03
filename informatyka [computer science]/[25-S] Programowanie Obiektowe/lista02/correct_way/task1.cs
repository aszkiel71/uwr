using System;
using System.Text;


public class IntStream
{
    protected int current;

    public IntStream()
    {
        current = 0;
    }


    public virtual int Next()
    {
        if (Eos())
        {
            throw new InvalidOperationException("Koniec strumienia.");
        }
        return current++;
    }


    public virtual bool Eos()
    {
        return current < 0; 
    }

  
    public virtual void Reset()
    {
        current = 0;
    }
}


public class FibStream : IntStream
{
    private int prev1;
    private int prev2;

    public FibStream()
    {
        Reset();
    }

    public override int Next()
    {
        if (Eos())
        {
            throw new InvalidOperationException("Koniec strumienia Fibonacciego.");
        }

        int result = prev1;
        int nextFib = prev1 + prev2;
        prev1 = prev2;
        prev2 = nextFib;

        return result;
    }

    public override bool Eos()
    {
        return prev2 < 0;
    }

    public override void Reset()
    {
        prev1 = 0;
        prev2 = 1;
    }
}


public class RandomStream : IntStream
{
    private Random random;

    public RandomStream()
    {
        random = new Random();
    }

    public override int Next()
    {
        return random.Next();
    }

    public override bool Eos()
    {
        return false;
    }


}


public class RandomWordStream
{
    private FibStream fibStream;
    private RandomStream randomStream;
    private const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    public RandomWordStream()
    {
        fibStream = new FibStream();
        randomStream = new RandomStream();
    }

    public string Next()
    {
        int length = fibStream.Next();
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < length; i++)
        {
            sb.Append(chars[randomStream.Next() % chars.Length]);
        }

        return sb.ToString();
    }
}


class Program
{
    static void Main()
    {

        Console.WriteLine("Strumień Fibonacciego:");
        FibStream fs = new FibStream();
        for (int i = 0; i < 10; i++)
        {
            Console.WriteLine(fs.Next());
        }

        Console.WriteLine("\nStrumień losowy:");
        RandomStream rs = new RandomStream();
        for (int i = 0; i < 5; i++)
        {
            Console.WriteLine(rs.Next());
        }

        Console.WriteLine("\nStrumień losowych stringów o długościach Fibonacciego:");
        RandomWordStream rws = new RandomWordStream();
        for (int i = 0; i < 5; i++)
        {
            Console.WriteLine(rws.Next());
        }
    }
}