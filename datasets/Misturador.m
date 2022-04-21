

clc;
clear all;
close all;

for banco = 1:4
        
    if (banco == 1)
        form = '_MSN';
        bancot = [1 2];
    elseif (banco == 2)
        form = '_MSB';
        bancot = [1 3];
    elseif (banco == 3)
        form = '_MNB';
        bancot = [2 3];
    elseif (banco == 4)
        form = '_MSNB';
        bancot = [1 2 3];
    end  
    
    entradas = [];
    saida = [];
    for j=1:length(bancot)
        
        if (bancot(j) == 2)
            formt = 'K_grav';
        elseif (bancot(j) == 1)
            formt = 'orig';
        elseif (bancot(j) == 3)
            formt = 'r30';
        end  

        name_saida = ['saida_' formt '.mat'];
        name_entrada = ['entradas_' formt '.mat'];  
        Me = load(name_entrada) ;
        entradaM = Me.entradas;
        Ms = load(name_saida);
        saidaM = Ms.saida;
        if bancot(j) == 2
            nametr = ['tr_' formt];
            load(nametr,'-mat')
            In = [ tr.trainInd tr.valInd];
            entradaM = entradaM(:,In)';
            saidaM = saidaM(In)';
        end
        entradas = [entradas; entradaM];
        saida = [saida; saidaM];
    end
    
    name_sai = ['saida' form '.mat'];
    name_ent = ['entradas' form '.mat'];
    save(name_sai,'saida');
    save(name_ent,'entradas');

end

