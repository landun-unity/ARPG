--
-- 逻辑服务器 --> 客户端
-- 觉醒卡牌成功
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local AwakeOneCardSusses = class("AwakeOneCardSusses", GameMessage);

--
-- 构造函数
--
function AwakeOneCardSusses:ctor()
    AwakeOneCardSusses.super.ctor(self);
end

--@Override
function AwakeOneCardSusses:_OnSerial() 
end

--@Override
function AwakeOneCardSusses:_OnDeserialize() 
end

return AwakeOneCardSusses;
