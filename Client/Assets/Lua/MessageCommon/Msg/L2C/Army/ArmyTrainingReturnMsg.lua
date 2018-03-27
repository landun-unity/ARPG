--
-- 逻辑服务器 --> 客户端
-- 部队出征回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyTrainingReturnMsg = class("ArmyTrainingReturnMsg", GameMessage);

--
-- 构造函数
--
function ArmyTrainingReturnMsg:ctor()
    ArmyTrainingReturnMsg.super.ctor(self);
    --
    -- 玩家Id
    --
    self.playerId = 0;
end

--@Override
function ArmyTrainingReturnMsg:_OnSerial() 
    self:WriteInt64(self.playerId);
end

--@Override
function ArmyTrainingReturnMsg:_OnDeserialize() 
    self.playerId = self:ReadInt64();
end

return ArmyTrainingReturnMsg;
