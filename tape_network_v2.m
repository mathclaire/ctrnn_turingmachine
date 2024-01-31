function tapeparams=tape_network_v2(params)

tapeparams.n_tsn=8;

%build the symbol and tape network. Each position on the tape corresponds
%to a network with 8 nodes. 

%Numbering of nodes with labels in fig
% 1 0
% 2 0' %primed positions are "inactive"
% 3 0R
% 4 1R
% 5 0L
% 6 1L
% 7 1
% 8 1'


%base unit (automatic) 
Aa=zeros(tapeparams.n_tsn);
%list of connections
lout=[3,5,4,6];
lin= [2,2,8,8];
for j=1:length(lout)
    Aa(lout(j),lin(j))=1;
end

%base unit (excitable)
Ae=zeros(tapeparams.n_tsn);
%list of connections
lout=[1,1,1,1,2,7,7,7,7,8];
lin= [3,4,5,6,1,3,4,5,6,7];
for j=1:length(lout)
    Ae(lout(j),lin(j))=1;
end

%which nodes give a push to the right and left tape position
tapeparams.right_push=[0,0,1,1,0,0,0,0]';
tapeparams.left_push=[0,0,0,0,1,1,0,0]';

%which nodes give push to the 'excited by 0/1' connections in the state
%network
tapeparams.zero_push=[1,0,0,0,0,0,0,0]';
tapeparams.one_push=[0,0,0,0,0,0,1,0]';

%which directions are excited by 0R/1R/0L/1L transitions in the state
%network
tapeparams.zeroRe=[0,0,1,0,0,0,0,0]';
tapeparams.oneRe=[0,0,0,1,0,0,0,0]';
tapeparams.zeroLe=[0,0,0,0,1,0,0,0]';
tapeparams.oneLe=[0,0,0,0,0,1,0,0]';

%which directions are excited by L/R pushes from neighbouring tape subnets
tapeparams.movehead=[1,0,0,0,0,0,1,0]';

%8x8 w for each 8-node symbol network (each one is independent of the
%others)
wt=params.wt_t;
w10=wt*ones(tapeparams.n_tsn)+(params.ws-wt)*eye(tapeparams.n_tsn)+(params.wp_te-wt)*Ae'+(params.wp_ta-wt)*Aa'+(params.wm-wt)*(Ae+Aa);

tapeparams.w10=w10;

