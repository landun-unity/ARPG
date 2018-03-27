--
-- 客户端 --> 逻辑服务器
-- 请求打开排行榜
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenPlayerRanklistRequest = class("OpenPlayerRanklistRequest", GameMessage);

--
-- 构造函数
--
function OpenPlayerRanklistRequest:ctor()
    OpenPlayerRanklistRequest.super.ctor(self);
end

--@Override
function OpenPlayerRanklistRequest:_OnSerial() 
end

--@Override
function OpenPlayerRanklistRequest:_OnDeserialize() 
end

return OpenPlayerRanklistRequest;
