--
-- 客户端 --> 逻辑服务器
-- 请求是否有该角色名称
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestIsHavePlayerName = class("RequestIsHavePlayerName", GameMessage);

--
-- 构造函数
--
function RequestIsHavePlayerName:ctor()
    RequestIsHavePlayerName.super.ctor(self);
    --
    -- 玩家角色名称
    --
    self.playerName = "";
end

--@Override
function RequestIsHavePlayerName:_OnSerial() 
    self:WriteString(self.playerName);
end

--@Override
function RequestIsHavePlayerName:_OnDeserialize() 
    self.playerName = self:ReadString();
end

return RequestIsHavePlayerName;
