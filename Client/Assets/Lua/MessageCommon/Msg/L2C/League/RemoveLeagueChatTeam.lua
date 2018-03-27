--
-- 逻辑服务器 --> 客户端
-- 移除同盟聊天分组回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RemoveLeagueChatTeam = class("RemoveLeagueChatTeam", GameMessage);

--
-- 构造函数
--
function RemoveLeagueChatTeam:ctor()
    RemoveLeagueChatTeam.super.ctor(self);
    --
    -- 组长id
    --
    self.leaderId = 0;
end

--@Override
function RemoveLeagueChatTeam:_OnSerial() 
    self:WriteInt64(self.leaderId);
end

--@Override
function RemoveLeagueChatTeam:_OnDeserialize() 
    self.leaderId = self:ReadInt64();
end

return RemoveLeagueChatTeam;
