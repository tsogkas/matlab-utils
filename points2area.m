function area = points2area(x,y)

assert(length(x) == length(y), 'x-y dimension mismatch')
x = x - x(1);
y = y - y(1);
area = x(1:end-1)' * y(2:end) - x(2:end)' * y(1:end-1);
area = abs(area/2);