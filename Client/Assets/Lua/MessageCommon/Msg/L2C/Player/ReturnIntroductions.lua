--
-- 逻辑服务器 --> 客户端
-- 税收说明回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ReturnIntroductions = class("ReturnIntroductions", GameMessage);

--
-- 构造函数
--
function ReturnIntroductions:ctor()
    ReturnIntroductions.super.ctor(self);
    --
    -- 税收金币
    --
    self.revenueGold = 0;
    
    --
    -- 野城税收
    --
    self.wildCityRevenueGold = 0;
end

--@Override
function ReturnIntroductions:_OnSerial() 
    self:WriteInt32(self.revenueGold);
    self:WriteInt32(self.wildCityRevenueGold);
end

--@Override
function ReturnIntroductions:_OnDeserialize() 
    self.revenueGold = self:ReadInt32();
    self.wildCityRevenueGold = self:ReadInt32();
end

return ReturnIntroductions;
