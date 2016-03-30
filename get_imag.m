function get_imag()
RL = 3.3e3; 
f = 400e3;
w = 2*pi*f;
syms L1 C1
Zeq = @(L1,C1) 1j.*w.*L1+RL./(1+1j.*w.*RL.*C1);
L1 = 0:10e-6:1e-3;
C1 = 0:1e-6:100e-6;
[L11,C11] = meshgrid(L1,C1);
surf(L11,C11,real(Zeq(L11,C11)));