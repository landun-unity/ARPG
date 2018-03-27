--
-- 客户端 --> 逻辑服务器
-- 打开创建同盟聊天分组频道
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenCreateLeagueChatTeam = class("OpenCreateLeagueChatTeam", GameMessage);

--
-- 构造函数
--
function OpenCreateLeagueChatTeam:ctor()
    OpenCreateLeagueChatTeam.super.ctor(self);
end

--@Override
function OpenCreateLeagueChatTeam:_OnSerial() 
end

--@Override
function OpenCreateLeagueChatTeam:_OnDeserialize() 
end

return OpenCreateLeagueChatTeam;
