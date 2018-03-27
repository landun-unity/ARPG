--
-- 逻辑服务器 --> 客户端
-- 发送奖励信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local LoginGift = class("LoginGift", GameMessage);

--
-- 构造函数
--
function LoginGift:ctor()
    LoginGift.super.ctor(self);
    --
    -- 领取天数（次数）
    --
    self.days = 0;
    
    --
    -- 能否领取（ 0 fales  1  true）
    --
    self.canReceive = 0;
    
    --
    -- 奖励ID
    --
    self.giftID = 0;
end

--@Override
function LoginGift:_OnSerial() 
    self:WriteInt32(self.days);
    self:WriteInt32(self.canReceive);
    self:WriteInt32(self.giftID);
end

--@Override
function LoginGift:_OnDeserialize() 
    self.days = self:ReadInt32();
    self.canReceive = self:ReadInt32();
    self.giftID = self:ReadInt32();
end

return LoginGift;
