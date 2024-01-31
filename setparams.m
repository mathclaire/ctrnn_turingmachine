function params=setparams()


%------------------
params.n_t=10;   %how long to make tape

%------------------
%integration time
params.tfin=1500;
%------------------
%parameters for noisy integration
params.dt=0.01;
params.thin=1;

%set parameters;

%------------------
params.K=20;
params.theta=0.5;
params.ws=1; 
params.wm=-0.5;


%wp and wt for tape/symbol network 
params.wp_ta=0.31; %automatic wp for tape/symbol network
params.wp_te=0.29; %excitable wp for tape/symbol network
params.wt_t=-0.3;

%wp and wt for state network
params.wp_na=0.31; %automatic wp for network 
params.wp_ne=0.29; %excitable wp for network
params.wt_n=-0.3;

%------------------
params.zeta_beta=0.02; %to push position of tape
params.zeta_gamma=0.05; %to push symbol on tape
params.zeta_state=0.03; %to push states %increasing makes non-automatic transitions faster
%------------------
params.eta=0.005; %noise level 

%------------------



