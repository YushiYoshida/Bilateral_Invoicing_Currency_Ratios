%% Setting up the working dirctory and specifics
%%% codes created on April 2024, modified for public on Dec 2024 
%%% for the Economics Letters by Y. Yoshida and F. Rondeau
%%% and for the GVC & Invoicing ERPT paper by F. Rondeau and Y. Yoshida 
clear;
clc;
oldFolder = pwd;
cd ..
%addpath([oldFolder,'/CombiningBoz']);
cd(oldFolder);

%%% chosse years
% for a single year, 
sy=2016;%start year;
%%% for the loop
%choose ey for end year
%ey=2016;%end year;
% and activate the loop

%%% Choose criteria, 
% 1...avoide countries with zero "total" trade
% 2...avoice counries with too many zero "bilateral" trade
criteria_zero=2; % default settting

%%% Adjustments after the downloading the data
% By removing the countries with too many 'zero' bilateral trades
% Keep countries with less zeros (less than 10 zeros out of (83 x 2, note 2 are always zeor for any conties) list
thresh_zero=16;%=18 +(ARG,LUX,PHL, SVN), =16 +(PHL), =15 -(HUN,ROM)
%thresh_zero=200;% use everything

year=sy; % for single year
%for year=sy:ey % for the loop, activate line (17), this line (32) and line (218)
%% Reading data from Boz file
% All 110 countries in the Boz et al.(2022) data 
ExpC=["MAR","AGO","ALB","ARG","ARM","AUS","AUT","AZE","BEL","BGD","BGR","BHS","BIH","BLR","BLZ","BRA","BWA","CAN","CHE","CHL","CIV","COD","COL","CRI","CYP","CZE","DEU","DNK","DZA","ECU","EGY","ESP","EST","FIN","FJI","FRA","GBR","GEO","GHA","GMB","GRC","GUY","HRV","HUN","IDN","IND","IRL","ISL","ISR","ITA","JOR","JPN","KAZ","KGZ","KHM","KOR","KWT","LBR","LTU","LUX","LVA","MAC","MDA","MDG","MDV","MKD","MLT","MNE","MNG","MOZ","MUS","MWI","MYS","NAM","NER","NLD","NOR","NPL","NZL","PAK","PER","PHL","POL","PRT","PRY","ROU","RUS","RWA","SAU","SEN","SLB","SRB","SUR","SVK","SVN","SWE","SWZ","SYC","THA","TLS","TUN","TUR","TWN","TZA","UGA","UKR","URY","USA","UZB","ZAF"];
inv_uni1=zeros(110,2);%inv_uni1_cty(110);
[num1,txt1,raw1] =xlsread('all_countries_update.xls');
last_boz=size(num1,1);

check1=0;
for i=1:last_boz
    if num1(i,2)==year
        %check1=check1+1;
        cty=txt1(i+1,2);
        for x=ExpC
            if cty==x
                if ~isnan(num1(i,3))&&~isnan(num1(i,9))
                    check1=check1+1;
                    inv_uni1(check1,1)=num1(i,3);
                    inv_uni1(check1,2)=num1(i,9);
                    inv_uni1_cty(check1)=cty;
                end
            end
        end
    end
end

% shrinking the size
inv_uni1(check1+1:110,:)=[];

% vectorizing
inv_uni=[inv_uni1(1:check1,2);inv_uni1(1:check1,1)];

% new country list
ExpC=convertCharsToStrings(inv_uni1_cty);

%% Reading data from UN Comtrade
%%% Reading annual Trade data from UNComtrade
%%% num, txt, raw represent the same data; however, only numbers by 'num',
%%% texts by 'txt'. The original data mixed of numbers and texts is in 'raw'.

%[num,txt,raw] =xlsread('TradeData_Boz2016.xlsx','TradeData2016');
[num,txt,raw] =xlsread(strcat('TradeData_Boz',num2str(year),'.xlsx'),strcat('TradeData',num2str(year)));
last=size(num,1);%%% recording the number of countries

%% Reading the selected countries with invoice data
%%% As a trial, we use 2016
%%% Only 87 countries in the Boz data have both USDExport and USDImport
%%% Tab delimited data need to be manually replaceed by "," marks. 
%%% Hint: use CTRL+H 
%%% The trade data needs to prepared before running this code
% Old style (2016) original country (87 countries)
%ExpC=["AGO","ALB","ARG","ARM","AUS","AUT","AZE","BEL","BGD","BGR","BHS","BIH","BLR","BWA","CHE","CHL","CIV","COD","CRI","CYP","CZE","DEU","DNK","ECU","EGY","ESP","EST","FIN","FJI","FRA","GBR","GEO","GRC","HRV","HUN","IDN","IRL","ISL","ISR","ITA","JPN","KAZ","KGZ","KHM","KOR","LBR","LTU","LUX","LVA","MAC","MAR","MKD","MLT","MNE","MNG","MOZ","MUS","MWI","MYS","NER","NLD","NOR","NPL","NZL","PHL","POL","PRT","PRY","ROU","RUS","SEN","SLB","SRB","SUR","SVK","SVN","SWE","SWZ","THA","TLS","TUN","TUR","TWN","TZA","UKR","URY","USA"];

% The list is prepared in the aobve section
[A,B,C,D,TotalV,n]=inptrade(last,ExpC,txt,num);% This is to call the function'inptrade'

%% Selcting the countries without zero trades
%%% Here we define two ways to remove some countries apriori to have more precise estimates
%%% The first one removes countries 'zero total trade' on either side (imports or exports)
%%% The second one removes countries with too many zero bilateral trade.

%criteria_zero=1;
x=zeros();

if criteria_zero==1
%%% Criteria (i)
%%% Adjustments after downloading the data
%%% by removing countries with zero 'total' trade on either side of exports or imports.
%%% (modified April)The manual parts are coded now.

%%% (Old manual method)This is only possible after we run the following section and check inside
%%% A and B matrix, which are the total trade values by country
%ExpC([9,46,80,83])=[];

    check_zero=0;
    for i=1:n
        if A(i)==0|B(i)==0
        check_zero=check_zero+1;
        x(check_zero)=i;
        end
    end
    if check_zero~=0
        ExpC([x])=[];
        A([x])=[];
        B([x])=[];
    n=size(ExpC,2);
    end
elseif criteria_zero==2
%%% Criteria (ii)
%%% Adjustments after the downloading the data
%%% By removing the countries with too many 'zero' bilateral trades
%%% Keep countries with less zeros (less than 10 zeros out of (83 x 2, note 2 are always zeor for any conties) list
    check_zero=0;
    for i=1:n
        if C(i)+D(i)>=thresh_zero
        check_zero=check_zero+1;
        x(check_zero)=i;
        end
    end
    if check_zero~=0
        ExpC([x])=[];
        A([x])=[];
        B([x])=[];
        n=size(ExpC,2);
    end
end

% Remove countries from unilateral invoice ratios 
if check_zero~=0
    inv_uni1([x],:)=[];
    inv_uni=[inv_uni1(1:n,2);inv_uni1(1:n,1)];
end

%%% The old way, done by Excel, first remove four countries, then 83 countries. Then, remove those with more than or equal to 10 zero trades. 
%ExpC=["AUS","AUT","BEL","BGR","CHE","CZE","DEU","DNK","ESP","FIN","FRA","GBR","GRC","HUN","IDN","IRL","ISR","ITA","JPN","KOR","MYS","NLD","NOR","NZL","POL","PRT","ROU","RUS","SWE","THA","TUR","UKR","USA"];
%n=size(ExpC,2);
%TotalV=zeros(n,n);

%%% Re-reading the data with the adjusted number of countries
[A,B,C,D,TotalV,n]=inptrade(last,ExpC,txt,num);% This is to call the function 'inptrade'


%% Checking the total V, (bilateral) trade
% old code, no longer necessary
%xlswrite('TotalV.xlsx',TotalV);

%% Trade weight Matrix
Exp_weight=diag(A);
Imp_weight=diag(B);
lamda=inv(Exp_weight)*TotalV;
omega=TotalV*inv(Imp_weight);

%% Retreiving the bilateral Invoice from Unilateral
W1=zeros(n,n*n);W2=zeros(n,n*n);
omega=omega';
for i=1:n
W1(i,n*(i-1)+1:n*i)=omega(i,:);
W2(:,n*(i-1)+1:n*i)=diag(lamda(:,i));
end

% Aggregator matrix W:  Inv_uni = W * Inv_Ratio
% Inv_uni is uniltateral invoice ratio
% Inv_Ratio is bilateral invoice ratio
W=[W1;W2];

%W=[W;zeros(n*(n-2),n*n)];
%inv_uni=[inv_uni;zeros(n*(n-2),1)];

% Retreiving bilateral invoice ratio by: Inv_Ratio = W^-1 * Inv_uni
%Inv_Ratio_est=inv(W)*inv_uni;

%%% Retreiving by generalized inverse, more robust to numerical warning for sigularity
Inv_Ratio_est=pinv(W)*inv_uni;

Inv_bi=reshape(Inv_Ratio_est,n,n);

%% Saving the matricies
%xlswrite('W.xlsx',W);inv_uni_check=W*Inv_Ratio_est;
xlswrite('Inv_bi.xlsx',Inv_bi);
%% the following is added for extending Boz regression with bilateral (on May 1st)
% vectorizing the Inv_bi matrix 
Inv_bi_a=reshape(Inv_bi',[],1);
Inv_bi_yearmat=zeros(n*n,4);

ExpC_a=ExpC;
ExpC_b=ExpC';
for i=2:n
ExpC_a=[ExpC_a;ExpC];
ExpC_b=[ExpC_b ExpC'];
end
ExpC_a=reshape(ExpC_a,[],1);
ExpC_b=reshape(ExpC_b,[],1);

year_b(n*n,1)=zeros;
year_b(:,1)=year;

Inv_bi_yearmat=[year_b Inv_bi_a ExpC_a ExpC_b];
%file1=strcat('Inv_bi',num2str(year),'.xlsx');
%file1=convertCharsToStrings(file1);
%delete file1;
%delete Inv_bi2000.xlsx;


xlswrite(strcat('Inv_bi',num2str(year),'.xlsx'),Inv_bi_yearmat);

% the following "end" is activated for the loop
%end
%% Extracting those countries in the GVC list
GVCexC=["AUT","BEL","BRA","CAN","CHN","CZE","DNK","EST","FIN","FRA","DEU","GRC","HUN","IRL","ITA","JPN","KOR","LVA","LTU","LUX","NLD","NOR","POL","PRT","SGP","SVK","VNM","SVN","ESP","SWE","CHE","THA","GBR","USA"];
GVCimC=["BRA","CAN","CHN","DEU","FRA","GBR","ITA","JPN","KOR","MEX","POL","THA","USA"];% 13 countries
%GVCimC=["DEU","FRA","GBR","ITA","JPN","KOR","MEX","POL","THA","USA"];% 10 countries

Inv_bi_gvc=zeros(size(GVCexC,2),size(GVCimC,2));
c1=0;f1=0;
for i=GVCexC
    c1=c1+1;
    c2=0;
for j=ExpC
    c2=c2+1;
    if i==j
        f1=f1+1;
        c3=0;
        f2=0;
        for i2=GVCimC
            c3=c3+1;
            c4=0;
            for j2=ExpC
                c4=c4+1;
                if i2==j2
                f2=f2+1;
                    %Inv_bi_gvc(c1,c3)=Inv_bi(c2,c4);
                    Inv_bi_gvc(f1,f2)=Inv_bi(c2,c4);

                end
            end
        end
    end

end
end

clear y;
ii=0;i3=0;
for i=GVCexC
    i3=i3+1;
    check_gvc=0;
    for j=ExpC
        if i==j
        check_gvc=1;
        end
    end
    if check_gvc==0 % bad list for exporters
    ii=ii+1;
    y(ii)=i3;
    end
end
GVCexC([y])=[];
Inv_bi_gvc(size(GVCexC,2)+1:i3,:)=[];

clear z;
jj=0;i4=0;
for i=GVCimC
    i4=i4+1;
    check_gvc=0;
    for j=ExpC
        if i==j
        check_gvc=1;
        end
    end
    if check_gvc==0 % bad list for importers   
    jj=jj+1;
    z(jj)=i4;
    end
end
GVCimC([z])=[];
Inv_bi_gvc(:,size(GVCimC,2)+1:i4)=[];


%% Save the GVC invoicing
Inv_bi_gvc_a=reshape(Inv_bi_gvc()',[],1);

GVCexC_a=GVCexC;
for i=2:f2
GVCexC_a=[GVCexC_a; GVCexC];
end
GVCexC_a=reshape(GVCexC_a,[],1);

GVCimC_a=GVCimC';
for i=2:f1
GVCimC_a=[GVCimC_a GVCimC'];
end
GVCimC_a=reshape(GVCimC_a,[],1);

year_a(f1*f2,1)=zeros;
year_a(:,1)=year;

gvc_yearmat=[year_a Inv_bi_gvc_a GVCexC_a GVCimC_a];
xlswrite(strcat('InvbiGVC',num2str(year),'.xlsx'),gvc_yearmat);


%% Checking the matricies
%xlswrite('InvbiGVC.xlsx',Inv_bi_gvc);
