--
-- 逻辑服务器 --> 客户端
-- 关闭入盟申请回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ShutJoinApplyLeagueRespond = class("ShutJoinApplyLeagueRespond", GameMessage);

--
-- 构造函数
--
function ShutJoinApplyLeagueRespond:ctor()
    ShutJoinApplyLeagueRespond.super.ctor(self);
    --
    -- 是否关闭
    --
    self.isShut = false;
end

--@Override
function ShutJoinApplyLeagueRespond:_OnSerial() 
    self:WriteBoolean(self.isShut);
end

--@Override
function ShutJoinApplyLeagueRespond:_OnDeserialize() 
    self.isShut = self:ReadBoolean();
end

return ShutJoinApplyLeagueRespond;
