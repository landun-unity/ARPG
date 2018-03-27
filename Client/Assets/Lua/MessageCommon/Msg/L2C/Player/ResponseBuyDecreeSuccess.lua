--
-- 逻辑服务器 --> 客户端
-- 刷新资源信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ResponseBuyDecreeSuccess = class("ResponseBuyDecreeSuccess", GameMessage);

--
-- 构造函数
--
function ResponseBuyDecreeSuccess:ctor()
    ResponseBuyDecreeSuccess.super.ctor(self);
end

--@Override
function ResponseBuyDecreeSuccess:_OnSerial() 
end

--@Override
function ResponseBuyDecreeSuccess:_OnDeserialize() 
end

return ResponseBuyDecreeSuccess;
