clear probdata femodel analysisopt gfundata randomfield systems results output_filename
output_filename = 'simple.txt';


%% PROBDATA
% marginal distribution for each random variable
probdata.marg(1,:) = [ 1 1000 100 1000 0 0 0 0 0];
probdata.marg(2,:) = [ 1 200e3 1000 200e3 0 0 0 0 0];

%correlation matrix
probdata.correlation = eye(2);
% type of joint distribution
probdata.transf_type = 3;

% Method for computation of the modified Nataf correlation matrix
probdata.Ro_method   = 1;

% Flag for computation of sensitivities w.r.t. means, standard deviations, parameters and correlation coefficients
probdata.flag_sens   = 1;

probdata.parameter = distribution_parameter(probdata.marg);

%% ANALYSISOPT
analysisopt.echo_flag = 1;                   % 1: FERUM interactive mode, 0: FERUM silent mode
%analysisopt.analysistype = 10;

analysisopt.multi_proc           = 1;        % 1: block_size g-calls sent simultaneously
                                             %    - gfunbasic.m is used and a vectorized version of gfundata.expression is available.
                                             %      The number of g-calls sent simultaneously (block_size) depends on the memory
                                             %      available on the computer running FERUM.
                                             %    - gfunxxx.m user-specific g-function is used and able to handle block_size computations
                                             %      sent simultaneously, on a cluster of PCs or any other multiprocessor computer platform.
                                             % 0: g-calls sent sequentially
analysisopt.block_size           = 500000;   % Number of g-calls to be sent simultaneously

% FORM analysis options
analysisopt.i_max                = 100;      % Maximum number of iterations allowed in the search algorithm
analysisopt.e1                   = 0.001;    % Tolerance on how close design point is to limit-state surface
analysisopt.e2                   = 0.001;    % Tolerance on how accurately the gradient points towards the origin
analysisopt.step_code            = 0;        % 0: step size by Armijo rule, otherwise: given value is the step size
analysisopt.Recorded_u           = 1;        % 0: u-vector not recorded at all iterations, 1: u-vector recorded at all iterations
analysisopt.Recorded_x           = 1;        % 0: x-vector not recorded at all iterations, 1: x-vector recorded at all iterations

% FORM, SORM analysis options
analysisopt.grad_flag            = 'ffd';    % 'ddm': direct differentiation, 'ffd': forward finite difference
analysisopt.ffdpara              = 50;     % Parameter for computation of FFD estimates of gradients - Perturbation = stdv/analysisopt.ffdpara;
                                             % Recommended values: 1000 for basic limit-state functions, 50 for FE-based limit-state functions
analysisopt.ffdpara_thetag       = 50;     % Parameter for computation of FFD estimates of dbeta_dthetag
                                             % perturbation = thetag/analysisopt.ffdpara_thetag if thetag ~= 0 or 1/analysisopt.ffdpara_thetag if thetag == 0;
                                             % Recommended values: 1000 for basic limit-state functions, 100 for FE-based limit-state functions

% Simulation analysis (MC,IS,DS,SS) and distribution analysis options
analysisopt.num_sim              = 1000;     % Number of samples (MC,IS), number of samples per subset step (SS) or number of directions (DS)
analysisopt.rand_generator       = 0;        % 0: default rand matlab function, 1: Mersenne Twister (to be preferred)

% Simulation analysis (MC, IS) and distribution analysis options
analysisopt.sim_point            = 'origin'; % 'dspt': design point, 'origin': origin in standard normal space (simulation analysis)
analysisopt.stdv_sim             = 1;        % Standard deviation of sampling distribution in simulation analysis

% Simulation analysis (MC, IS)
analysisopt.target_cov           = 0.05;     % Target coefficient of variation for failure probability
analysisopt.lowRAM               = 0;        % 1: memory savings allowed, 0: no memory savings allowed

% Directional Simulation (DS) analysis options
analysisopt.dir_flag             = 'random'; % 'det': deterministic points uniformly distributed on the unit hypersphere using eq_point_set.m function
                                             % 'random': random points uniformly distributed on the unit hypersphere
analysisopt.rho                  = 8;        % Max search radius in standard normal space for Directional Simulation analysis
analysisopt.tolx                 = 1e-5;     % Tolerance for searching zeros of g function
analysisopt.keep_a               = 1;        % Flag for storage of a-values which gives axes along which simulations are carried out
analysisopt.keep_r               = 1;        % Flag for storage of r-values for which g(r) = 0
analysisopt.sigmafun_write2file  = 0;        % Set to 0

% Subset Simulation (SS) analysis options
analysisopt.width                = 2;        % Width of the proposal uniform pdfs
analysisopt.pf_target            = 0.1;      % Target probability for each subset step
analysisopt.flag_cov_pf_bounds   = 1;        % 1: calculate upper and lower bounds of the coefficient of variation of pf, 0: no calculation 
analysisopt.ss_restart_from_step = -inf;     % i>=0 : restart from step i, -inf : all steps, no record (default), -1 : all steps, record all
analysisopt.flag_plot            = 0;        % 1: plots at each step (2 r.v. examples only), 0: no plots
analysisopt.flag_plot_gen        = 0;        % 1: intermediate plots for each MCMC chain (2 r.v. examples only), 0: no plots

% 2SMART analysis options
analysisopt.num_sim_sdu          = [ 50 50 ];         % Nu number of points ( [ first subset-like step, next steps], same values by default )
analysisopt.num_sim_norm         = [ 100 100 ];       % Nn number of points ( [ first subset-like step, next steps], same values by default )
nrv = size(probdata.marg,1);
analysisopt.buf_size             = round(1.25e7/nrv); % RAM-size dependent parameter (important for large number of random variables)
analysisopt.svm_buf_size         = 3500^2;            % RAM-size dependent parameter for eval_svm.m function
analysisopt.flag_var_rbf         = 0;                 % 0: cross validation at the 1st subset-like step only, 1: cross validation at all steps


%% GFUNDATA                                              
gfundata(1).evaluator = 'basic';
gfundata(1).type = 'expression';
gfundata(1).parameter = 'no';
gfundata(1).expression = 'limit_state_zeus(x1,x2)';

gfundata(1).flag_sens  = 0;

%% FEMODEL
femodel = 0;
randomfield.mesh = 0;