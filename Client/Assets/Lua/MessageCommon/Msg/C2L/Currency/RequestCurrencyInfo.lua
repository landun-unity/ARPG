--[[
    请求玩家货币信息
--]]

local GameMessage = require("common/Net/GameMessage");
local RequestCurrencyInfo = class("RequestCurrencyInfo", GameMessage);

function RequestCurrencyInfo:ctor()
    RequestCurrencyInfo.super.ctor(self);

end

function RequestCurrencyInfo:_OnSerial()
end

function RequestCurrencyInfo:_OnDeserialize()
end

return RequestCurrencyInfo;
