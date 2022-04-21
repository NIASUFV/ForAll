%Criando a matrix de entrada da rede neural


clc;
clear all;
close all;

% Import the data
[~, ~, raw] = xlsread('tempo_orig.xls','Planilha1','A2:D83');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[1,4]);
raw = raw(:,[2,3]);

% Create output variable
data = reshape([raw{:}],size(raw));

% Allocate imported array to column variable names
NomeMusicas = cellVectors(:,1);
Tempo = data(:,1);
Classe = data(:,2);
Tipo = cellVectors(:,2);

% Clear temporary variables
clearvars data raw cellVectors;


%%%%%% LENDO TODAS AS MÚSICAS %%%%%%%%
Tjanela = 2.9721541950113; %tempo de cada janela em s 2.9721541950113
Tsobrep = 1; %tempo de sobreposição

musicas = []; %matriz que reberá as músicas
musicasfilt = []; %matriz que reberá as músicas filtradas
musica =[]; %matriz temporária que receberá cada música
amostras = [];
Fmaxs = [];
%

for i=1:length(Tempo)
  
i
   filename = char(NomeMusicas(i));
   [audio, fs] = audioread(filename); 
   l = size (audio);
   if (size(2)==1)
        som = audio(:,1);
   else
       som = (audio(:,1) + audio(:,2))/2;
   end
   
%    filename = [filename(1:length(filename)-3) 'txt']; 
   [trecho musica Fmax] = segmenta(som,fs, Tjanela, Tsobrep,Tempo(i),i);
   musicas = [musicas;musica];
%    amostras = [amostras; amostra];
   Fmaxs = [Fmaxs Fmax];
%    dfilt.delay(10)

  L =size(trecho);
  l = round(L(1)/2);
  trecho = trecho(1:l,:);
%   save (filename, 'trecho', '-ascii')
end


plot(Fmaxs)

xlabel('música');
ylabel('Frequencias fundamentais(Hz)');
grid on 


saida = musicas(:,1);
entradas = musicas(:,2:end);

save saida_.mat saida
save entradas_.mat entradas

entradas = entradas';
save('entradas.csv','entradas','-ascii') 
csvwrite(entradas,'entradas.csv') 

