--
-- 客户端 --> 逻辑服务器
-- 修改频道名字
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ChangeLeagueChatTeamName = class("ChangeLeagueChatTeamName", GameMessage);

--
-- 构造函数
--
function ChangeLeagueChatTeamName:ctor()
    ChangeLeagueChatTeamName.super.ctor(self);
    --
    -- 新频道名字
    --
    self.name = "";
end

--@Override
function ChangeLeagueChatTeamName:_OnSerial() 
    self:WriteString(self.name);
end

--@Override
function ChangeLeagueChatTeamName:_OnDeserialize() 
    self.name = self:ReadString();
end

return ChangeLeagueChatTeamName;
