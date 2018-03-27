--
-- 客户端 --> 逻辑服务器
-- 增加同盟经验
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ChangeLeagueExpience = class("ChangeLeagueExpience", GameMessage);

--
-- 构造函数
--
function ChangeLeagueExpience:ctor()
    ChangeLeagueExpience.super.ctor(self);
    --
    -- 增加/减少经验
    --
    self.exp = 0;
end

--@Override
function ChangeLeagueExpience:_OnSerial() 
    self:WriteInt32(self.exp);
end

--@Override
function ChangeLeagueExpience:_OnDeserialize() 
    self.exp = self:ReadInt32();
end

return ChangeLeagueExpience;
