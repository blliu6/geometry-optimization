n = input("Please enter n:");
tic;
t1 = cputime;
x = sdpvar(n-3, 1);
y = sdpvar(n-3, 1);

f = 1;
for i = 1:n - 4
    f = f + 0.5 * (x(i) * y(i+1) - x(i+1) * y(i));
end

vx = [0, 0, 1];
vy = [1, 0, 0];
for i = 1:n - 3
    vx = [vx, x(i)];
    vy = [vy, y(i)];
end

con = [];
for i = 1:n - 2
    for j = i + 1:n - 1
        for k = j + 1:n
            g = vx(i) * vy(j) + vx(k) * vy(i) + vx(j) * vy(k) - vx(k) * vy(j) - vx(j) * vy(i) - vx(i) * vy(k);
            con = [con, g >=  0];
        end
    end
end

for i = 1:n - 3
    con = [con, x(i) - 1 >=  0, y(i) - 1 >=  0];
end

ax = [0, 1];
ay = [0, 0];
for i = 1:n - 3
    ax = [ax, x(i)];
    ay = [ay, y(i)];
end
ax = [ax, 0, 0];
ay = [ay, 1, 0];

for i = 1:n - 1
    con = [con, ax(i) * ay(i+1) - ax(i) * ay(i+2) - ax(i+1) * ay(i) + ax(i+2) * ay(i) + ax(i+1) * ay(i+2) - ax(i+2) * ay(i+1) - 1== 0];
end

ops = sdpsettings('solver', 'bmibnb', 'bmibnb.maxiter', 1e18, 'bmibnb.relgaptol', 1e-8, 'bmibnb.absgaptol', 1e-8, 'bmibnb.maxtime', 1e18);
res = optimize(con, f, ops);
toc;
if res.problem == 0
    xx = value(x);
    yy = value(y);
    sol = value(f);
    fprintf('The minimum value is %f\n', sol);
elseif res.problem == 1
    disp('Solver thinks it is infeasible');
else
    disp('Something else happened');
end
