 
clear all
close all

% read in gauge data text file downloaded from USGS website
string_data = readmatrix('Gauge_Data.txt','OutputType','string');

%create matrix to store variables we are concerned with
data = string_data(:,[5 7]);

% change output type
data = double(data);

% extract the year vaue in the string and concatenate data variable
data = [year(datetime(string_data(:,3))) data];

% sort rows from least to greatest flow rates
data = sortrows(data,2,'descend');

% create vector of ranked values
k = [1:length(data)]';

% break out variables for ease of calculation
year = data(:,1);
flow = data(:,2);
stage = data(:,3);

%calculate reterna interval for each data point
T = (length(flow)+1)./k;

% find bracketing values for return interval of choice

% select return interval for which to determine flow rate
RI = 2;

if RI == 1
    QRI = min(flow);
    
    else
    plusindx = find(T == min(T(T-RI>=0)));
    minusindx = find(T == max(T(T-RI<=0)));
    plusT = T(plusindx);
    minusT = T(minusindx);
    plusQ = flow(plusindx);
    minusQ = flow(minusindx);

    QRI = plusQ - ((plusT-RI).*(plusQ-minusQ))./(plusT-minusT);

    if isnan(QRI) == 1
        QRI = flow(plusindx);
    end
end

% find return interval of observed value
Qobs = 1600;

%find bracketing values and do simple linear interpolation
plusQindx = find(flow == min(flow(flow-Qobs>=0)));
minusQindx = find(flow == max(flow(flow-Qobs<=0)));
plusTobs = T(plusQindx);
minusTobs = T(minusQindx);
plusQobs = flow(plusQindx);
minusQobs = flow(minusQindx);

Tobs = plusTobs - ((plusQobs-Qobs).*(plusTobs-minusTobs))./(plusQobs-minusQobs);

if isnan(Tobs) == 1
    Tobs = T(plusQindx);
end


% plot  recurrence interval
h = scatter(T,flow);
set(gca,'Yscale','log')
set(gca,'Xscale','log')
grid on
box on
ylabel('Flow rate (cfs)')
xlabel('Return internal (yrs)')



















