--
-- 客户端 --> 逻辑服务器
-- 重置卡牌
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ResetPoint = class("ResetPoint", GameMessage);

--
-- 构造函数
--
function ResetPoint:ctor()
    ResetPoint.super.ctor(self);
    --
    -- 卡牌Id
    --
    self.cardID = 0;
end

--@Override
function ResetPoint:_OnSerial() 
    self:WriteInt64(self.cardID);
end

--@Override
function ResetPoint:_OnDeserialize() 
    self.cardID = self:ReadInt64();
end

return ResetPoint;
