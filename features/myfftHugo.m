function [fc,pc] = myfftHugo(y,fs)
L = length(y);
signal_FFT = fft(y)/L;
amplitude = 2*abs(signal_FFT(1:L/2+1));
amplitude([1 end]) = amplitude([1 end])/2;
frequency = fs/2*linspace(0,1,L/2+1);
fa=frequency;
Pa=amplitude;

fc = 55:10:300;
pc = zeros(1,25);
for i = 1:25
    n = 0;
    for j = 1:length(fa)
        if fa(j)>=50+10*(i-1)&&fa(j)<60+10*(i-1)
            pc(i) = pc(i)+Pa(j);
            n = n+1;
        end
    end
    pc(i) = pc(i)/n;
end


% ffa = [49 300]; %faixa de frequência da zabumba
% va = find(fa>ffa(1) & fa<ffa(2));
% ia  = minmax(va);   
% fb = fa(ia(1):ia(2));
% pb = Pa(ia(1):ia(2));
% 
% k=1;
% 
% fc= ffa(1)+6:10:300;
% pc = [];
% j=0;
% while (j<25)
%     
%     pc = [pc sum(pb(k:k+10))/length(pb(k:k+10))];
%     
%     k=k+10;
%     j = j+1;
% end 

end