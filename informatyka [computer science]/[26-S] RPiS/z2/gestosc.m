function y = gestosc(x, m, k)
    licznik = (m^(m/2)) * (k^(k/2)) * (x.^(m/2 - 1));
    mianownik = beta_fun(m/2, k/2) * ((m.*x + k).^((m+k)/2));
    y = licznik ./ mianownik;
end
