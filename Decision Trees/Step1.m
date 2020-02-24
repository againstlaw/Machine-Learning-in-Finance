clc
clear all


% Bitcoin-USD

Quandl.api_key('TeZdxHKjdnXAeiMF9_34');


% Retrieve data from Quandl in the past 2,000 days
nDays = 2000;
mydate = datetime('2018-06-01');
% mydate = today;
startdate = mydate - nDays;
enddate = mydate -1;


% Set symbols for retrieving data
symbol1 = {'BCHAIN/MKPRU', ...% Bitcoin Market Price USD
'BCHAIN/MWNUS', ...% Bitcoin My Wallet Number of Users
'BCHAIN/DIFF',  ...% Bitcoin Difficulty
'BCHAIN/MWNTD', ...% Bitcoin My Wallet Number of Transaction Per Day
'BCHAIN/MWTRV', ...% Bitcoin My Wallet Transaction Volume
'BCHAIN/AVBLS', ...% Bitcoin Average Block Size
'BCHAIN/BLCHS', ...% Bitcoin api.blockchain Size
'BCHAIN/ATRCT', ...% Bitcoin Median Transaction Confirmation Time
'BCHAIN/MIREV', ...% Bitcoin Miners Revenue
'BCHAIN/HRATE', ...% Bitcoin Hash Rate
'BCHAIN/CPTRA', ...% Bitcoin Cost Per Transaction
'BCHAIN/TRVOU', ...% Bitcoin USD Exchange Trade Volume
'BCHAIN/ETRVU', ...% Bitcoin Estimated Transaction Volume USD
'BCHAIN/TOUTV', ...% Bitcoin Total Output Volume
'BCHAIN/NTRBL', ...% Bitcoin Number of Transaction per Block
'BCHAIN/NTRAT', ...% Bitcoin Total Number of Transactions
'BCHAIN/TRFUS', ...% Bitcoin Total Transaction Fees USD
'BCHAIN/MKTCP', ...% Bitcoin Market Capitalization
'BCHAIN/TOTBC'};   % Total Bitcoins


d = cell(1,numel(symbol1));
ts = Quandl.get(symbol1{1}, 'start_date', startdate, 'end_date', enddate);
ts.TimeInfo.Format = 'dd-mmm-yyyy';

% convert time series into timetable
Price=ts.Data;
tstime = getabstime(ts);
Date=datetime(tstime,'InputFormat','dd-MMM-yyyy');
d{1}=timetable(Date,Price);

T = d{1};
for i = 2:numel(symbol1)
    ts = Quandl.get(symbol1{i}, 'start_date', startdate, 'end_date', enddate);
    ts.TimeInfo.Format = 'dd-mmm-yyyy';
    
    % convert time series into timetable
    Price=ts.Data;
    tstime = getabstime(ts);
    Date=datetime(tstime,'InputFormat','dd-MMM-yyyy');
    d{i}=timetable(Date,Price);
    
    T = synchronize(T,d{i});
end


symbol2 = regexprep(symbol1,'BCHAIN/',''); % Tighten symbols' name
T.Properties.VariableNames = symbol2;


T = timetable2table(T);
clearvars -except T
if exist('data','dir') ~= 7
    mkdir('data');
end

save 'data/rawData.mat'



