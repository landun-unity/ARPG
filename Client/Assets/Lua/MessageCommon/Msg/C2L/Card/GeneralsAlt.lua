--
-- 客户端 --> 逻辑服务器
-- 武将图鉴请求
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GeneralsAlt = class("GeneralsAlt", GameMessage);

--
-- 构造函数
--
function GeneralsAlt:ctor()
    GeneralsAlt.super.ctor(self);
end

--@Override
function GeneralsAlt:_OnSerial() 
end

--@Override
function GeneralsAlt:_OnDeserialize() 
end

return GeneralsAlt;
