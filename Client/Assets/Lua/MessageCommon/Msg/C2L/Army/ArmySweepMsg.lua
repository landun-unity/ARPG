--
-- 客户端 --> 逻辑服务器
-- 部队扫荡
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmySweepMsg = class("ArmySweepMsg", GameMessage);

--
-- 构造函数
--
function ArmySweepMsg:ctor()
    ArmySweepMsg.super.ctor(self);
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
    
    --
    -- 资源地事件类型
    --
    self.sourceEventType = 0;
end

--@Override
function ArmySweepMsg:_OnSerial() 
    self:WriteInt64(self.playerId);
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.tiledIndex);
    self:WriteInt32(self.sourceEventType);
end

--@Override
function ArmySweepMsg:_OnDeserialize() 
    self.playerId = self:ReadInt64();
    self.buildingId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.tiledIndex = self:ReadInt32();
    self.sourceEventType = self:ReadInt32();
end

return ArmySweepMsg;
