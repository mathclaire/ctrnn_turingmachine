function stateparams=state_network_v2(flag_net,params)
%w is connection matrix
%ml and mr say whether connections move tape right or left


if flag_net==1
    %just regular GH
    nn=3; %size of original graph
    %-------------------------------------
    % input the connections in the original graph
    %-------------------------------------
    e0=[[0,1,0];[0,0,1];[1,0,0]];     %connectivity matrix for network transitions which are excited by a zero on the tape
    e1=zeros(3);     %conectivity matrix for network transitions which are excited by a one on the tape
    %-------------------------------------
    %what happens to the tape along each connection in the original graph
    %-------------------------------------
    mr=[[0,1,0];[0,0,1];[0,0,0]]; %matrix of connections which make the tape move right
    ml=[[0,0,0];[0,0,0];[1,0,0]]; %matrix of connections which make the tape move left
    %-------------------------------------
    %which symbols are written
    %-------------------------------------
    w0=zeros(3); %matrix of connections which write a zero to the tape
    w1=[[0,1,0];[0,0,1];[1,0,0]]; %matrix of connections which write a one to the tape
    
    
elseif flag_net==2
    %busy beaver
    nn=4; %size of original graph
    %-------------------------------------
    % input the connections in the original graph
    %-------------------------------------
    e0=[[0,1,0,0];[1,0,0,0];[0,1,0,0];[0,0,0,0]];     %connectivity matrix for network transitions which are excited by a zero on the tape
    e1=[[0,0,1,0];[0,1,0,0];[0,0,0,1];[0,0,0,0]];     %conectivity matrix for network transitions which are excited by a one on the tape
    %-------------------------------------
    %what happens to the tape along each connection in the original graph
    %-------------------------------------
    mr=[[0,1,0,0];[0,1,0,0];[0,0,0,1];[0,0,0,0]]; %matrix of connections which make the tape move right
    ml=[[0,0,1,0];[1,0,0,0];[0,1,0,0];[0,0,0,0]]; %matrix of connections which make the tape move left
    %-------------------------------------
    %which symbols are written
    %-------------------------------------
    w0=zeros(4); %matrix of connections which write a zero to the tape
    w1=[[0,1,1,0];[1,1,0,0];[0,1,0,1];[0,0,0,0]]; %matrix of connections which write a one to the tape

elseif flag_net==3
    %perpetual four-state machine
    nn=4;
    %-------------------------------------
    % input the connections in the original graph
    %-------------------------------------
    e0=[[0,1,0,0];[0,0,1,0];[0,0,0,1];[1,0,0,0]];     %connectivity matrix for network transitions which are excited by a zero on the tape
    e1=[[0,0,0,1];[1,0,0,0];[0,1,0,0];[0,0,1,0]];     %conectivity matrix for network transitions which are excited by a one on the tape
    %-------------------------------------
    %what happens to the tape along each connection in the original graph
    %-------------------------------------
    mr=[[0,0,0,0];[1,0,1,0];[0,0,0,0];[1,0,1,0]]; %matrix of connections which make the tape move right
    ml=[[0,1,0,1];[0,0,0,0];[0,1,0,1];[0,0,0,0]]; %matrix of connections which make the tape move left
    %-------------------------------------
    %which symbols are written
    %-------------------------------------
    w0=zeros(4); %matrix of connections which write a zero to the tape
    w1=[[0,1,0,1];[1,0,1,0];[0,1,0,1];[1,0,1,0]]; %matrix of connections which write a one to the tape
   
