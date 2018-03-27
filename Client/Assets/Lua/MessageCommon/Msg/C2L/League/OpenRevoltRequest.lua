--
-- 客户端 --> 逻辑服务器
-- 打开反叛界面请求
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenRevoltRequest = class("OpenRevoltRequest", GameMessage);

--
-- 构造函数
--
function OpenRevoltRequest:ctor()
    OpenRevoltRequest.super.ctor(self);
end

--@Override
function OpenRevoltRequest:_OnSerial() 
end

--@Override
function OpenRevoltRequest:_OnDeserialize() 
end

return OpenRevoltRequest;
