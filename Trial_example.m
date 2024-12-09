%%% Simulation for Retreiving Bi from Uni for Four countries case
n=4; %the number of countries
n_sim=100;% simulation repetition;
Res=zeros(n_sim,2);

%% 
Ctry=["JPN","KOR","USA","FRA"];
Trade_base=[0	100	300	200;
50	0	200	150;
300	200	0	150;
80	60	150	0
];
USD_base=[0	20	250	50;
10	0	180	40;
90	70	0	60;
10	20	100	0
];
%% Simulation repetition
TotalV=zeros(n_sim,n,n);USD_total=zeros(n_sim,n,n);
USD_bi=zeros(n_sim,n,n);
Inv_uni=zeros(n+n,n_sim);Inv_bi=zeros(n*n,n_sim);
Inv_bi_est=zeros(n*n,n_sim);
for j=1:n_sim 

%% Generated True Bilateral Invoice Ratio
%Trade_random=50*rand(n);% adds from 0 to 50
%USD_random=50*rand(n);% adds from 0 to 50

Trade_random=50*(rand(n)-0.5); % range from -25 to +25
USD_random=30*(rand(n)-0.5); % range from -15 to +15

%Trade_random=zeros(n); % constant
%USD_random=zeros(n);   % constant


TotalV(j,:,:)=Trade_base+Trade_random;
USD_total(j,:,:)=USD_base+USD_random;
USD_bi(j,:,:)=USD_total(j,:,:)./TotalV(j,:,:);
for i=1:n
USD_bi(j,i,i)=0;
USD_total(j,i,i)=0;TotalV(j,i,i)=0;
end
Inv_bi(:,j)=reshape(USD_bi(j,:,:),16,1);
%% Trade Weight Matrix
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
%% Calculate True Unilateral Invoice Ratio
Inv_uni(:,j)=W*Inv_bi(:,j);


%% Estimate bilateral invoice ratio from unilateral invoice ratio
Inv_bi_est(:,j)=pinv(W)*Inv_uni(:,j);
[corr_coef,corr_rho]=corrcoef(Inv_bi_est(:,j),Inv_bi(:,j));

%confirming this esimated unilateral is the consistent unilateral invoice ratio
Inv_uni_est(:,j)=W*Inv_bi_est(:,j);
check=round(Inv_uni_est(:,j)-Inv_uni(:,j),14);

Res(j,1)=corr_coef(2,1);Res(j,2)=corr_rho(2,1);
end
%% Graphs
figure;
z=2;% choose any simulated number from 1 to n_sim
t=1:16;
plot(t,Inv_bi(:,z),t,Inv_bi_est(:,z));
ylabel('USD invoice ratio');
pairs={'JPN-JPN';'KOR-JPN';'US-JPN';'FRA-JPN';'JPN-KOR';'KOR-KOR';'US-KOR';'FRA-KOR';'JPN-US';'KOR-US';'US-US';'FRA-US';'JPN-FRA';'KOR-FRA';'US-FRA';'FRA-FRA'
};
xticks(1:1:16);
xticklabels(pairs);
title('The estimated bilateral invoice ratio versus the true bilateral invoice ratio');


