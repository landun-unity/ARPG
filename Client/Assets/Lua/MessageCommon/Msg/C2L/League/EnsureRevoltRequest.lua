--
-- 客户端 --> 逻辑服务器
-- 确定反叛请求
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local EnsureRevoltRequest = class("EnsureRevoltRequest", GameMessage);

--
-- 构造函数
--
function EnsureRevoltRequest:ctor()
    EnsureRevoltRequest.super.ctor(self);
end

--@Override
function EnsureRevoltRequest:_OnSerial() 
end

--@Override
function EnsureRevoltRequest:_OnDeserialize() 
end

return EnsureRevoltRequest;
