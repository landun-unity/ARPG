--
-- 逻辑服务器 --> 客户端
-- 移除同盟标记回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RemoveLeagueMarkRespond = class("RemoveLeagueMarkRespond", GameMessage);

--
-- 构造函数
--
function RemoveLeagueMarkRespond:ctor()
    RemoveLeagueMarkRespond.super.ctor(self);
    --
    -- 标记id
    --
    self.id = 0;
    
    --
    -- 标记坐标
    --
    self.coord = 0;
end

--@Override
function RemoveLeagueMarkRespond:_OnSerial() 
    self:WriteInt64(self.id);
    self:WriteInt32(self.coord);
end

--@Override
function RemoveLeagueMarkRespond:_OnDeserialize() 
    self.id = self:ReadInt64();
    self.coord = self:ReadInt32();
end

return RemoveLeagueMarkRespond;
