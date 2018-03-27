--
-- 客户端 --> 逻辑服务器
-- 请求英雄卡牌
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestHeroCard = class("RequestHeroCard", GameMessage);

--
-- 构造函数
--
function RequestHeroCard:ctor()
    RequestHeroCard.super.ctor(self);
    --
    -- 页数
    --
    self.page = 0;
end

--@Override
function RequestHeroCard:_OnSerial() 
    self:WriteInt32(self.page);
end

--@Override
function RequestHeroCard:_OnDeserialize() 
    self.page = self:ReadInt32();
end

return RequestHeroCard;
