--
-- 逻辑服务器 --> 客户端
-- 进阶卡牌成功
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local AdvancerCardSusses = class("AdvancerCardSusses", GameMessage);

--
-- 构造函数
--
function AdvancerCardSusses:ctor()
    AdvancerCardSusses.super.ctor(self);
end

--@Override
function AdvancerCardSusses:_OnSerial() 
end

--@Override
function AdvancerCardSusses:_OnDeserialize() 
end

return AdvancerCardSusses;
