
% This code show the results for the manuscript 

clc;
clear all;
close all;
NB=7; %número de banco de dados 
EPM = ones(41, NB); %Erro percentual médio
EPM_m = ones(41, NB); %Erro percentual mínimo
Neuro = ones(41,NB); %número de neuronios testados7
DP = ones(41, NB); %Desvio padrão
legenda = [];
B_EPM = ones(7,2);
figure
BestDP = [];
for banco=1:NB
   
    if (banco == 1)
        form = '_orig'; %S
    elseif (banco == 2)
        form = '_grav'; %R
    elseif (banco == 3)
        form = '_r30'; %B
    elseif (banco == 4)
        form = '_MSN'; %SR 
    elseif (banco == 5)
        form = '_MSB'; %SB
    elseif (banco == 6)
        form = '_MNB'; %RB
    elseif (banco == 7)
        form = '_MSNB'; % SRB
    end
    %leitura dos dados
    name_V_neuro = ['V_neuro' form '.mat'];
    name_V_DP_k = ['V_DP_k' form '.mat'];
    name_V_EPM_k = ['V_EPM_k' form '.mat'];
    name_V_EPM = ['V_EPM' form '.mat'];
    name_V_EPM_m = ['V_EPM_m' form '.mat'];
    load(name_V_neuro, 'V_neuro') ;
    load(name_V_DP_k,'V_DP_k') ;
    load(name_V_EPM_k,'V_EPM_k') ;
    load(name_V_EPM,'V_EPM') ;
    load(name_V_EPM_m,'V_EPM_m') ;
    EPM(:, banco)= V_EPM'  ; %Erro percentual médio
    EPM_m(:, banco)= V_EPM' ; %Erro percentual mínimo
    Neuro(:, banco)= V_neuro' ; %número de neuronios testados7
    DP(:, banco)= V_DP_k' ; %Desvio padrão
    
    Best=min(V_EPM);
    N_best = find(V_EPM==Best); 
    B_EPM(banco,:) = [V_neuro(N_best), Best];
    hold on
    
    BestDP = [BestDP; DP(N_best)];
 
    tip1 = ['-x'; '-s'; '-o'; '-+'; '-*'; '-d'; '-v']; %alternativa_linhas
    
    cor2 = [[8,226,226]/255;[88,68,153]/255;[235,1,170]/255;[208,90,27]/255;[11,92,224]/255;[114,202,33]/255;[199,195,94]/255];
 
    plot( Neuro(:, banco),EPM(:, banco),tip1(banco,:),'Color',cor2(banco,:),'LineWidth',0.75)
    
     
end
plot(B_EPM(:,1),B_EPM(:,2),'p','color',[204,0,0]/255,'LineWidth',2.1) %[204,0,0] == #cc0000
grid on 
grid minor
axis tight 
ylim([3.4, 6.71]);
legend('S', 'R', 'B', 'SR' ...
,'SB', 'RB', 'SRB','EPM min','Location','northoutside','Orientation','horizontal')%'southwest'
xlabel('N° de neurônios ')
ylabel ('EPM (%)')
set(gca, 'FontName', 'Times', 'Fontsize', 12)

%%  Analise dos resultados com músicas gravadas 

clc;
clear all;
close all;
% 

%%% Identificando os valo7res de teste

disp(['*************************************************************'])

%  bancot = input('Formato do banco de test orig (1) , gravado (2), completo (3) ou r10 (4) = '); 
bancot=2;
if (bancot == 2)
    formt = '_grav';
elseif (bancot == 1)
    formt = '_t_2C';
elseif (bancot == 3)
    formt = '_compl';
elseif (bancot == 4)
    formt = '_r10';
elseif (bancot == 5)
    formt = '_r30';
elseif (bancot == 6)
    formt = '_r80';
end  

NB=7; %número de banco de dados 
NA=457; %tamanho da amostra de teste

EP = zeros(NB,NA*10); %Erro percentual 
EPM = zeros(NB, 1); %Erro percentual médio
DP = zeros(NB, 1); %Erro percentual médio
EP_grav = zeros(NB,NA*10); %Erro percentual
EPM_grav = zeros(NB, 1); %Erro percentual médio
DP_grav = zeros(NB, 1); %Erro percentual médio


