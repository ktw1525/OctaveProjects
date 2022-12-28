function result = combination(n,r)
%조합 nCr을 구하는 함수.
result = factorial(n)/factorial(r)/factorial(n-r);
end