--
-- 客户端 --> 逻辑服务器
-- 领取月卡
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GetMonthCard = class("GetMonthCard", GameMessage);

--
-- 构造函数
--
function GetMonthCard:ctor()
    GetMonthCard.super.ctor(self);
end

--@Override
function GetMonthCard:_OnSerial() 
end

--@Override
function GetMonthCard:_OnDeserialize() 
end

return GetMonthCard;
