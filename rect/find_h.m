function [h] = find_h(e)
ev=e(2);
eu=e(1);
h=[1 0 0;-ev/eu 1 0;-1/eu 0 1];
end