Nepm = [];
Nepm_grav = [];
disp(['*************************************************************'])
for banco = 1:7
    if (banco == 2)
        form = '_grav';
    elseif (banco == 1)
        form = '_orig'; 
    elseif (banco == 3)
        form = '_r30';
    elseif (banco == 4)
        form = '_MSN';   
    elseif (banco == 5)
        form = '_MSB';
    elseif (banco == 6)
        form = '_MNB';
    elseif (banco == 7)
        form = '_MSNB';
    end    
  
   
%dados do teste 2      
name_saida = ['saida_K' formt '.mat'];
name_entrada = ['entradas_K' formt '.mat'];
nametr = ['tr_K' formt];

load(name_saida)
load(name_entrada)
load(nametr,'-mat')

ent_grav = entradas;
sai_grav = saida;
tr_grav = tr;

% dados do teste 1       
name_saida = ['saida_K' form '.mat'];
name_entrada = ['entradas_K' form '.mat'];
namenet = ['net_K'  form];
nametr = ['tr_K' form];

load(name_saida)
load(name_entrada)
load(namenet,'-mat')
load(nametr,'-mat')

In = tr.testInd;
x = entradas(:,In);
Yd = saida(In);

Y = net(x);

%teste1
Etest = Yd-Y; %calculando o erro 

EP(banco,1:length(Etest)) = abs(Etest./Yd)*100; %erro percentual absoluto
DP(banco) = std(EP(banco,:));
EPM(banco) = sum(EP(banco,:))/length(Etest); %erro percentual médio

E = abs(Etest./Yd)*100;
  a=0;
    for j=1:length(Etest)
        
        if E(j) <=4
            a=a+1;
        end
    
    end
    Nepm = [Nepm;  100*(length(Etest)-(a))/length(Etest)]; %length(length(Etest))-

%teste 2
In_grav = tr_grav.testInd;
x_grav = ent_grav(:,In_grav);
Yd_grav = sai_grav(In_grav);
Y_grav = net(x_grav);

%teste 2
Etest_grav = Yd_grav-Y_grav; %calculando o erro 

EP_grav(banco,1:length(Etest_grav)) = abs(Etest_grav./Yd_grav)*100; %erro percentual absoluto
DP_grav(banco) = std(EP_grav(banco,:));
EPM_grav(banco) = sum(EP_grav(banco,:))/length(Etest_grav); %erro percentual médio

EA = 1000*sum(abs(Yd_grav-Y_grav))/length(Y_grav);
display(form)
display(EA)


E_grav = abs(Etest_grav./Yd_grav)*100;
  a=0;
    for j=1:length(Etest_grav)
        if E_grav(j) <=4
            a=a+1;
        end
       
    end
    
    Nepm_grav = [Nepm_grav;  100*(length(Etest_grav)-(a))/length(Etest_grav)]; %length(length(Etest))-
   
    
end

%% TESTE 1 BARRA

tipo ={'S', 'R', 'B', 'SR' ...
,'SB', 'RB', 'SRB'};


figure1 = figure();
axes1 = axes('Parent',figure1);
hold(axes1,'on');
set(axes1,'FontSize',12);
hold on


bar(EPM,'r')
errorbar(EPM,DP,'k.','LineWidth',0.5)


grid on
grid minor
axis tight
ylabel('EPM (%)')
xlabel('Dataset de treino e teste')
set(gca,'XTick',1:7,'XTickLabel',tipo,'FontName', 'Times')
ylim([0, 20]);
br.FaceColor = [204,0,0]/255;
hold on

plot(Nepm,'k*')



%% TESTE 2 BARRAS
tipo ={'S', 'R', 'B', 'SR' ...
,'SB', 'RB', 'SRB'};


figure1 = figure(); 
axes1 = axes('Parent',figure1);
hold(axes1,'on');
set(axes1,'FontSize',12);

hold on

cor = [[203,224,228]/255;[40,113,131]/255;[203,224,228]/255;[112,165,181]/255;[203,224,228]/255;[112,165,181]/255;[112,165,181]/255];

