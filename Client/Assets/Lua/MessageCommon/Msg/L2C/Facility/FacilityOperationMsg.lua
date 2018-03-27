--
-- 逻辑服务器 --> 客户端
-- 设施操作枚举
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local FacilityOperationMsg = class("FacilityOperationMsg", GameMessage);

--
-- 构造函数
--
function FacilityOperationMsg:ctor()
    FacilityOperationMsg.super.ctor(self);
    --
    -- 类型
    --
    self.operType = 0;
end

--@Override
function FacilityOperationMsg:_OnSerial() 
    self:WriteInt32(self.operType);
end

--@Override
function FacilityOperationMsg:_OnDeserialize() 
    self.operType = self:ReadInt32();
end

return FacilityOperationMsg;
