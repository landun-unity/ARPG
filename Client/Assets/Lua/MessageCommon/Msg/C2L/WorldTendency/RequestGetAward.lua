--
-- 客户端 --> 逻辑服务器
-- 请求天下大势领取奖励
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestGetAward = class("RequestGetAward", GameMessage);

--
-- 构造函数
--
function RequestGetAward:ctor()
    RequestGetAward.super.ctor(self);
    --
    -- 表ID
    --
    self.tableId = 0;
end

--@Override
function RequestGetAward:_OnSerial() 
    self:WriteInt32(self.tableId);
end

--@Override
function RequestGetAward:_OnDeserialize() 
    self.tableId = self:ReadInt32();
end

return RequestGetAward;
