--
-- 客户端 --> 逻辑服务器
-- 进阶卡牌
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local AdvanceOneCard = class("AdvanceOneCard", GameMessage);

--
-- 构造函数
--
function AdvanceOneCard:ctor()
    AdvanceOneCard.super.ctor(self);
    --
    -- 卡牌Id
    --
    self.advanceCardID = 0;
    
    --
    -- 移除的卡牌
    --
    self.removeCardID = 0;
    
    --
    -- 玩家Id
    --
    self.playerID = 0;
end

--@Override
function AdvanceOneCard:_OnSerial() 
    self:WriteInt64(self.advanceCardID);
    self:WriteInt64(self.removeCardID);
    self:WriteInt64(self.playerID);
end

--@Override
function AdvanceOneCard:_OnDeserialize() 
    self.advanceCardID = self:ReadInt64();
    self.removeCardID = self:ReadInt64();
    self.playerID = self:ReadInt64();
end

return AdvanceOneCard;
