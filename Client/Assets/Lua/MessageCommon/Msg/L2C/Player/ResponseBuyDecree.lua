--
-- 逻辑服务器 --> 客户端
-- 刷新资源信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ResponseBuyDecree = class("ResponseBuyDecree", GameMessage);

--
-- 构造函数
--
function ResponseBuyDecree:ctor()
    ResponseBuyDecree.super.ctor(self);
    --
    -- 上一次政令刷新时间
    --
    self.days = 0;
    
    --
    -- 已经购买的次数
    --
    self.times = 0;
end

--@Override
function ResponseBuyDecree:_OnSerial() 
    self:WriteInt32(self.days);
    self:WriteInt32(self.times);
end

--@Override
function ResponseBuyDecree:_OnDeserialize() 
    self.days = self:ReadInt32();
    self.times = self:ReadInt32();
end

return ResponseBuyDecree;
