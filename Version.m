function Version()

LocalVerInfo = GetLocalVerInfo();
githubVerInfo = GetgithubVerInfo();

LastVerCheckResult = LastVerCheck(LocalVerInfo,githubVerInfo);

if LastVerCheckResult
    fprintf('EigerFunc is the last version %s.\n',LocalVerInfo.Version)
else
    EigerFuncAutoUpdate();
    fprintf('EigerFunc auto update from %s to %s\n',LocalVerInfo.Version,githubVerInfo.Version)
    EigerFuncAutoUpdate();
end

function EigerFuncAutoUpdate()
if exist(fullfile(pwd,'EigerFun'),'dir')
    EigerFuncFF = fullfile(pwd,'EigerFun');
elseif  exist(fullfile(pwd,'@EigerFunc'),'dir')
    EigerFuncFF = fullfile(pwd,'@EigerFunc');
end
temp = unzip('https://github.com/github-ywtsai/EigerFunc/archive/refs/heads/master.zip',pwd);
UNZIPFF = temp{1};
movefile(UNZIPFF,EigerFuncFF)

function LocalVerInfo = GetLocalVerInfo()
if exist(fullfile(pwd,'VerInfo.mat'),'file')
    VerFP = fullfile(pwd,'VerInfo');
elseif  exist(fullfile(pwd,'@EigerFunc','VerInfo'),'file')
    VerFP = fullfile(pwd,'@EigerFunc','VerInfo');
end

Temp = load(VerFP,'-mat');
LocalVerInfo = Temp.VerInfo;

function githubVerInfo = GetgithubVerInfo()
githuburl = 'https://github.com/github-ywtsai/EigerFunc/raw/master/VerInfo';
githubVerInfoFP = websave('temp', githuburl);
githubtemp = load(githubVerInfoFP,'-mat');
githubVerInfo = githubtemp.VerInfo;
delete(githubVerInfoFP)

function LastVerCheckResult = LastVerCheck(LocalVerInfo,githubVerInfo)
LocalVer = cellfun(@(X)str2double(X),split(LocalVerInfo.Version,'.'));
githubVer = cellfun(@(X)str2double(X),split(githubVerInfo.Version,'.'));

Check = LocalVer < githubVer;
LastVerCheckResult = true;
if Check(1)
    LastVerCheckResult = false;
else
    if Check(2)
        LastVerCheckResult = false;
    else
        if Check(3)
            LastVerCheckResult = false;
        else
        end
    end
end

