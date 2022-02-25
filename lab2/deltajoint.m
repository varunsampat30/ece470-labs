function err = deltajoint(delta)

kuka = mykuka_search(delta);
   
% calibration measurements
X1 = [356.84  -293.57  28.71]';
X2 = [738.32    15.61  30.60]';
X3 = [371.61   248.00  30.50]';    
Q1 = [-0.9461   0.9776   -0.6482   -0.9721    1.3806    0.2704];
Q2 = [0.0400    0.5145    0.2967    0.0578    0.7606   -0.0419];
Q3 = [0.8589    1.0057   -0.6969    0.8826    1.3710   -0.2368];


H1 = forward_kuka(Q1, kuka);
H2 = forward_kuka(Q2, kuka);
H3 = forward_kuka(Q3, kuka);

% current calibration error
err = norm(H1(1:3,4)-X1) + norm(H2(1:3,4)-X2) + norm(H3(1:3,4)-X3);

end