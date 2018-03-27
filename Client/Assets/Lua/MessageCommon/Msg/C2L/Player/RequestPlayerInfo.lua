--
-- 客户端 --> 逻辑服务器
-- 请求玩家信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestPlayerInfo = class("RequestPlayerInfo", GameMessage);

--
-- 构造函数
--
function RequestPlayerInfo:ctor()
    RequestPlayerInfo.super.ctor(self);
end

--@Override
function RequestPlayerInfo:_OnSerial() 
end

--@Override
function RequestPlayerInfo:_OnDeserialize() 

end

return RequestPlayerInfo;
