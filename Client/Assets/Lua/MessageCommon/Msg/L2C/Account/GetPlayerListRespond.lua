--
-- 逻辑服务器 --> 客户端
-- 验证成功
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GetPlayerListRespond = class("GetPlayerListRespond", GameMessage);

--
-- 构造函数
--
function GetPlayerListRespond:ctor()
    GetPlayerListRespond.super.ctor(self);
    --
    -- 玩家Id
    --
    self.roleId = 0;
end

--@Override
function GetPlayerListRespond:_OnSerial() 
    self:WriteInt64(self.roleId);
end

--@Override
function GetPlayerListRespond:_OnDeserialize() 
    self.roleId = self:ReadInt64();
end

return GetPlayerListRespond;
