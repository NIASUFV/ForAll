
clc;
clear all;
close all;


disp(['*************************************************************'])
disp(['TEM CERTEZA QUE DESEJA COMPILAR O CÓDIGO?????'])
disp(['SE ESTIVER FAZENDO UM TESTE, CONFIRA SE NEHUMA VARIÁVEL IMPORTANTE'... 
     'SERÁ SOBREPOSTA DE FORMA INDESEJADA'])
disp(['CONFIRA OS SAVE!!!!'])
disp(['*************************************************************'])
disp('Se ta tudo certo continue entre com o número do banco, caso contrário (ctrl+c).');
banco = input('Banco de treino B:S (1), B:N (2), B:B (3),B:SN (4),B:SB (5),B:NB (6) e B:SNB (7) = ');

disp([''])
tic
if (banco == 1)
    form = '_orig';
elseif (banco == 2)
    form = '_grav';
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
       


% Solve an Input-Output Fitting problem with a Neural Network

% This script assumes these variables are defined:
%
%   entradas - input data.
%   saida - target data.

name_saida = ['saida' form '.mat'];
name_entrada = ['entradas' form '.mat'];


load(name_saida)
load(name_entrada)
x1 = entradas';
t1 = saida';
MM=100;
k=7;
t_k=[];
x_k =[];

[Train_ind, Val_ind, Test_ind, indices, t, x] = My_Kfold(k, t1, x1);

tiptrain = 'trainlm';


V_neuro = []; %vetor com os neuronios
V_EPM = []; %vetor com o erro médio percentual por N
V_DP_k = []; %vetor com o desvio padrão do erro por N
V_EPM_m = [];
V_EPM_k = [];

for j = 11:51
    %variando o número de neurônios
    
    EPM_k = []; %vetor com o erro médio percentual da validaçao por k
    
    ME=100;
    for i = 1:k %variando o banco de dados para a validação
        
      EPM_v = []; %vetor com o erro médio percentual da validaçao por u
      DP_v = []; %vetor com o desvio padrão do erro da validação por u
        t_k =[t(Train_ind(i,:)) t(Val_ind(i,:)) t(Test_ind(i,:))];
                for ent = 1:25
                    x_k(ent,:) = [x(ent,(Train_ind(i,:))) x(ent,(Val_ind(i,:))) x(ent,(Test_ind(i,:)))];
                end

            for u=1:10 % sorteio de novos pesos
                
                hiddenLayerSize =j; %número de Neurônios 
                trainFcn = tiptrain ;  % Tipo de treinamento  .
                net = fitnet(hiddenLayerSize,trainFcn); %Criando a rede
                net.input.processFcns = {'removeconstantrows','mapminmax'}; %mapstd
                net.output.processFcns = {'removeconstantrows','mapminmax'};
                %net.output.processFcns.ymin = 0;

                net.divideFcn = 'divideblock'; %divisão do banco de dados
                %divisão dos indices para cada etapa

%                 net.layers{2}.transferFcn = 'poslin'; 
%                 net.layers{1}.transferFcn = 'l    ogsig';
                net.divideParam.trainRatio = 71.1428/100; 
                net.divideParam.valRatio = 14.2857/100;
                net.divideParam.testRatio = 14.2857/100; 


                net.performFcn = 'mse';  % Mean Squared Error
                net.trainParam.lr = 0.0001;
                net.trainParam.epochs = 100000;
                net.trainParam.max_fail = 6;
                %%%%% MUITO IMPORTANTE ESSE COMANDO TIRA AQUELA JANELA CHATA
                net.trainParam.showWindow = false;
                net.trainParam.showCommandLine = false;
 

                [net,tr] = train(net,x_k,t_k);
                testTargets = t_k .* tr.testMask{1};
                InTest = tr.testInd;


                y = net(x_k);
                Ytest = zeros(1,length(InTest));
                Ydtest = zeros(1,length(InTest));
                Etest = zeros(1,length(InTest));


                for s = 1:length(InTest)

                    Ytest(s) = y(InTest(s)); %identificando os valores encontrados
                    Ydtest(s) = t_k(InTest(s)); %identificando os valores desejados
                    Etest(s) = Ydtest(s)- Ytest(s); %calculando o erro 
                end

                EPA = abs(Etest./Ydtest)*100; %erro percentual absoluto
                EPM = sum(EPA)/length(EPA); %erro percentual médio

                EPM_v  = [EPM_v  EPM];
 
                if (EPM < ME)
                  
                    net_top = net;
                    tr_top = tr;
                    saida = t_k;
                    entradas = x_k;
                    EPMprint = EPM;
                    Kprint = i;
                    Nprint = j;
                    
                    ME = EPM;
                end
           
                
            end
        
        EPM_k = [EPM_k  min(EPM_v)];
        
        

    end
    
    disp(['EPM = ' num2str(EPMprint) ' | K = ' num2str(Kprint)  ...
            ' | N = ' num2str(Nprint) ]) 
    disp(['-'])
        
    EPM_k_M = sum(EPM_k)/k;
    
      if (EPM_k_M < MM)
        namenet = ['net_K'  form '.mat'];
        nametr = ['tr_K'  form '.mat'];
        name_t = ['saida_K'  form '.mat'];
        name_x = ['entradas_K'  form '.mat'];
        net = net_top;
        tr = tr_top;
        save (namenet, 'net')
        save (nametr, 'tr')
        save (name_t, 'saida')
        save (name_x, 'entradas')
        disp(['EPMmédio : ' num2str(EPM_k_M) '   N = ' num2str(j)])
        disp(['-----------------------------'])
        MM = EPM_k_M;
      end
    V_neuro = [V_neuro j];
    V_DP_k = [V_DP_k  std(EPM_k)]; %salva os valores de DP para cada neuronio
    V_EPM = [V_EPM  EPM_k_M]; %salva o valor de EPM para cada neuronio
    V_EPM_m = [V_EPM_m min(EPM_k)];
    V_EPM_k = [V_EPM_k ;EPM_k];
end


name_V_neuro = ['V_neuro' form '.mat'];
name_V_DP_k = ['V_DP_k' form '.mat'];
name_V_EPM_k = ['V_EPM_k' form '.mat']; 
name_V_EPM = ['V_EPM' form '.mat'];
name_V_EPM_m = ['V_EPM_m' form '.mat'];

save(name_V_neuro, 'V_neuro');
save(name_V_DP_k,'V_DP_k');
save(name_V_EPM_k,'V_EPM_k');
save(name_V_EPM,'V_EPM');
save(name_V_EPM_m,'V_EPM_m');

save trainFcn.mat trainFcn ;
disp('Se você está vendo essa mensagem, fique feliz :], o treinamento acabou!!!!!!!!!!!')
disp(['Ele só durou ' num2str(toc/3600) ' horas'])

