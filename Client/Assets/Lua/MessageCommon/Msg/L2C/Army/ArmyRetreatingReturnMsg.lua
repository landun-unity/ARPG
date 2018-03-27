--
-- 逻辑服务器 --> 客户端
-- 部队出征回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyRetreatingReturnMsg = class("ArmyRetreatingReturnMsg", GameMessage);

--
-- 构造函数
--
function ArmyRetreatingReturnMsg:ctor()
    ArmyRetreatingReturnMsg.super.ctor(self);
    --
    -- 玩家Id
    --
    self.playerId = 0;
end

--@Override
function ArmyRetreatingReturnMsg:_OnSerial() 
    self:WriteInt64(self.playerId);
end

--@Override
function ArmyRetreatingReturnMsg:_OnDeserialize() 
    self.playerId = self:ReadInt64();
end

return ArmyRetreatingReturnMsg;
