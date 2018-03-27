--
-- 逻辑服务器 --> 客户端
-- 下次入盟时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local NextJoinLeagueTime = class("NextJoinLeagueTime", GameMessage);

--
-- 构造函数
--
function NextJoinLeagueTime:ctor()
    NextJoinLeagueTime.super.ctor(self);
    --
    -- 下次入盟时间
    --
    self.nextJoinTime = 0;
end

--@Override
function NextJoinLeagueTime:_OnSerial() 
    self:WriteInt64(self.nextJoinTime);
end

--@Override
function NextJoinLeagueTime:_OnDeserialize() 
    self.nextJoinTime = self:ReadInt64();
end

return NextJoinLeagueTime;
