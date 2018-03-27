--
-- 逻辑服务器 --> 客户端
-- 升级要塞时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local UpdateFortTime = class("UpdateFortTime", GameMessage);

--
-- 构造函数
--
function UpdateFortTime:ctor()
    UpdateFortTime.super.ctor(self);
    --
    -- 结束时间
    --
    self.endTime = 0;
    
    --
    -- 建筑物索引
    --
    self.index = 0;
end

--@Override
function UpdateFortTime:_OnSerial() 
    self:WriteInt64(self.endTime);
    self:WriteInt32(self.index);
end

--@Override
function UpdateFortTime:_OnDeserialize() 
    self.endTime = self:ReadInt64();
    self.index = self:ReadInt32();
end

return UpdateFortTime;
