--
-- 客户端 --> 逻辑服务器
-- 打开下属成员消息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenUnderMemberRequest = class("OpenUnderMemberRequest", GameMessage);

--
-- 构造函数
--
function OpenUnderMemberRequest:ctor()
    OpenUnderMemberRequest.super.ctor(self);
end

--@Override
function OpenUnderMemberRequest:_OnSerial() 
end

--@Override
function OpenUnderMemberRequest:_OnDeserialize() 
end

return OpenUnderMemberRequest;
