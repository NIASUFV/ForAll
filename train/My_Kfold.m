function [Train_ind, Val_ind, Test_ind,indices,T,X] = My_Kfold(N,t,x)


k = N; % As an example, let's let k = 5
sample_size = floor(length(t)/k);
L = k*sample_size;

%Make a vector of all the indices of your data from 1 to the total number of instance

indices = randperm(L);
length(indices)
T = t(1:length(indices));
X = x(:,1:length(indices));

% indices = 1:L;
passo = 0;
M_indices = [];
cu = 1;
for v=1:sample_size:L

passo = passo + sample_size ;

M_indices = [M_indices; indices(v:passo)];

end
M_indices = [M_indices; M_indices];


Train_i = zeros(N, length(t));
Val_i =  zeros(N, length(t));
Test_i =  zeros(N, length(t));

Train_ind = [];
Train_ilnd = [];
Val_ind = [];
Test_ind = [];


for w=1:k
    Train_ind_l = [];
    Test_ind = [Test_ind; M_indices(w,:)];
    Val_ind = [Val_ind; M_indices(w+1,:)];

    Test_i(w,Test_ind(w,:)) = 1;
    Val_i(w,Val_ind(w,:)) = 1;
    
    
    for z = 1:k-2
        Train_ind_l = [Train_ind_l M_indices(z+w+1,:)];
    end
        Train_ind = [Train_ind; Train_ind_l];
        Train_i(w,Train_ind(w,:)) = 1;
end
end

 
    
   