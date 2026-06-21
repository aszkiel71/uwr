function y = gamma_fun(n)
    if mod(n, 1) == 0
        y = factorial(n - 1);
    else
        k = n - 0.5;
        y = (factorial(2*k) / (4^k * factorial(k))) * sqrt(pi);
    end
end
