M=1;
grid_x=10;
grid_y=10;
FFF=zeros(M,grid_x,grid_y);
sparsity=zeros(M,grid_x,grid_y);
FFF_TRAIN=zeros(M,10,4);
U=cell(grid_x,grid_y);

N=size(data_y,1);

for CSP_M=1:1
    for lambda=1:grid_x
        for alpha=1:grid_y
        
        acry=zeros(5,5);
        for ttt=1:5
            C=10;
            kertype='linear';
            indices = crossvalind('Kfold',N,5); 
            
            for K=1:5 
                
                test = (indices==K);
                train = ~test;
                Y_train=data_y(train);
                trnb=size(find(train),1);
                tenb=size(find(test),1);
                
                X_train=zeros(trnb,2*CSP_M*bandcount*number_of_all_timewindow);
                
                X_test=zeros(tenb,2*CSP_M*bandcount*number_of_all_timewindow);
                for group=1:number_of_all_timewindow
                for tnb=1:bandcount
                    TR_x=group_data_x(group,train,tnb);
                    TE_x=group_data_x(group,test,tnb);
                    C1=zeros(3);
                    C2=zeros(3);
                    
                    for i=1:trnb
                        if Y_train(i)==1
                            C1=C1+(TR_x{i}*TR_x{i}');
                        elseif Y_train(i)==-1
                            C2=C2+(TR_x{i}*TR_x{i}');
                        end
                    end
                    C1=C1/size(find(Y_train==1),2);
                    C2=C2/size(find(Y_train==-1),2);
                    W=my_csp(C1,C2,CSP_M);
                    
                    for i=1:trnb
                        for j=1:2*CSP_M
                            X_train(i,j+(tnb-1)*2*CSP_M+(group-1)*2*CSP_M*bandcount)=log(var(W(:,j)'*TR_x{i}));
                        end
                    end
                    
                    for i=1:tenb
                        for j=1:2*CSP_M
                            X_test(i,j+(tnb-1)*2*CSP_M+(group-1)*2*CSP_M*bandcount)=log(var(W(:,j)'*TE_x{i}));
                        end
                    end
                    
                end
                end
                
                Y_test=data_y(test);
               
                G=X_train;

                u0=zeros(size(G,2),1);  
                u=New_Estimate_x(lambda,alpha,u0,G,Y_train);
                ind=(u~=0);
                X_tr_temp=X_train(:,ind);
                X_test_temp=X_test(:,ind);   
                SVMModel=fitcsvm(X_tr_temp,Y_train,'ClassNames',{'-1','1'});
                [label1,score1] = predict(SVMModel,X_test_temp);
                
                temp=size(find(str2double(label1)==Y_test),1)/size(Y_test,1);
                acry(K,ttt)=temp;
                
            end
 
        end
        FFF(CSP_M,lambda,alpha)=mean(mean(acry));
        sparsity(CSP_M,lambda,alpha)=size(find(ind==1),1);
        U{lambda,alpha}=u;
        end
    end
end
acrySet=zeros(10,10);
for i=1:10
for j=1:10
acrySet(i,j)=FFF(1,i,j);

end
end
disp(FFF);
%q is max accuracy 
q=max(max(max(FFF)));
