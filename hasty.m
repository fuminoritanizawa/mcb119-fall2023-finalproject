%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Repressilator ODE function for modleing lambda phage (c1, rcsA); Hasty et
% al. 2001 doi.org/10.1063/1.1345702
% Author: Fumi Tanizawa, Ethan Goroza
% Date:   2023-12-02
% Called by: mcb_final_2023fall.m
% Other routines needed: None.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dx = hasty(t, x, p)
    %differential equation for concentration of c1(x)
    dx =  p(1)* ((1 + x^2 + p(2) * p(3) * x^4) / (1 + x^2 + p(3) * x^4 + p(3) * p(4) * x^6)) - (p(5) * x + p(6) * x * p(7));

% p(1)=m;
% p(2)=alpha;
% p(3)=sigma1;
% p(4)=sigma2;
% p(5)=gamma_x;
% p(6)=gamma_xy;
% p(7)=y;