--
-- 客户端 --> 逻辑服务器
-- 申请领取任务奖励
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local AwardRequest = class("AwardRequest", GameMessage);

--
-- 构造函数
--
function AwardRequest:ctor()
    AwardRequest.super.ctor(self);
    --
    -- 任务id
    --
    self.taskId = 0;
end

--@Override
function AwardRequest:_OnSerial() 
    self:WriteInt64(self.taskId);
end

--@Override
function AwardRequest:_OnDeserialize() 
    self.taskId = self:ReadInt64();
end

return AwardRequest;
