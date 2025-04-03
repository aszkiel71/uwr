using System;
using System.Collections.Generic;

public class KolejneSlowaFibonacciego
{
    private string s1;
    private string s2;
    private int currentIndex;


    public KolejneSlowaFibonacciego()
    {
        s1 = "a";
        s2 = "b";
        currentIndex = 1;
    }


    public KolejneSlowaFibonacciego(string slowo1, string slowo2)
    {
        s1 = slowo1;
        s2 = slowo2;
        currentIndex = 1;
    }


    public string Next()
    {
        string result;
        if (currentIndex == 1)
        {
            result = s1;
        }
        else if (currentIndex == 2)
        {
            result = s2;
        }
        else
        {
            result = s2 + s1;
            s1 = s2;
            s2 = result;
        }
        currentIndex++;
        return result;
    }
}

public class JakiesSlowoFibonacciego
{
    private string s1;
    private string s2;
    private Dictionary<int, string> cache;

    public JakiesSlowoFibonacciego()
    {
        s1 = "a";
        s2 = "b";
        cache = new Dictionary<int, string>();
        cache[1] = s1;
        cache[2] = s2;
    }

    public JakiesSlowoFibonacciego(string slowo1, string slowo2)
    {
        s1 = slowo1;
        s2 = slowo2;
        cache = new Dictionary<int, string>();
        cache[1] = s1;
        cache[2] = s2;
    }

    public string Slowo(int i)
    {
        if (cache.ContainsKey(i))
        {
            return cache[i];
        }

        for (int n = cache.Count + 1; n <= i; n++)
        {
            cache[n] = cache[n - 1] + cache[n - 2];
        }

        return cache[i];
    }
}

class Program
{
    static void Main()
    {
        Console.WriteLine("Kolejne słowa Fibonacciego:");
        KolejneSlowaFibonacciego ksf = new KolejneSlowaFibonacciego();
        for (int i = 1; i <= 10; i++)
        {
            Console.WriteLine(ksf.Next());
        }

        Console.WriteLine("\nPojedyncze słowo Fibonacciego:");
        JakiesSlowoFibonacciego jsf = new JakiesSlowoFibonacciego();
        Console.WriteLine("10. słowo Fibonacciego: " + jsf.Slowo(10));
    }
}