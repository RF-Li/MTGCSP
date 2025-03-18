function r= New_Estimate_x(lambda,alpha,u0,G,Y_train)
     param.regul='sparse-group-lasso-l2'; 
   param.loss='square';
  param.lambda=lambda*0.24;%group sparse
  param.lambda2=alpha*0.5; 
    param.size_group=34;
     [u, ~]=mexFistaFlat(Y_train,G,u0,param);
r=u;