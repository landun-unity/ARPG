--
-- 客户端 --> 逻辑服务器
-- 打开指定盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local HandleRequestImmediateOpenAppointLeague = class("HandleRequestImmediateOpenAppointLeague", GameMessage);

--
-- 构造函数
--
function HandleRequestImmediateOpenAppointLeague:ctor()
    HandleRequestImmediateOpenAppointLeague.super.ctor(self);
    --
    -- 打开指定盟
    --
    self.name = "";
end

--@Override
function HandleRequestImmediateOpenAppointLeague:_OnSerial() 
    self:WriteString(self.name);
end

--@Override
function HandleRequestImmediateOpenAppointLeague:_OnDeserialize() 
    self.name = self:ReadString();
end

return HandleRequestImmediateOpenAppointLeague;
