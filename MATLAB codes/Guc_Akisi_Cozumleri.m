% Sistem Verileri
P2 = -2.3; Q2 = -1.3;
P3 = -2.0; Q3 = -1.2394;
P4 = 2.38;
V4_mag = 1.02;

% Empedanslar ve Admitanslar
z12 = 0.010080 + 1i*0.050400; y12 = 1/z12;
z13 = 0.007440 + 1i*0.037200; y13 = 1/z13;
z24 = 0.007440 + 1i*0.037200; y24 = 1/z24;
z34 = 0.012720 + 1i*0.063600; y34 = 1/z34;

% Admitans Toplamları (Yii - diagonal dışı)
Y22 = y12 + y24;
Y33 = y13 + y34;
Y44 = y24 + y34;

% Başlangıç Değerleri
V1 = 1.0 + 0i;
V2 = 1.0 + 0i;
V3 = 1.0 + 0i;
V4 = 1.02 + 0i;

iter = 0;
max_iter = 100;
tol = 1e-5;

for k = 1:max_iter
    V2_old = V2; V3_old = V3; V4_old = V4;

    % Bara 2 (PQ)
    V2 = ( (P2 - 1i*Q2)/conj(V2) + y12*V1 + y24*V4 ) / Y22;

    % Bara 3 (PQ)
    V3 = ( (P3 - 1i*Q3)/conj(V3) + y13*V1 + y34*V4 ) / Y33;

    % Bara 4 (PV)
    % 1. Q Hesabı: Q = -Imag{V* . I}
    % Bara 4'ten çıkan akım I4 = (V4-V2)y24 + (V4-V3)y34
    Current4 = (V4 - V2)*y24 + (V4 - V3)*y34;
    S4_calc = V4 * conj(Current4);
    Q4_calc = imag(S4_calc);

    % 2. V4 Güncelleme
    V4_temp = ( (P4 - 1i*Q4_calc)/conj(V4) + y24*V2 + y34*V3 ) / Y44;

    % 3. Genlik Sabitleme
    V4 = V4_mag * (real(V4_temp) + 1i*imag(V4_temp)) / abs(V4_temp);

    % Hata Kontrolü
    err = max([abs(V2-V2_old), abs(V3-V3_old), abs(V4-V4_old)]);
    if err < tol
        break;
    end
end

% SONUÇLAR
fprintf('\n--- SONUÇLAR ---\n');
fprintf('V2: %.4f pu, Açı: %.4f derece\n', abs(V2), angle(V2)*180/pi);
fprintf('V3: %.4f pu, Açı: %.4f derece\n', abs(V3), angle(V3)*180/pi);
fprintf('V4: %.4f pu, Açı: %.4f derece\n', abs(V4), angle(V4)*180/pi);

% Q4 Üretimi (Net Q4 + Load Q4)
% Q4_calc, bara 4'ten şebekeye giren net güçtür.
fprintf('Bara 4 Net Reaktif Güç (Q4_net): %.4f pu\n', Q4_calc);
fprintf('Bara 4 Generatör Q (Q_gen4): %.4f MVAr\n', (Q4_calc*100 + 49.58));

% Güç Akışları 
% S12 = V1 * conj((V1-V2)*y12)
%Hat 1-2
S12 = V1 * conj((V1-V2)*y12) * 100;
S21 = V2 * conj((V2-V1)*y12) * 100;
Loss12 = S12 + S21;
%%Hat 1-3
S13 = V1 * conj((V1-V3)*y13) * 100;
S31 = V3 * conj((V3-V1)*y13) * 100;
Loss13 = S13 + S31;
%Hat 2-4
S24 = V2 * conj((V2-V4)*y24) * 100;
S42 = V4 * conj((V4-V2)*y24) * 100;
Loss24 = S24 + S42;
%Hat 3-4
S34 = V3 * conj((V3-V4)*y34) * 100;
S43 = V4 * conj((V4-V3)*y34) * 100;
Loss34 = S34 + S43;

fprintf('\nHat 1-2 Kayıp (MW + jMVar): %.4f + j%.4f\n', real(Loss12), imag(Loss12));
fprintf('Hat 1-3 Kayıp (MW + jMVar): %.4f + j%.4f\n', real(Loss13), imag(Loss13));
fprintf('Hat 2-4 Kayıp (MW + jMVar): %.4f + j%.4f\n', real(Loss24), imag(Loss24));
fprintf('Hat 3-4 Kayıp (MW + jMVar): %.4f + j%.4f\n', real(Loss34), imag(Loss34));