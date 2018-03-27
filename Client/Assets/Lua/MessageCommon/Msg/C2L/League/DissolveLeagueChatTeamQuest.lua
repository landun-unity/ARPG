--
-- 客户端 --> 逻辑服务器
-- 解散同盟聊天分组
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local DissolveLeagueChatTeamQuest = class("DissolveLeagueChatTeamQuest", GameMessage);

--
-- 构造函数
--
function DissolveLeagueChatTeamQuest:ctor()
    DissolveLeagueChatTeamQuest.super.ctor(self);
end

--@Override
function DissolveLeagueChatTeamQuest:_OnSerial() 
end

--@Override
function DissolveLeagueChatTeamQuest:_OnDeserialize() 
end

return DissolveLeagueChatTeamQuest;
