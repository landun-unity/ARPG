--
-- 客户端 --> 逻辑服务器
-- 屏幕中心发生变化
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ScreenCenter = class("ScreenCenter", GameMessage);

--
-- 构造函数
--
function ScreenCenter:ctor()
    ScreenCenter.super.ctor(self);
    --
    -- 屏幕中心点
    --
    self.screenCenter = 0;
end

--@Override
function ScreenCenter:_OnSerial() 
    self:WriteInt32(self.screenCenter);
end

--@Override
function ScreenCenter:_OnDeserialize() 
    self.screenCenter = self:ReadInt32();
end

return ScreenCenter;
