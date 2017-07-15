function results = fitnlorentzian(data, parameters)
% fit n Lorentzians to xydata with automated guessing of peak locations
% Erik Bauch, May 2017
% github.com/ebauch/matlab

% data is of form [xdata ydata] were xdata and ydata 1 x n arrays
% parameters are of form [par1, par2, ..., parN],
% with par1 = # of peaks to fit

%% unfold data

xdata = data(:,1);
ydata = data(:,2);
npeaks = parameters(1); % number of peaks to fit

%% sort data by x in case it has been randomized
[xdata, xsortindex] = sort(xdata);
ydata = ydata(xsortindex);

%% estimate initial values    
    
    % turn dips into peaks
    ydatainv = 1 - ydata/max(ydata);

	% some smoothing
    navg = 1
    ydatainv = smooth(ydatainv,navg);
    
    % use findpeaks to get 
    % change minpeakheight and minpeakwidth to tweak automatic peak
    % detection
    minpeakheigth = (max(ydatainv)-min(ydatainv))/20;
    minpeakwidth = 3;
    [peaks locs widths proms] = findpeaks(ydatainv,'SORTSTR', 'descend', 'MINPEAKHEIGHT', minpeakheigth, 'MINPEAKWIDTH', minpeakwidth)
    finit = xdata(flip(locs(1:npeaks)))
    
    % found peak frequencies and amplitudes
    freq = finit;
    freqamp = ydata(locs(1:npeaks));   
               
    amp = (max(ydata)-min(ydata));
    offset = (max(ydata)+min(ydata))/2;      
    lw = 0.05; %in GHZ

%% fitting

% build n-peak Lorentzian model function

model = 'A1/(1 + ((x - center1)/(gamma1/2))^2) + offset'; % first Lorentzian

for i = 2 : npeaks
   
    model = [model sprintf(' + A%d/(1 + ((x - center%d)/(gamma%d/2))^2)', i, i, i)];
    
end

           
            % intial parameters [amplitudes centers linewidths offset]                        
            gammas = lw * ones(npeaks, 1);
            startpoints = [freqamp' freq' gammas' offset];
            
            foptions = fitoptions('Method','NonlinearLeastSquares',...
                  'Algorithm','Trust-Region',...                %'Levenberg-Marquardt', 'Gauss-Newton', or 'Trust-Region'. The default is 'Trust-Region'              'MaxIter',1000,...
                  'Robust','off',... % LAR, Bisquare or off
                  'Startpoint', startpoints,...
                  'MaxFunEvals', 5000 ,...
                  'MaxIter', 5000 ,...
                  'TolFun', 10^-8);
                         
            ftype = fittype(model, 'options', foptions);
%             coeffnames(ftype) % gives the order of the parameters 

            
            [fitf, gof] = fit(xdata,ydata,ftype);
            fitf
               
%% plotting

% output results with fit function
switch npeaks
    case 1
        
        epilog = char(['f1=' num2str(round(fitf.center1,4)) ' GHz R2: ' round(num2str(gof.rsquare)),2]);
        results = sort([fitf.center1]);
        
    case 2 
        
        epilog = char(['f1=' num2str(round(fitf.center1,4)) ' f2=' num2str(round(fitf.center2,4)) ' GHz R2: ' round(num2str(gof.rsquare)),2]);
        results = sort([fitf.center1, fitf.center2]);
        
    case 3
        
        epilog = char(['f1=' num2str(round(fitf.center1,4)) ' f2=' num2str(round(fitf.center2,4))  ' f3= ' num2str(round(fitf.center3,4)) ' GHz R2: ' round(num2str(gof.rsquare)),2]);
        results = sort([fitf.center1, fitf.center2, fitf.center3]);
        
    otherwise
        
        epilog ='';
        results = [];
end

% create figure
if ~isempty(findobj('name','exp fit'))
    
    fh =  findobj('name','exp fit');
    set(0, 'currentfigure', fh);  % for figures
    clf;
    
    else
    
    figure('name','exp fit','Position',[350 200 800 800/(2*1.618)]);    %define figure handle
    
end
    
    % plot data + fit
    plot(xdata, ydata, '.-', 'MarkerSize', 7);
    text(1.0002*min(xdata), 1.005* min(ydata), epilog);
        
    
    hold on;
    plot(xdata, fitf(xdata),'r-', 'linewidth',1);
    
    xlabel('x (some unit)');
    ylabel('amplitude (some unit)');

    axis([-inf inf -inf inf]);
    
    legend off;
      
    hold on;
%     plot(freq, freqamp, 'k^');
        
end