elseif flag_net==4
    %copy routine
    % note that we have added a move right, and a write 1 instruction to
    % the 1->H connection otherwise the matrices don't all match up. This
    % isn't in the original design but doesn't affect anything except the
    % end position of the head.

    nn=6;
     %-------------------------------------
    % input the connections in the original graph
    %-------------------------------------
    e0=[[0,0,0,0,0,1];[0,0,1,0,0,0];[0,0,0,1,0,0];[0,0,0,0,1,0];[1,0,0,0,0,0];[0,0,0,0,0,0]];     %connectivity matrix for network transitions which are excited by a zero on the tape
    e1=[[0,1,0,0,0,0];[0,1,0,0,0,0];[0,0,1,0,0,0];[0,0,0,1,0,0];[0,0,0,0,1,0];[0,0,0,0,0,0]];      %conectivity matrix for network transitions which are excited by a one on the tape
    %-------------------------------------
    %what happens to the tape along each connection in the original graph
    %-------------------------------------
    mr=[[0,1,0,0,0,1];[0,1,1,0,0,0];[0,0,1,0,0,0];[0,0,0,0,0,0];[1,0,0,0,0,0];[0,0,0,0,0,0]];  %matrix of connections which make the tape move right
    ml=[[0,0,0,0,0,0];[0,0,0,0,0,0];[0,0,0,1,0,0];[0,0,0,1,1,0];[0,0,0,0,1,0];[0,0,0,0,0,0]];  %matrix of connections which make the tape move left
    %-------------------------------------
    %which symbols are written
    %-------------------------------------
    w0=[[0,1,0,0,0,1];[0,0,1,0,0,0];[0,0,0,0,0,0];[0,0,0,0,1,0];[0,0,0,0,0,0];[0,0,0,0,0,0]];   %matrix of connections which write a zero to the tape
    w1=[[0,0,0,0,0,0];[0,1,0,0,0,0];[0,0,1,1,0,0];[0,0,0,1,0,0];[1,0,0,0,1,0];[0,0,0,0,0,0]];   %matrix of connections which write a zero to the tape

end


%-------------------------------------
%need to classify connections as R0/R1/L0/L1
r0=mr.*w0;
l0=ml.*w0;
r1=mr.*w1;
l1=ml.*w1;


Ae=e0+e1;
Am=mr+ml;
Aw=w0+w1;
if (Ae==Am & Ae==Aw)
    A=Ae;
else
    fprintf('There is an error in the graph information you have input!')
end


%-------------------------------------
%we add two extra states along every edge
%-------------------------------------

%how many connections?
n_conn=sum(sum(A));

ntot=nn+2*n_conn;

%connections in the full network are one of three types
stateparams.e0=zeros(ntot); %excited by a zero
stateparams.e1=zeros(ntot); %excited by a one
stateparams.a=zeros(ntot); %automatic

%some of the states (the new ones) provide inputs to the tape network
stateparams.r0=zeros(ntot,1); %move the tape right, write a zero
stateparams.r1=zeros(ntot,1); %move the tape right, write a one
stateparams.l0=zeros(ntot,1); %move the tape left, write a zero
stateparams.l1=zeros(ntot,1); %move the tape left, write a one

jnew=nn+1; %this is where we start counting the new nodes
for j=1:nn
    for k=1:nn
        if A(j,k)==1
            %we need two new nodes
            if e0(j,k)==1
                stateparams.e0(j,jnew)=1;
            elseif e1(j,k)==1
                stateparams.e1(j,jnew)=1;
            end
            stateparams.a(jnew,jnew+1)=1;
            stateparams.a(jnew+1,k)=1;
            
            %note: only the first of the two new nodes excites the tape
            %network.
            if r0(j,k)==1
                stateparams.r0(jnew)=1;
            elseif r1(j,k)==1
                stateparams.r1(jnew)=1;
            elseif l0(j,k)==1
                stateparams.l0(jnew)=1;
            elseif l1(j,k)==1
                stateparams.l1(jnew)=1;
            else
                fprintf('there is an error in your setup');
            end
            
            jnew=jnew+2; %next new node to be created.
            
        end
    end
end

%which nodes to push when tape reads zero/one
stateparams.zeroe=sum(stateparams.e0,1)';
stateparams.onee=sum(stateparams.e1,1)';

stateparams.A=stateparams.e0+stateparams.e1+stateparams.a;

AAe=stateparams.e0+stateparams.e1; %all excitable connections
AAa=stateparams.a; %all automatic connections

wt=params.wt_n;

stateparams.w=wt*ones(ntot)+(params.ws-wt)*eye(ntot)+(params.wp_ne-wt)*AAe'+(params.wp_na-wt)*AAa'+(params.wm-wt)*(AAe+AAa);


%
%
%
%
%