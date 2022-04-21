
function [trecho dadosparc Fm] = segmenta(sinal, fs, Tj, Ts, tempo,classe)
%Tj = tempo da janela
%Ts = tempo de sobreposi��o

%retorna uma matriz com o sinal segmentado


%seguimentando o sinal em trechos

dt = length(sinal); %dura��o do sinal
dj = (131072); %dura��o da janela
sj = (Ts*fs); %sobrepoi��o da janela
sinalseg = []; %matriz que receber� os peda�os de sinal
trecho = [];
dadosparc = [];
var = dj-sj; %passo para percorrer o vetor
k=20*fs;
i = 1;
Nucz = 0; %taxa de cruzamento por zero

 
[f,P] = myfftHugo(sinal,fs);
% plot(f,P)
% title(['FFT da m�sica: ', num2str(i)])
% xlabel('Frequencia (Hz)');
% ylabel('Amplitude');
mf = max(P);
mf2 = find(P==mf);
Fm = f(mf2);



while (k+dj<=dt-20*fs)
  
    for j=1:dj
        sinalseg1(j) = sinal(k+j); %sinalseg � a janela
        
    end
   
    sinalseg = sinalseg1/rms(sinalseg1);
    [f, P] = myfftHugo(sinalseg,fs);
    sum(P);

    dadosparc1 = [tempo, P]; % L = linha do vetor das m�sicas
    dadosparc = [dadosparc;dadosparc1];
    trecho = [trecho; sinalseg1];
    sum(sum(dadosparc));
    k = k+var;
    i=i+1;
    sinalseg = [];
end


end 

