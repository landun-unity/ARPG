--
-- 逻辑服务器 --> 客户端
-- 屏幕中心点的回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ScreenCenterReply = class("ScreenCenterReply", GameMessage);

--
-- 构造函数
--
function ScreenCenterReply:ctor()
    ScreenCenterReply.super.ctor(self);
end

--@Override
function ScreenCenterReply:_OnSerial() 
end

--@Override
function ScreenCenterReply:_OnDeserialize() 
end

return ScreenCenterReply;
