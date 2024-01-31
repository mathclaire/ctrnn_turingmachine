%run ctrnn turing machine


%----------------------------------------------------------
%choose network
flag_net=4;
%GH=1; busy beaver=2; perpetual 4-state=3; copy routine=4
%----------------------------------------------------------
%noisy or deterministic?
flag_noisy=0;
%deterministic =0; noisy=1;

%----------------------------------------------------------
params=setparams();
%----------------------------------------------------------

params.stateparams=state_network_v2(flag_net,params);

params.tapeparams=tape_network_v2(params);

%----------------------------------------------------------
%size of network
params.nn=size(params.stateparams.w,1);

%size of tape network
params.nb=params.tapeparams.n_tsn*params.n_t;

%-------------------------------------------------------

%total system size
params.n=params.nn+params.nb;


%-------------------------------------------------------
stateinit=[1;0.05*rand(params.nn-1,1)]; %start at state 1

tapestart=3; %starting tape position

tapeinit=0.05*rand(params.tapeparams.n_tsn,params.n_t);

%all tape symbols start at zero.
for j=1:params.n_t


    if flag_net==4
        %copy routine
        if j==tapestart
            tapeinit(7,j)=1; %turn on the "active" one symbol at the tapestart position
        elseif j==tapestart+1
            tapeinit(8,j)=1; %turn on the "inactive" one symbol at the tapestart+1 position (so initially have two ones on the tape)
        elseif j==tapestart+2
            tapeinit(8,j)=1; %turn on the "inactive" one symbol at the tapestart+1 position (so initially have three ones on the tape)
        else
            tapeinit(2,j)=1; %turn on the "inactive" zero symbol at all other positions.
        end

    else

        if j==tapestart
            tapeinit(1,tapestart)=1; %turn on the "active" zero symbol at the tapestart position
        else
            tapeinit(2,j)=1; %turn on the "inactive" zero symbol at all other positions.
        end

    end


end

tapeinit=reshape(tapeinit,params.nb,1);

yinit=[stateinit;tapeinit];


%----------------------------------------------------------

options = odeset('RelTol',1e-8,'AbsTol',1e-8);

if flag_noisy==0
    [T,Y] = ode45(@(t,y) ctrnn_turing(t,y,params),[0 params.tfin],yinit,options);
    T=T';
    Y=Y';
elseif flag_noisy==1
    [T,Y] = heun(@ctrnn_turing,[0 params.tfin],yinit,params);
end


%----------------------------------------------------------
s=sigma_ctrnn(Y,params);
sn=s(1:params.nn,:); %sigma of the "network" states"
bn=s(params.nn+1:params.nn+params.nb,:); %sigma of the "tape" states


figure();
plot(T,Y(1:params.nn,:),'LineWidth',2) %states
legend
title('States')

