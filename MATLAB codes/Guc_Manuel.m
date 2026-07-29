clc; clear;

%% -----------------------------
%% Ybus Matrix
%% -----------------------------
Y = [
  8.987-1j*44.939  -3.816+1j*19.082  -5.171+1j*25.857   0;
 -3.816+1j*19.082   8.987-1j*44.939   0                -5.171+1j*25.857;
 -5.171+1j*25.857   0                8.195-1j*40.979  -3.024+1j*15.122;
  0               -5.171+1j*25.857  -3.024+1j*15.122   8.195-1j*40.979
];

%% -----------------------------
%% Power Data (pu)
%% -----------------------------
P = [0; -2.3; -2.0; 2.38];
Q = [0; -1.3; -1.2394; 0];

%% -----------------------------
%% Initial Voltages
%% -----------------------------
V = [1+0j; 1+0j; 1+0j; 1+0j];  % Slack & PV magnitude = 1

tol = 1e-6;
itermax = 100;

%% -----------------------------
%% GAUSS-SEIDEL ITERATION
%% -----------------------------
for iter = 1:itermax
    V_old = V;

    % ---- PQ Buses (2 & 3) ----
    for i = 2:3
        sumYV = 0;
        for k = 1:4
            if k ~= i
                sumYV = sumYV + Y(i,k)*V(k);
            end
        end
        V(i) = (1/Y(i,i))*((P(i)-1j*Q(i))/conj(V(i)) - sumYV);
    end

    % ---- PV Bus (4) ----
    i = 4;
    I4 = Y(i,:) * V;
    Q(i) = -imag(conj(V(i))*I4);

    sumYV = 0;
    for k = 1:4
        if k ~= i
            sumYV = sumYV + Y(i,k)*V(k);
        end
    end

    V(i) = (1/Y(i,i))*((P(i)-1j*Q(i))/conj(V(i)) - sumYV);
    V(i) = 1 * exp(1j*angle(V(i)));  % |V4| = 1 pu

    % ---- Convergence ----
    if max(abs(V - V_old)) < tol
        fprintf('Converged in %d iterations\n', iter);
        break;
    end
end

%% -----------------------------
%% RESULTS
%% -----------------------------
Vm = abs(V);
Va = angle(V)*180/pi;

disp('Voltage Magnitudes (pu)');
disp(Vm)

disp('Voltage Angles (deg)');
disp(Va)

disp('Reactive Power at Bus 4 (pu)');
disp(Q(4))
