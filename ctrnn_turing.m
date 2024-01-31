function dy=ctrnn_turing(t,y,params);

dy=zeros(params.n,1);

%size of state network
nn=params.nn;

%size of tape network
nb=params.nb;

%size of tape subnetwork
tsn=params.tapeparams.n_tsn;

s=sigma_ctrnn(y,params); 
sn=s(1:nn); %sigma of the "network" states"
bn=s(nn+1:nn+nb); %sigma of the "tape" states

bn_x=reshape(bn,tsn,params.n_t);
y_x=reshape(y(nn+1:nn+nb),tsn,params.n_t);


%------------------------------------------------------------------
%state equations
%------------------------------------------------------------------


%scalars which are 1 when the tape is writing a zero/one
tapezero=sum(sum(bn_x,2).*params.tapeparams.zero_push);
tapeone=sum(sum(bn_x,2).*params.tapeparams.one_push);

zeropert=tapezero*params.stateparams.zeroe;
onepert=tapeone*params.stateparams.onee;

state_pert=params.zeta_state*(zeropert+onepert);

dy(1:nn)=-y(1:nn)+params.stateparams.w*sn+state_pert;


%------------------------------------------------------------------
%tape equations
%------------------------------------------------------------------
%perturbations from the state network
l0_pert=sn'*params.stateparams.l0*(params.tapeparams.zeroLe);
r0_pert=sn'*params.stateparams.r0*(params.tapeparams.zeroRe);
l1_pert=sn'*params.stateparams.l1*(params.tapeparams.oneLe);
r1_pert=sn'*params.stateparams.r1*(params.tapeparams.oneRe);
tot_pert=l0_pert+r0_pert+l1_pert+r1_pert;

%perturbations from the neighbouring tape networks (note that perts don't
%work at ends of tape)
right_pert=zeros(size(bn_x));
left_pert=right_pert;
j=1;
bnj=bn_x(:,j);
right_pert(:,j+1)=bnj'*params.tapeparams.right_push*(params.tapeparams.movehead);
for j=2:params.n_t-1
   bnj=bn_x(:,j);
   right_pert(:,j+1)=bnj'*params.tapeparams.right_push*(params.tapeparams.movehead);
   left_pert(:,j-1)= bnj'*params.tapeparams.left_push*(params.tapeparams.movehead);
end
j=params.n_t;
bnj=bn_x(:,j);
left_pert(:,j-1)= bnj'*params.tapeparams.left_push*(params.tapeparams.movehead);

dy_x=zeros(size(bn_x));
for j=1:params.n_t
    pert=params.zeta_gamma*tot_pert+params.zeta_beta*(right_pert(:,j)+left_pert(:,j));
%if j==6
%    figure(20)
%    hold on
%    plot(t,pert,'.')
%end

    dy_x(:,j)=-y_x(:,j)+params.tapeparams.w10*bn_x(:,j)+pert;    
end


dy(nn+1:nn+nb)=reshape(dy_x,nb,1);

