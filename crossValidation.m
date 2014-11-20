%% crossValidation   Template code for cross validation.
%   This is a template for performing cross-validation for vl_svmtrain. In
%   the future I plan to add support for libsvm and liblinear. CONSIDER
%   PASSING A FUNCTION HANDLE INSTEAD OF A STRING

function [params, model] = crossValidation(data,labels,func,nFolds)
    assert(ismember(func,{'vlsvm'}),'Training library not supported')
    if nargin < 4, nFolds = 5; end
    
    assert(length(labels) == size(data,1), 'Number of samples and labels do not match')
    nSamples     = size(data,1);
    indCrossVal  = crossvalind('Kfold',nSamples,nFolds);
    wrapper      = [func 'Wrapper'];
    
    % Size of parameter grid and min/max values. Change these at will. You can
    % even remove or add more parameters, depending on your setting. (gamma is
    % used in libsvm with the rbf kernel - NOT used in vlfeatWrapper).
    nGammas = 1; nCosts = 10;
    cmin = -7; cmax = -3;
    gmin = -1; gmax = 2;
    [lambdas,~] = meshgrid(logspace(cmin,cmax,nCosts),logspace(gmin,gmax,nGammas));
    
    disp(['Starting ' num2str(nFolds) '-fold cross validation'])
    nCombs   = numel(lambdas);
    cvError  = zeros(numel(lambdas),1);
    ticStart = tic;
    for i=1:nCombs
        err = zeros(nFolds,1);
        for k=1:nFolds
            indValSet   = indCrossVal == k;
            indTrainSet = ~indValSet;
            trainData   = data(indTrainSet,:);
            valData     = data(indValSet,:);
            trainLabels = labels(indTrainSet);
            valLabels   = labels(indValSet);
            [~,err(k)]  = feval(wrapper,trainLabels,trainData,lambdas(i),valLabels,valData);
        end
        cvError(i) = mean(err);   %The generalization error is the mean of the error
        progress(sprintf('lambda = %.6f, [%i out of %i combinations]\n',...
            lambdas(i),i,nCombs), i,nCombs, ticStart,0);
    end
    
    % Pick the best gamma and cost - those that minimize the cvError
    [~,ind] = min(cvError(:));
    params.lambda = lambdas(ind);
    fprintf('Best error: %.3f for lambda = %.6f',cvError(ind),params.lambda)
    if nargin > 1
        disp('Training model with optimal parameter values...')
        model = feval(wrapper,trainLabels,trainData,params.lambda);
    end
end


%% Wrapper for vl_svmtrain (vl_feat must already be installed in your machine)
function [model,err] = vlsvmWrapper(trainLabels,trainData,lambda,valLabels,valData)
    [model.w,model.b] = vl_svmtrain(trainData', trainLabels, lambda,'epsilon',1e-3,'Solver','SDCA');
    if nargin == 5
        [~,~,info] = vl_pr(valLabels,valData * model.w + model.b);
        err = 1-info.ap;
    elseif nargin == 4
        error('Not enough input arguments (validation data missing)')
    else
        err = [];
    end
end


%% Wrapper for libsvm (NOT SUPPORTED AT THE MOMENT!)
function [model,err] = libsvmWrapper(trainLabels,trainData,paramString,valLabels,valData)
    warning('WARNING: libsvm is not currently supported for cross-validation')
    model = svmtrain_libsvm(trainLabels, trainData, paramString);
    if nargin == 5
        [~, accuracy] = svmpredict_libsvm(valLabels, valData, model);
        err = accuracy(2);
    elseif nargin == 4
        error('Not enough input arguments (validation data missing)')
    else
        err = [];
    end
end





%% THIS IS NOT USED RIGHT NOW (ALTERNATIVE VERSION USED WITH LIBSVM) -------
function params = crossValidationLibsvm(data,labels, nFolds)
    assert(isa(data,'double'), 'Data matrix is not double');
    assert(isa(labels,'double'), 'Label array is not double');
    assert(length(labels) == size(data,1), 'Number of samples and labels does not match')
    [nSamples,~] = size(data);
    nPos = sum(labels == 1);
    nNeg = nSamples - nPos;
    
    % [C,gamma] = meshgrid(-5:2:15, -15:2:3); C = 2.^C; gamma = 2.^gamma;
    [C,gamma] = meshgrid(logspace(-1,3,3),logspace(-1,2,3));
    nCombs = numel(C);
    cvAcc = zeros(numel(C),1);
    parfor i=1:nCombs
        disp(['Cross-validation: gamma = ' num2str(gamma(i)) ', C = ' num2str(C(i))...
            '. Using value pair ' num2str(i) '/' num2str(nCombs)])
        paramString = ['-v ' num2str(nFolds) ' -g ' num2str(gamma(i)) ...
            ' -c ' num2str(C(i)) ' -w1 ' num2str(w1), ' -m ' num2str(1000)];
        cvAcc(i) = svmtrain_libsvm(labels, data, paramString);
    end
    
    % Pick the best gamma and cost - those that maximize the cv accuracy
    [~,ind] = max(cvAcc);
    params.gamma = gamma(ind);
    params.C = C(ind);
end

