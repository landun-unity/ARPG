--
-- 逻辑服务器 --> 客户端
-- 同步一个格子信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RemovePlayerOneTiled = class("RemovePlayerOneTiled", GameMessage);

--
-- 构造函数
--
function RemovePlayerOneTiled:ctor()
    RemovePlayerOneTiled.super.ctor(self);
    --
    -- 土地Id
    --
    self.tiledId = 0;
end

--@Override
function RemovePlayerOneTiled:_OnSerial() 
    self:WriteInt32(self.tiledId);
end

--@Override
function RemovePlayerOneTiled:_OnDeserialize() 
    self.tiledId = self:ReadInt32();
end

return RemovePlayerOneTiled;
