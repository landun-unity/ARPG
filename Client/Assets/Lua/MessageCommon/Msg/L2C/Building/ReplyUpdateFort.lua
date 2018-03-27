--
-- 逻辑服务器 --> 客户端
-- 删除要塞
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ReplyUpdateFort = class("ReplyUpdateFort", GameMessage);

--
-- 构造函数
--
function ReplyUpdateFort:ctor()
    ReplyUpdateFort.super.ctor(self);
end

--@Override
function ReplyUpdateFort:_OnSerial() 
end

--@Override
function ReplyUpdateFort:_OnDeserialize() 
end

return ReplyUpdateFort;
