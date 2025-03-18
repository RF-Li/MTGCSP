function W = my_csp(C1,C2,M)
[V,D]=eig(C1,C2);
W=cat(2,V(:,1:M),V(:,end-M+1:end));
