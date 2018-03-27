--
-- 客户端 --> 逻辑服务器
-- 打开自己可进行任务
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenTaskListRequest = class("OpenTaskListRequest", GameMessage);

--
-- 构造函数
--
function OpenTaskListRequest:ctor()
    OpenTaskListRequest.super.ctor(self);
end

--@Override
function OpenTaskListRequest:_OnSerial() 
end

--@Override
function OpenTaskListRequest:_OnDeserialize() 
end

return OpenTaskListRequest;
