--
-- 逻辑服务器 --> 客户端
-- 下次禅让时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local DemiseTime = class("DemiseTime", GameMessage);

--
-- 构造函数
--
function DemiseTime:ctor()
    DemiseTime.super.ctor(self);
    --
    -- 下次禅让时间
    --
    self.demisTime = 0;
    
    --
    -- 禅让者id
    --
    self.demisePlayerId = 0;
    
    --
    -- 被禅让者id
    --
    self.beDemisePlayerId = 0;
end

--@Override
function DemiseTime:_OnSerial() 
    self:WriteInt64(self.demisTime);
    self:WriteInt64(self.demisePlayerId);
    self:WriteInt64(self.beDemisePlayerId);
end

--@Override
function DemiseTime:_OnDeserialize() 
    self.demisTime = self:ReadInt64();
    self.demisePlayerId = self:ReadInt64();
    self.beDemisePlayerId = self:ReadInt64();
end

return DemiseTime;
