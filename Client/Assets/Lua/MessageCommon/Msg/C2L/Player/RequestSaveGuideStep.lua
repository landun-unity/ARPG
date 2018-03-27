--
-- 客户端 --> 逻辑服务器
-- 同步新手引导进度
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestSaveGuideStep = class("RequestSaveGuideStep", GameMessage);

--
-- 构造函数
--
function RequestSaveGuideStep:ctor()
    RequestSaveGuideStep.super.ctor(self);
    --
    -- 新手引导进度
    --
    self.guideStep = 0;
end

--@Override
function RequestSaveGuideStep:_OnSerial() 
    self:WriteInt32(self.guideStep);
end

--@Override
function RequestSaveGuideStep:_OnDeserialize() 
    self.guideStep = self:ReadInt32();
end

return RequestSaveGuideStep;
