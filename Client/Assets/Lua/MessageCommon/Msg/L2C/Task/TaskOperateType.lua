--
-- 逻辑服务器 --> 客户端
-- 操作类型
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local TaskOperateType = class("TaskOperateType", GameMessage);

--
-- 构造函数
--
function TaskOperateType:ctor()
    TaskOperateType.super.ctor(self);
    --
    -- 操作类型
    --
    self.mType = 0;
end

--@Override
function TaskOperateType:_OnSerial() 
    self:WriteInt32(self.mType);
end

--@Override
function TaskOperateType:_OnDeserialize() 
    self.mType = self:ReadInt32();
end

return TaskOperateType;