for i=1:7
    br=bar(i,EPM_grav(i),'b')
    errorbar(i,EPM_grav(i),DP_grav(i),'k.','LineWidth',0.5)
    br(1).FaceColor = cor(i,:);
end
grid on
grid minor
axis tight
ylabel('EPM (%)')
xlabel('Dataset de treino e teste')
set(gca,'XTick',1:7,'XTickLabel',tipo,'FontName', 'Times')
% legend(['EPM'; 'DP'])
ylim([0, 20]);
plot(Nepm_grav,'k*')

%% COMPARAÇÂO 1 e 2 BARRAS
tipo ={'S', 'R', 'B', 'SR' ...
,'SB', 'RB', 'SRB'};

figure1 = figure();
axes1 = axes('Parent',figure1);
hold(axes1,'on');
set(axes1,'FontSize',12);
hold on

b=bar([EPM,EPM_grav]);
b(1).FaceColor = [204,0,0]/255;
b(2).FaceColor = [40,113,131]/255;

grid on
grid minor
ylim([0, 16]);
axis tight
legend('Teste com dataset do treino', 'Avaliação com dataset R')
ylabel('EPM (%)')
xlabel('Dataset de treino')
set(gca,'XTick',1:7,'XTickLabel',tipo)
set(gca, 'FontName', 'Times', 'Fontsize', 12)
ylim([0, 20]);



%%

for banco = 1:NB
    [h(1,banco),  p(1,banco)] = ttest2(EP_grav(banco,1:length(Etest_grav)),EP_grav(1,1:length(Etest_grav)));
    [h(2,banco),  p(2,banco)] = ttest2(EP_grav(banco,1:length(Etest_grav)),EP_grav(2,1:length(Etest_grav)));
    [h(3,banco),  p(3,banco)] = ttest2(EP_grav(banco,1:length(Etest_grav)),EP_grav(3,1:length(Etest_grav)));
    [h(4,banco),  p(4,banco)] = ttest2(EP_grav(banco,1:length(Etest_grav)),EP_grav(4,1:length(Etest_grav)));
    [h(5,banco),  p(5,banco)] = ttest2(EP_grav(banco,1:length(Etest_grav)),EP_grav(5,1:length(Etest_grav)));
    [h(6,banco),  p(6,banco)] = ttest2(EP_grav(banco,1:length(Etest_grav)),EP_grav(6,1:length(Etest_grav)));
    [h(7,banco),  p(7,banco)] = ttest2(EP_grav(banco,1:length(Etest_grav)),EP_grav(7,1:length(Etest_grav)));
end
tipo =['B:S  '; 'B:N  '; 'B:B  '; 'B:SN ' ...
;'B:SB '; 'B:NB '; 'B:SNB'];
tipo1 = categorical({'B:S', 'B:N', 'B:B', 'B:SN', 'B:SB', 'B:NB', 'B:SNB'});

%% GERAÇÃO DE SCORES COMPARAVEIS COM A LITERATURA
clc;
clear all;
close all;

load('tr_K_grav.mat');
load('net_K_grav.mat');
load('saida_K_grav.mat');
load('entradas_K_grav.mat');



In = tr.testInd;
x = entradas(:,In);
Yd = saida(In);

Y = net(x);


%teste1
Etest = Yd-Y; %calculando o erro 
EPM = sum(abs(Etest./Yd))/length(Etest)*100; %erro percentual médio

E = abs(Etest./Yd)*100;
 a=0;
for j=1:length(Etest)

    if E(j) <=4
        a=a+1;
    end

end
EA = 1000*sum(abs(Yd-Y))/length(Y);
    
Acu = 100*(a)/length(Etest); %length(length(Etest))-
F1 = 2*a/(2*a + (length(Etest)-a))*100;
r2 = corrcoef(Yd,Y);
r2 = r2(1,2);
mdl = fitlm(Yd,Y);
corr=mdl.Rsquared.Ordinary;
display(EPM)
display(Acu)
display(r2)
display(corr)
display(F1)
display(EA)

% plotwb(net)
%%

IW = net.IW; % Cell containing the Input Weights
b1 = net.b; % Cell containing the biases
LW = net.LW; % Cell containing the layer weights
iw =IW{1,1};

