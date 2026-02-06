% =========================================================================
% MAIN 2 : (Sub-sample Analysis)

clear all; close all; clc;



subsamples = {
    [1994 2], [2007 12], 'Period 1 (1994-2007)';
    [2008 1], [2019 12], 'Period 2 (2008-2019)';
    [2020 1], [2025 12],  'Period 3 (2020-2025)' 
};


modname = 'us1';
idscheme = 'sgnm2'; 

mnames = {'ff4_hf','sp500_hf'}; 
ynames = {'gs1','logsp500','us_rgdp','us_gdpdef','ebpnew'}; 

prior.lags = 6; 
prior.minnesota.tightness = .2;
prior.minnesota.decay = 1;
prior.Nm = length(mnames);

gssettings.ndraws = 2000; 
gssettings.burnin = 1000;
gssettings.saveevery = 2;
gssettings.computemarglik = 0;


ym2t = @(x) x(1)+x(2)/12 - 1/24;
t2datestr = @(t) [num2str(floor(t)) char(repmat(109,length(t),1)) num2str(12*(t-floor(t)+1/24),'%02.0f')];
findym = @(x,t) find(abs(t-ym2t(x))<1e-6);


datafname = 'data_monthly_clean.csv' 
d = importdata(datafname); 
dat = d.data; 
txt = d.colheaders;

ynames_nice = ynames; 
mnames_nice = mnames;
nonst = zeros(length(ynames),1);


for i = 1:size(subsamples, 1)
    
    current_start = subsamples{i, 1};
    current_end   = subsamples{i, 2};
    period_name   = subsamples{i, 3};
    
    fprintf('\n------------------------------------------------\n');
    fprintf('TRAITEMENT DE LA PÉRIODE : %s\n', period_name);
    fprintf('------------------------------------------------\n');
    
    % Définition du sample local
    spl = [current_start; current_end];
    
    % Filtrage des données (Logique JK)
    tbeg = find(dat(:,1)==spl(1,1) & dat(:,2)==spl(1,2)); 
    if isempty(tbeg), tbeg=1; end
    tend = find(dat(:,1)==spl(2,1) & dat(:,2)==spl(2,2)); 
    if isempty(tend), tend=size(dat,1); end
    
    ysel = findstrings([mnames ynames], txt(1,:));
    
  
    data_sub = struct();
    data_sub.names = [mnames ynames];
    data_sub.Nm = length(mnames);
    data_sub.y = dat(tbeg:tend, ysel);
    data_sub.w = ones(size(data_sub.y,1),1);
    data_sub.time = linspace(ym2t(dat(tbeg,1:2)), ym2t(dat(tend,1:2)), size(data_sub.y,1))';
    

    data_sub.y(isnan(data_sub.y)) = 0;
    
  
    fprintf('Estimation du VAR (Lags = %d)...\n', prior.lags);
    res = VAR_withiid1kf(data_sub, prior, gssettings);
    
 
    fprintf('Identification des chocs...\n');
    MAlags = 24; 
    N = length(data_sub.names);
    
   
    shocknames = [{'Monetary Policy', 'CB Information'} mnames(2+1:end) ynames];
    dims = {[1 2]};
    test_restr = @(irfs) irfs(1,1,1) > 0 && irfs(2,1,1) < 0 && ... 
                         irfs(1,2,1) > 0 && irfs(2,2,1) > 0;    
    b_normalize = ones(1,N);
    
    irfs_draws = resirfssign(res, MAlags, dims, test_restr, b_normalize, 1000);
   
   
    vars_to_plot = [3, 4, 5, 6, 7]; 
    ss = 1:2; % Chocs 1 (MP) et 2 (Info)
   
    full_names = {'Surprise Taux', 'Surprise Bourse', ...
                  'GS1', 'S&P 500', 'Ind Prod', 'CPI', 'EBP'};
    
    f = plot_irfs_draws(irfs_draws, vars_to_plot, ss, ...
        full_names, ...     
        full_names, ...     
        {'Monetary Policy','CB Information'}, ...
        idscheme, [0.5 0.16 0.84], [0 0 1], '', []);
    

    sgtitle(period_name, 'FontSize', 16, 'FontWeight', 'bold');
    
   
    filename_clean = regexprep(period_name, '[ :()]', '_');
    savename = ['IRF_' filename_clean '.png'];
  
    saveas(gcf, savename);
    fprintf('Graphique sauvegardé : %s\n', savename);
end

