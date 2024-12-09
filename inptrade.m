%%% Extracting the data for countries listed in ExpC from the original annual UN
%%% Comtrade data.
function [A,B,C,D,TotalV,n] = inptrade(last,ExpC,txt,num)
% Finding bilateral trade value for Exp and Imp lists
n=size(ExpC,2);
TotalV=zeros(n,n);

check=0;
for i=1:last %2:last
    ii=0;
for x = ExpC
    ii=ii+1;
    if txt(i,8)==x
        jj=0;
        check=check+1;
        for y = ExpC
            jj=jj+1;
            if txt(i,13)==y
            TotalV(ii,jj)=TotalV(ii,jj)+num(i-1,41);%number data starts with heading
            check=check+100;
            %break;
            end
           
        end
    end

end
end
% checking the total exports and imports by contry
A=sum(TotalV,2);% By exporter
B=sum(TotalV);% By importer

C=sum(TotalV==0,2);
D=sum(TotalV==0);