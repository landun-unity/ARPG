--
-- 逻辑服务器 --> 客户端
-- 同盟聊天分组基础信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local BaseLeagueChatTeamInfo = class("BaseLeagueChatTeamInfo", GameMessage);

--
-- 构造函数
--
function BaseLeagueChatTeamInfo:ctor()
    BaseLeagueChatTeamInfo.super.ctor(self);
    --
    -- 主管id
    --
    self.leaderId = 0;
    
    --
    -- 聊天分组名字
    --
    self.name = "";
    
    --
    -- leader名字
    --
    self.leaderName = "";
end

--@Override
function BaseLeagueChatTeamInfo:_OnSerial() 
    self:WriteInt64(self.leaderId);
    self:WriteString(self.name);
    self:WriteString(self.leaderName);
end

--@Override
function BaseLeagueChatTeamInfo:_OnDeserialize() 
    self.leaderId = self:ReadInt64();
    self.name = self:ReadString();
    self.leaderName = self:ReadString();
end

return BaseLeagueChatTeamInfo;
