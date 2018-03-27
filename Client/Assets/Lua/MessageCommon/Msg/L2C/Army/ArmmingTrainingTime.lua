--
-- 逻辑服务器 --> 客户端
-- 部队练兵
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmmingTrainingTime = class("ArmmingTrainingTime", GameMessage);

--
-- 构造函数
--
function ArmmingTrainingTime:ctor()
    ArmmingTrainingTime.super.ctor(self);
    --
    -- 部队练兵时间
    --
    self.traningTime = 0;
end

--@Override
function ArmmingTrainingTime:_OnSerial() 
    self:WriteInt64(self.traningTime);
end

--@Override
function ArmmingTrainingTime:_OnDeserialize() 
    self.traningTime = self:ReadInt64();
end

return ArmmingTrainingTime;
