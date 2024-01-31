
function sigma=sigma_ctrnn(y,params)
%will work for vector y if all the thetas are allowed to be the same
theta=params.theta;
K=params.K;

sigma=1./(1+exp(-K*(y-theta)));

