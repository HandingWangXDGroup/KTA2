function [CAobj,CAdec,CAvar] = K_UpdateCA(CAobj,CAdec,CAvar,MaxSize)
% [CAobj,CAdec] = UpdateCA_GP(CAobj,CAdec,OffspringDec,OffspringObj,Maxsize);
% Update CA

%--------------------------------------------------------------------------
% Copyright (c) 2016-2017 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB Platform
% for Evolutionary Multi-Objective Optimization [Educational Forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    N  = size(CAobj,1);
    if N <= MaxSize
        return;
    end
    
    %% Calculate the fitness of each solution
%     CAObj = CA.objs;


    CAobj1 = (CAobj-repmat(min(CAobj),N,1))./(repmat(max(CAobj)-min(CAobj),N,1));
    I = zeros(N);
    for i = 1 : N
        for j = 1 : N
            I(i,j) = max(CAobj1(i,:)-CAobj1(j,:));
        end
    end
    C = max(abs(I));
    F = sum(-exp(-I./repmat(C,N,1)/0.05)) + 1;
    
    %% Delete part of the solutions by their fitnesses
    Choose = 1 : N;
    while length(Choose) > MaxSize
        [~,x] = min(F(Choose));
        F = F + exp(-I(Choose(x),:)/C(Choose(x))/0.05);
        Choose(x) = [];
    end
    CAobj = CAobj(Choose,:);
    CAdec = CAdec(Choose,:);
    CAvar = CAvar(Choose,:);
end