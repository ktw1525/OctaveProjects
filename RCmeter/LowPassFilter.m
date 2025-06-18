function y = LowPassFilter(data, R, C, dt)
    alpha = dt ./ (R .* C + dt);
    y = zeros(size(data));
    y(1) = data(1);
    for n = 2:length(data)
        y(n) = (1 - alpha(n)) * y(n-1) + alpha(n) * data(n);
    end
endfunction
