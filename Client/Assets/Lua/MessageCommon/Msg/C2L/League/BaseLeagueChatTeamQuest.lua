--
-- 客户端 --> 逻辑服务器
-- 登录请求同盟聊天分组请求
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local BaseLeagueChatTeamQuest = class("BaseLeagueChatTeamQuest", GameMessage);

--
-- 构造函数
--
function BaseLeagueChatTeamQuest:ctor()
    BaseLeagueChatTeamQuest.super.ctor(self);
end

--@Override
function BaseLeagueChatTeamQuest:_OnSerial() 
end

--@Override
function BaseLeagueChatTeamQuest:_OnDeserialize() 
end

return BaseLeagueChatTeamQuest;
