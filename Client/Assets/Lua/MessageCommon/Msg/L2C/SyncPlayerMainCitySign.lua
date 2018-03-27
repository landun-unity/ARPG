--
-- 逻辑服务器 --> 客户端
-- 同步服务器时间返回
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncPlayerMainCitySign = class("SyncPlayerMainCitySign", GameMessage);

--
-- 构造函数
--
function SyncPlayerMainCitySign:ctor()
    SyncPlayerMainCitySign.super.ctor(self);
end

--@Override
function SyncPlayerMainCitySign:_OnSerial() 
end

--@Override
function SyncPlayerMainCitySign:_OnDeserialize() 
end

return SyncPlayerMainCitySign;
