%% four countries case with actual data
%%% First, run "RetreiveBilateral_InvoicingRatio.m" to obtain 'inv_uni' and 'TotalV'
%%% Note: set sy=2016 in "RetreiveBilateral_InvoicingRatio.m" to replicate
%%% an example in the Economics Letters.
%%%
%%% The first numeric in inv_uni indicates the country number
%%% 19 for Japan, 20 for Korea, 34 for US, and 11 for France
%%% A4 matrix is equation A4 in EL and equation (25) in the working paper.

D4(1,1)=inv_uni(19,1);
D4(2,1)=inv_uni(20,1);
D4(3,1)=inv_uni(34,1);
D4(4,1)=inv_uni(11,1);
D4(5,1)=inv_uni(34+19,1);
D4(6,1)=inv_uni(34+20,1);
D4(7,1)=inv_uni(34+34,1);
D4(8,1)=inv_uni(34+11,1);
Inv_uni=D4;

A4=TotalV([19 20 34 11],[19 20 34 11]);
TotalV=zeros(1,4,4);
TotalV(1,:,:)=A4;

%%% after running first 5 sections of "RetreiveBilatearl_InvoicingRatio.m"
j=1;n=4;
%%% Trade Weight Matrix
A=sum(TotalV(j,:,:),3);% By exporter
A=reshape(A,1,n);
B=sum(TotalV(j,:,:),2);% By importer
B=reshape(B,1,n);
TV=reshape(TotalV(j,:,:),n,n);
Exp_weight=diag(A);
Imp_weight=diag(B);
lamda=inv(Exp_weight)*TV;%export weight share
omega=TV*inv(Imp_weight);%import weight share

W1=zeros(n,n*n);W2=zeros(n,n*n);
omega=omega';
for i=1:n
W1(i,n*(i-1)+1:n*i)=omega(i,:);
W2(:,n*(i-1)+1:n*i)=diag(lamda(:,i));
end
W=[W1;W2];
%%% Estimate bilateral invoice ratio from unilateral invoice ratio
Inv_bi_est(:,j)=pinv(W)*Inv_uni(:,j);
%% Extracting from the results with larger sample countries 
A4=Inv_bi([19 20 34 11],[19 20 34 11]);