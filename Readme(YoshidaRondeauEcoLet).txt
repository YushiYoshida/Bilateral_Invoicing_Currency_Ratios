*** Readme(YoshidaRodeauEcoLet) FILE ***
Copyright by Yushi Yoshida and Fabien Rondeau, 2024

This Readme file describes the files for replicating Yushi Yoshida and Fabien Rondeau, 2024, Bilateral Invoicing Currency Ratio: A methodology to calculate them from unilateral ratios, Economics Letters. 

The earlier working paper version is available as CREM Working Paper No. 2024-07
https://crem.univ-rennes.fr/working-papers


*************

The Boz et al. (2022) unilateral invoicing ratio dataset:
Source: Data appendix of Boz, Casas, Georgiadis, Gopinath, Le Mezo, Mehl, and Nguyen, 2022, Patterns of invoicing currency in global trade: New evidence, Journal of International Economics, 136, 103604.

all_countries_updates.xls
******

The bilateral trade values:

Source: UNComtrade
The bilateral trade values are retrieved from the UNComtrade for each year between 1992 and 2019.
The file name is "TradeData_Bozyyyy.xlsx,  where 'yyyy' indicates the year.
***********

The 4 Matlab codes:

(1) RetrieveBilateral_InvoicingRatio.m
The main code to estimate bilateral invoicing ratios from unilateral invoicing ratios of Boz et al. (2022).

Output files:
inv_vi.xlsx         ... unilateral invoicing ratios in matrix form
inv_biyyyy.xlsx     .... (yyyy' indicates year) column vector version for panel dataset
invbiGVCyyyy.xlsx   .... selected for countries with global value chain data (for Rondeau and Yoshida (2024), CREM working paper No.2024-09. Note this paper is an application paper.


(2)inptrade.m
function used in the above code


(3)Trial_example.m
This code replicates section 3 of Yoshida and Rondeau (2024)


(4)Example_validation.m
This code can be run ONLY after running the code in (1).
This code replicates equation A4 in the Economics Letters and equation (25) in the working paper version.


