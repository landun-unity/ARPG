--
-- 逻辑服务器 --> 客户端
-- 修改频道名字回复
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
    -- 新聊天频道回复
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
