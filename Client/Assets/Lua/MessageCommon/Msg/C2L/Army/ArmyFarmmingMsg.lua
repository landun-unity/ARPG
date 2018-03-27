--
-- 客户端 --> 逻辑服务器
-- 部队屯田
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyFarmmingMsg = class("ArmyFarmmingMsg", GameMessage);

--
-- 构造函数
--
function ArmyFarmmingMsg:ctor()
    ArmyFarmmingMsg.super.ctor(self);
    --
    -- 建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 部队索引
    --
    self.index = 0;
    
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
end

--@Override
function ArmyFarmmingMsg:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.tiledIndex);
end

--@Override
function ArmyFarmmingMsg:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.tiledIndex = self:ReadInt32();
end

return ArmyFarmmingMsg;
