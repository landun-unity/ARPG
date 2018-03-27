--
-- 客户端 --> 逻辑服务器
-- 打开创建同盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenLeagueChatTeam = class("OpenLeagueChatTeam", GameMessage);

--
-- 构造函数
--
function OpenLeagueChatTeam:ctor()
    OpenLeagueChatTeam.super.ctor(self);
    --
    -- 打开的tearmid
    --
    self.teamPlayerId = 0;
end

--@Override
function OpenLeagueChatTeam:_OnSerial() 
    self:WriteInt64(self.teamPlayerId);
end

--@Override
function OpenLeagueChatTeam:_OnDeserialize() 
    self.teamPlayerId = self:ReadInt64();
end

return OpenLeagueChatTeam;
