--
-- 客户端 --> 逻辑服务器
-- 打开拥有野外建筑请求
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenOwnWildBuildRequest = class("OpenOwnWildBuildRequest", GameMessage);

--
-- 构造函数
--
function OpenOwnWildBuildRequest:ctor()
    OpenOwnWildBuildRequest.super.ctor(self);
end

--@Override
function OpenOwnWildBuildRequest:_OnSerial() 
end

--@Override
function OpenOwnWildBuildRequest:_OnDeserialize() 
end

return OpenOwnWildBuildRequest;
