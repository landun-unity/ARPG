--
-- 客户端 --> 逻辑服务器
-- 改变公告
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RefreshLeagueNotice = class("RefreshLeagueNotice", GameMessage);

--
-- 构造函数
--
function RefreshLeagueNotice:ctor()
    RefreshLeagueNotice.super.ctor(self);
    --
    -- 公告内容
    --
    self.notice = "";
end

--@Override
function RefreshLeagueNotice:_OnSerial() 
    self:WriteString(self.notice);
end

--@Override
function RefreshLeagueNotice:_OnDeserialize() 
    self.notice = self:ReadString();
end

return RefreshLeagueNotice;
