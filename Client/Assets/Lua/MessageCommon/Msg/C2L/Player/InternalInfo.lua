--
-- 客户端 --> 逻辑服务器
-- 请求税收
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local InternalInfo = class("InternalInfo", GameMessage);

--
-- 构造函数
--
function InternalInfo:ctor()
    InternalInfo.super.ctor(self);
end

--@Override
function InternalInfo:_OnSerial() 
end

--@Override
function InternalInfo:_OnDeserialize() 
end

return InternalInfo;
