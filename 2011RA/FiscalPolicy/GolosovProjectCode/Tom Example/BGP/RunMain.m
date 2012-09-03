 clc
 clear all
 
 
% -------- EXPERIMENT  0 -----------------------------------------------
% This is the baseline settings
 SetParaStruc;
 Para.datapath=['Data/CompStats/'];
 mkdir(Para.datapath)
 casename='BM';
 Para.StoreFileName=['c' casename '.mat'];
 CoeffFileName=[Para.datapath Para.StoreFileName];

 % ---------------CHANGE THE DEAFULT PARAMTERS----------------------------
 % This is the BM case - no change
 
 %  --- SOLVE THE BELLMAN EQUATION --------------------------------------
 MainBellman(Para)
 
 
 clear all;
% -------- EXPERIMENT  1 -----------------------------------------------
% This setting increases the Pareto weight of Agent 2

% This is the baseline settings
 SetParaStruc;
 Para.datapath=['Data/CompStats/'];
 mkdir(Para.datapath)
 casename='Pareto';
 Para.StoreFileName=['c' casename '.mat'];
 CoeffFileName=[Para.datapath Para.StoreFileName];
 
 
 % ---------------CHANGE THE DEAFULT PARAMTERS----------------------------
alpha_2=.75;
alpha_1=1-alpha_2;
Para.alpha_1=alpha_1*Para.n1;
Para.alpha_2=alpha_2*Para.n2;

 
 %  --- SOLVE THE BELLMAN EQUATION --------------------------------------
 MainBellman(Para)
 
 
 % -------- EXPERIMENT  2 -----------------------------------------------
% This setting introduces a mean preserving spread in g
 
 clear all
  SetParaStruc;

% This is the baseline settings
 Para.datapath=['Data/CompStats/'];
 mkdir(Para.datapath)
casename='GVol';
 Para.StoreFileName=['c' casename '.mat'];
 CoeffFileName=[Para.datapath Para.StoreFileName];

 % ---------------CHANGE THE DEAFULT PARAMTERS----------------------------
 % MPS in g . We double the spread between the expenditure shocks
MeanExpenditureShocks=mean(Para.g);
ExpenditureShocksGap=Para.g(2)-Para.g(1);
NewExpenditureshocksGap= ExpenditureShocksGap*2;
Para.g(1)=MeanExpenditureShocks-NewExpenditureshocksGap/2;
Para.g(2)=MeanExpenditureShocks+NewExpenditureshocksGap/2;
 %  --- SOLVE THE BELLMAN EQUATION --------------------------------------
 MainBellman(Para)

 
 
 
 
% -------- EXPERIMENT  3 -----------------------------------------------
% This setting introduces a mean preserving spread in theta
clear all
% This is the baseline settings
 SetParaStruc;
 Para.datapath=['Data/CompStats/'];
 mkdir(Para.datapath)
 casename='Ineq';
 Para.StoreFileName=['c' casename '.mat'];
 CoeffFileName=[Para.datapath Para.StoreFileName];


 % ---------------CHANGE THE DEAFULT PARAMTERS----------------------------
% increase difference between theta1 and theta 2 (were we again pick new 
%thetas so that "first best" undistorted output is the same, 
%but inequality is higher).
OldThetaSpread=Para.theta_1-Para.theta_2;
NewThetaSpread=OldThetaSpread*2;
[c1FB c2FB l1FB l2FB yFB g_yFB_h Agent1WageShareFB_h]=getFB(Para,2);
Output(1)=c1FB*Para.n1+c2FB*Para.n2+Para.g(1);
[c1FB c2FB l1FB l2FB yFB g_yFB_l Agent1WageShareFB_l]=getFB(Para,1);
Output(2)=c1FB*Para.n1+c2FB*Para.n2+Para.g(2);
AverageOutput=sum(Output)/2;
NewTheta=fsolve(@(ThetaGuess) ResNewTheta( ThetaGuess,NewThetaSpread, AverageOutput,Para),[Para.theta_1 Para.theta_2]);
Para.theta_1=NewTheta(1);
Para.theta_2=NewTheta(2);
 %  --- SOLVE THE BELLMAN EQUATION --------------------------------------
 MainBellman(Para)
 
 
 % -- SIMULATIONS -------------------------

 MainSimulationsCommonShocks;

 