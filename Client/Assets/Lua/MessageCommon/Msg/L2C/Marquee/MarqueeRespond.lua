--
-- 逻辑服务器 --> 客户端
-- 招募消息体
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local MarqueeRespond = class("MarqueeRespond", GameMessage);

--
-- 构造函数
--
function MarqueeRespond:ctor()
    MarqueeRespond.super.ctor(self);
    --
    -- 跑马类型
    --
    self.marqueeType = 0;
    
    --
    -- 玩家名字
    --
    self.name = "";
    
    --
    -- 参数
    --
    self.parmter = 0;
end

--@Override
function MarqueeRespond:_OnSerial() 
    self:WriteInt32(self.marqueeType);
    self:WriteString(self.name);
    self:WriteInt32(self.parmter);
end

--@Override
function MarqueeRespond:_OnDeserialize()
    self.marqueeType = self:ReadInt32();
    self.name = self:ReadString();
    self.parmter = self:ReadInt32();
end

return MarqueeRespond;
