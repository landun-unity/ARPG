--
-- 逻辑服务器 --> 客户端
-- 部队驻守回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyGarrisonReturnMsg = class("ArmyGarrisonReturnMsg", GameMessage);

--
-- 构造函数
--
function ArmyGarrisonReturnMsg:ctor()
    ArmyGarrisonReturnMsg.super.ctor(self);
    --
    -- 玩家Id
    --
    self.playerId = 0;
end

--@Override
function ArmyGarrisonReturnMsg:_OnSerial() 
    self:WriteInt64(self.playerId);
end

--@Override
function ArmyGarrisonReturnMsg:_OnDeserialize() 
    self.playerId = self:ReadInt64();
end

return ArmyGarrisonReturnMsg;
