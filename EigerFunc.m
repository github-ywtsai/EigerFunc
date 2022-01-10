classdef EigerFunc
    methods (Static = true)
        Ver = Version();
        EnvConfig = EnvConfiguration();
        
        MasterInfo =ReadMaster(MasterFP);
        SingleFrameData = ReadData(MasterInfo,RequestSN,XRange,YRange);
        
    end
end