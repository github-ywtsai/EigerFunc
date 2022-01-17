function Output = Read(varargin)
% useage:
% Read(Master File Path [, option1[, value1], option2[, value2],.....])
% option:
% sheet: for specific required data sheet
% X: x range
% Y: y range
% PixelMask: output PixelMask
% Masked: output Masked data unsing PixelMask
% return empty [] when error occurs

Output = []; % if error occurs, return empty.

MasterFP = varargin{1};
if ~exist(MasterFP,'File')
    fprintf('\nMaster file ''%s'' does not exist.\n',MasterFP)
    return
end
MasterInfo = EigerFunc.ReadMaster(MasterFP);

% default setting for options
RequiredDataSheet = 1;
XRange = [1,MasterInfo.XPixelsInDetector];
YRange = [1,MasterInfo.YPixelsInDetector];
RequirePixelMask = false;
MaskData = false;

% option
if nargin ~= 1
    OptionCheck = cellfun(@(X)ischar(X),varargin);
    OptionIdx = find(OptionCheck);
    OptionIdx(OptionIdx == 1) = []; % remove the master file part
    for OptionSN = OptionIdx
        OptionType = lower(varargin{OptionSN});
        switch OptionType
            case 'sheet'
                OptionValue = varargin{OptionSN+1};
                RequiredDataSheet = OptionValue;
            case 'x'
                OptionValue = varargin{OptionSN+1};
                if isempty(OptionValue)
                    OptionValue = [1,MasterInfo.XPixelsInDetector];
                end
                XRange = OptionValue;
            case 'y'
                OptionValue = varargin{OptionSN+1};
                if isempty(OptionValue)
                    OptionValue = [1,MasterInfo.YPixelsInDetector];
                end
                YRange = OptionValue;
            case 'pixelmask'
                RequirePixelMask = true;
            case 'masked'
                MaskData = true;
        end
    end
end

XSize = XRange(2) - XRange(1) +1;
YSize = YRange(2) - YRange(1) +1;

if RequirePixelMask
    Output = MasterInfo.PixelMask;
else
    RequireSheetNum = numel(RequiredDataSheet);
    Container = zeros(YSize,XSize,RequireSheetNum);
    for ContainerSN = 1:RequireSheetNum
        RequestSheet =  RequiredDataSheet(ContainerSN);
        Container(:,:,ContainerSN) = EigerFunc.ReadData(MasterInfo,RequestSheet,XRange,YRange);
    end
    
    if MaskData
        LogicalMask = MasterInfo.PixelMask(YRange(1):YRange(2),XRange(1):XRange(2));
        Mask = ones(size(LogicalMask));
        Mask(LogicalMask) = nan;
        Container = Container .* Mask;
    end
    
    Data = Container;
    Output = Data;
end
