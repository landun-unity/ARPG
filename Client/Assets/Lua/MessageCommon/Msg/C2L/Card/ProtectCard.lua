--
-- 客户端 --> 逻辑服务器
-- 卡牌保护
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ProtectCard = class("ProtectCard", GameMessage);

--
-- 构造函数
--
function ProtectCard:ctor()
    ProtectCard.super.ctor(self);
    --
    -- 卡牌Id
    --
    self.cardID = 0;
    
    --
    -- 是否关闭
    --
    self.isProtect = false;
end

--@Override
function ProtectCard:_OnSerial() 
    self:WriteInt64(self.cardID);
    self:WriteBoolean(self.isProtect);
end

--@Override
function ProtectCard:_OnDeserialize() 
    self.cardID = self:ReadInt64();
    self.isProtect = self:ReadBoolean();
end

return ProtectCard;
