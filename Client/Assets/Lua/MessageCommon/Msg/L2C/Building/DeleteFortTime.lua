--
-- 逻辑服务器 --> 客户端
-- 放弃要塞时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local DeleteFortTime = class("DeleteFortTime", GameMessage);

--
-- 构造函数
--
function DeleteFortTime:ctor()
    DeleteFortTime.super.ctor(self);
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
function DeleteFortTime:_OnSerial() 
    self:WriteInt64(self.endTime);
    self:WriteInt32(self.index);
end

--@Override
function DeleteFortTime:_OnDeserialize() 
    self.endTime = self:ReadInt64();
    self.index = self:ReadInt32();
end

return DeleteFortTime;
