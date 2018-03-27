--region *.lua
--Date
local GameService = require("FrameWork/Game/GameService")
LogManager = class("LogManager", GameService)

function LogManager:ctor()    
    LogManager._instance = self;
    self.openLog = false;       --是否开启Log,默认为true,发布时改为false
end

-- 单例
function LogManager:Instance()
    return LogManager._instance;
end

-- 清空数据
function LogManager:Clear()

end


function LogManager:Log(content)
    if self.openLog == true then       
        print(content);
    else
        return;
    end
end

function LogManager:BeginSample(content)
    if self.openLog == true then       
        UnityEngine.Profiler.BeginSample(content);
    else
        return;
    end
end


function LogManager:EndSample()
    if self.openLog == true then       
        UnityEngine.Profiler.EndSample();
    else
        return;
    end
end


return LogManager
