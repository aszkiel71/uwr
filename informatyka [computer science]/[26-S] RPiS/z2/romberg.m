function I = romberg(f, a, b, tol)
    R = zeros(15, 15);
    h = b - a;
    R(1,1) = h/2 * (f(a) + f(b));
    for i = 2:15
        h = h / 2;
        suma = 0;
        for k = 1:2^(i-2)
            suma = suma + f(a + (2*k - 1)*h);
        end
        R(i,1) = 0.5 * R(i-1,1) + h * suma;
        for j = 2:i
            R(i,j) = R(i,j-1) + (R(i,j-1) - R(i-1,j-1)) / (4^(j-1) - 1);
        end
        if abs(R(i,i) - R(i-1,i-1)) < tol
            I = R(i,i);
            return;
        end
    end
    I = R(15,15);
end
