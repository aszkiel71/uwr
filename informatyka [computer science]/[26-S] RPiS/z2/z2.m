function p = z2(x, m, k)
    if x <= 0
        p = 0;
        return;
    end
    p = romberg(@(t) gestosc(t, m, k), 0, x, 1e-6);
end
