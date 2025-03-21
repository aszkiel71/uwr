using System;
using System.Collections.Generic;

public abstract class Formula
{
    public abstract bool oblicz(Dictionary<string, bool> s);
    public abstract Formula simplify();
    public abstract override string ToString();
}

public class Stala : Formula
{
    private bool value;
    public Stala(bool value)
    {
        this.value = value;
    }

    public override bool oblicz(Dictionary<string, bool> s)
    {
        return value;
    }

    public override Formula simplify()
    {
        return this;
    }

    public override string ToString()
    {
        return value ? "true" : "false";
    }
}

public class Zmienna : Formula
{
    private string name;

    public Zmienna(string name)
    {
        this.name = name;
    }

    public override bool oblicz(Dictionary<string, bool> s)
    {
        if (s.ContainsKey(name))
            return s[name];
        throw new ArgumentException($"Zmienna '{name}' nie istnieje.");
    }

    public override Formula simplify()
    {
        return this;
    }

    public override string ToString()
    {
        return name;
    }
}

public class Not : Formula
{
    private Formula formula;

    public Not(Formula formula)
    {
        this.formula = formula;
    }

    public override bool oblicz(Dictionary<string, bool> s)
    {
        return !formula.oblicz(s);
    }

    public override Formula simplify()
    {
        Formula simplified = formula.simplify();

        if (simplified is Stala stala)
        {
            Formula result = new Stala(!stala.oblicz(new Dictionary<string, bool>()));
            Console.WriteLine($"{this} ≡ {result}");
            return result;
        }

        if (simplified is Not not)
        {
            Console.WriteLine($"{this} ≡ {not.formula}");
            return not.formula;
        }
        return new Not(simplified);
    }

    public override string ToString()
    {
        return $"¬({formula})";
    }
}

public class And : Formula
{
    private Formula arg1;
    private Formula arg2;

    public And(Formula arg1, Formula arg2)
    {
        this.arg1 = arg1;
        this.arg2 = arg2;
    }

    public override bool oblicz(Dictionary<string, bool> s)
    {
        return arg1.oblicz(s) && arg2.oblicz(s);
    }

    public override Formula simplify()
    {
        Formula arg1Sim = arg1.simplify();
        Formula arg2Sim = arg2.simplify();

        if (arg1Sim is Stala arg1Stala && !arg1Stala.oblicz(new Dictionary<string, bool>()))
        {
            Console.WriteLine($"{this} ≡ false");
            return new Stala(false);
        }

        if (arg2Sim is Stala arg2Stala && !arg2Stala.oblicz(new Dictionary<string, bool>()))
        {
            Console.WriteLine($"{this} ≡ false");
            return new Stala(false);
        }

        if (arg1Sim is Stala arg1StalaTrue && arg1StalaTrue.oblicz(new Dictionary<string, bool>()))
        {
            Console.WriteLine($"{this} ≡ {arg2Sim}");
            return arg2Sim;
        }

        if (arg2Sim is Stala arg2StalaTrue && arg2StalaTrue.oblicz(new Dictionary<string, bool>()))
        {
            Console.WriteLine($"{this} ≡ {arg1Sim}");
            return arg1Sim;
        }

        return new And(arg1Sim, arg2Sim);
    }

    public override string ToString()
    {
        return $"({arg1} ∧ {arg2})";
    }
}

public class Or : Formula
{
    private Formula arg1;
    private Formula arg2;

    public Or(Formula arg1, Formula arg2)
    {
        this.arg1 = arg1;
        this.arg2 = arg2;
    }

    public override bool oblicz(Dictionary<string, bool> s)
    {
        return arg1.oblicz(s) || arg2.oblicz(s);
    }

    public override Formula simplify()
    {
        Formula arg1Sim = arg1.simplify();
        Formula arg2Sim = arg2.simplify();

        if (arg1Sim is Stala arg1Stala && arg1Stala.oblicz(new Dictionary<string, bool>()))
        {
            Console.WriteLine($"{this} ≡ true");
            return new Stala(true);
        }

        if (arg2Sim is Stala arg2Stala && arg2Stala.oblicz(new Dictionary<string, bool>()))
        {
            Console.WriteLine($"{this} ≡ true");
            return new Stala(true);
        }

        if (arg1Sim is Stala arg1StalaFalse && !arg1StalaFalse.oblicz(new Dictionary<string, bool>()))
        {
            Console.WriteLine($"{this} ≡ {arg2Sim}");
            return arg2Sim;
        }

        if (arg2Sim is Stala arg2StalaFalse && !arg2StalaFalse.oblicz(new Dictionary<string, bool>()))
        {
            Console.WriteLine($"{this} ≡ {arg1Sim}");
            return arg1Sim;
        }

        return new Or(arg1Sim, arg2Sim);
    }

    public override string ToString()
    {
        return $"({arg1} ∨ {arg2})";
    }
}

class Program
{
    static void Main(string[] args)
    {
        Dictionary<string, bool> vars = new Dictionary<string, bool>
        {
            { "p", false },
            { "x", true },
            { "y", false },
            { "z", true },
            { "w", false }
        };

        Formula f1 = new Or(new Stala(false), new Zmienna("p"));
        Console.WriteLine("Przyklad: false ∨ p");
        Console.WriteLine("Wynik: " + f1.oblicz(vars));
        Console.WriteLine("Po uproszczeniu: ");
        Formula f1Simplified = f1.simplify();
        Console.WriteLine("Wynik uproszczonej: " + f1Simplified.oblicz(vars));
        Console.WriteLine();
        

        Formula f2 = new Or(new Stala(false), new Stala(true));
        Console.WriteLine("Przyklad: false ∨ true");
        Console.WriteLine("Wynik: " + f2.oblicz(vars));
        Console.WriteLine("Po uproszczeniu: ");
        Formula f2Simplified = f2.simplify();
        Console.WriteLine("Wynik uproszczonej: " + f2Simplified.oblicz(vars));
        Console.WriteLine();
        
        Formula f3 = new And(
            new Or(new Zmienna("x"), new Zmienna("y")),
            new Or(new Zmienna("x"), new Zmienna("z"))
        );
        
        Console.WriteLine("Przyklad 9: (x ∨ y) ∧ (x ∨ z)");
        Console.WriteLine("Wynik: " + f3.oblicz(vars));
        Console.WriteLine("Po uproszczeniu: ");
        Formula f3Simplified = f3.simplify();
        Console.WriteLine("Wynik uproszczonej: " + f3Simplified.oblicz(vars));
        Console.WriteLine();
        
    }
}
