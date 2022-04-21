
function [trecho dadosparc Fm] = segmenta(sinal, fs, Tj, Ts, tempo,classe)
%Tj = tempo da janela
%Ts = tempo de sobreposição

%retorna uma matriz com o sinal segmentado


%seguimentando o sinal em trechos

dt = length(sinal); %duração do sinal
dj = (131072); %duração da janela
sj = (Ts*fs); %sobrepoição da janela
sinalseg = []; %matriz que receberá os pedaços de sinal
trecho = [];
dadosparc = [];
var = dj-sj; %passo para percorrer o vetor
k=20*fs;
i = 1;
Nucz = 0; %taxa de cruzamento por zero

 
[f,P] = myfftHugo(sinal,fs);
% plot(f,P)
% title(['FFT da música: ', num2str(i)])
% xlabel('Frequencia (Hz)');
% ylabel('Amplitude');
mf = max(P);
mf2 = find(P==mf);
Fm = f(mf2);



while (k+dj<=dt-20*fs)
  
    for j=1:dj
        sinalseg1(j) = sinal(k+j); %sinalseg é a janela
        
    end
   
    sinalseg = sinalseg1/rms(sinalseg1);
    [f, P] = myfftHugo(sinalseg,fs);
    sum(P);

    dadosparc1 = [tempo, P]; % L = linha do vetor das músicas
    dadosparc = [dadosparc;dadosparc1];
    trecho = [trecho; sinalseg1];
    sum(sum(dadosparc));
    k = k+var;
    i=i+1;
    sinalseg = [];
end


end 

