--
-- 逻辑服务器 --> 客户端
-- 天下大势领取奖励回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ReponseGetAward = class("ReponseGetAward", GameMessage);

--
-- 构造函数
--
function ReponseGetAward:ctor()
    ReponseGetAward.super.ctor(self);
    --
    -- 表ID
    --
    self.tableId = 0;
end

--@Override
function ReponseGetAward:_OnSerial() 
    self:WriteInt32(self.tableId);
end

--@Override
function ReponseGetAward:_OnDeserialize() 
    self.tableId = self:ReadInt32();
end

return ReponseGetAward;
