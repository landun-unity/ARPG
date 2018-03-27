--
-- 客户端 --> 逻辑服务器
-- 主城标记信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncMainCitySign = class("SyncMainCitySign", GameMessage);

--
-- 构造函数
--
function SyncMainCitySign:ctor()
    SyncMainCitySign.super.ctor(self);
end

--@Override
function SyncMainCitySign:_OnSerial() 
end

--@Override
function SyncMainCitySign:_OnDeserialize() 
end

return SyncMainCitySign;
