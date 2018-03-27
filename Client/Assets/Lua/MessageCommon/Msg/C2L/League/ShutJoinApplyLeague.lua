--
-- 客户端 --> 逻辑服务器
-- 打开/关闭同盟申请
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ShutJoinApplyLeague = class("ShutJoinApplyLeague", GameMessage);

--
-- 构造函数
--
function ShutJoinApplyLeague:ctor()
    ShutJoinApplyLeague.super.ctor(self);
    --
    -- 是否关闭
    --
    self.isShut = false;
end

--@Override
function ShutJoinApplyLeague:_OnSerial() 
    self:WriteBoolean(self.isShut);
end

--@Override
function ShutJoinApplyLeague:_OnDeserialize() 
    self.isShut = self:ReadBoolean();
end

return ShutJoinApplyLeague;
