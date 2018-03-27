--
-- 逻辑服务器 --> 客户端
-- 部队出征回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmySweepReturnMsg = class("ArmySweepReturnMsg", GameMessage);

--
-- 构造函数
--
function ArmySweepReturnMsg:ctor()
    ArmySweepReturnMsg.super.ctor(self);
    --
    -- 玩家Id
    --
    self.playerId = 0;
end

--@Override
function ArmySweepReturnMsg:_OnSerial() 
    self:WriteInt64(self.playerId);
end

--@Override
function ArmySweepReturnMsg:_OnDeserialize() 
    self.playerId = self:ReadInt64();
end

return ArmySweepReturnMsg;
