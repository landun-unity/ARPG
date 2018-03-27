--
-- 客户端 --> 逻辑服务器
-- 部队调动
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyTransferomMsg = class("ArmyTransferomMsg", GameMessage);

--
-- 构造函数
--
function ArmyTransferomMsg:ctor()
    ArmyTransferomMsg.super.ctor(self);
    --
    -- 玩家Id
    --
    self.playerId = 0;
    
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
function ArmyTransferomMsg:_OnSerial() 
    self:WriteInt64(self.playerId);
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.tiledIndex);
end

--@Override
function ArmyTransferomMsg:_OnDeserialize() 
    self.playerId = self:ReadInt64();
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.tiledIndex = self:ReadInt32();
end

return ArmyTransferomMsg;
