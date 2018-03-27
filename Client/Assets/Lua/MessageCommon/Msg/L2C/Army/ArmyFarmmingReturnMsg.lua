--
-- 逻辑服务器 --> 客户端
-- 部队屯田回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyFarmmingReturnMsg = class("ArmyFarmmingReturnMsg", GameMessage);

--
-- 构造函数
--
function ArmyFarmmingReturnMsg:ctor()
    ArmyFarmmingReturnMsg.super.ctor(self);
    --
    -- 玩家Id
    --
    self.playerId = 0;
end

--@Override
function ArmyFarmmingReturnMsg:_OnSerial() 
    self:WriteInt64(self.playerId);
end

--@Override
function ArmyFarmmingReturnMsg:_OnDeserialize() 
    self.playerId = self:ReadInt64();
end

return ArmyFarmmingReturnMsg;
