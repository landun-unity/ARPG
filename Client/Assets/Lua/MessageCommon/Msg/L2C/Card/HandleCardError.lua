--
-- 逻辑服务器 --> 客户端
-- 处理卡牌错误
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local HandleCardError = class("HandleCardError", GameMessage);

--
-- 构造函数
--
function HandleCardError:ctor()
    HandleCardError.super.ctor(self);
end

--@Override
function HandleCardError:_OnSerial() 
end

--@Override
function HandleCardError:_OnDeserialize() 
end

return HandleCardError;
