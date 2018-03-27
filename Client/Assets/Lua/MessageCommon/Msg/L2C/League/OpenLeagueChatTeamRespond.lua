--
-- 逻辑服务器 --> 客户端
-- 聊天分组名字
-- @author czx
--
local List = require("common/List");

local ChatMemberModel = require("MessageCommon/Msg/L2C/League/ChatMemberModel");

local GameMessage = require("common/Net/GameMessage");
local OpenLeagueChatTeamRespond = class("OpenLeagueChatTeamRespond", GameMessage);

--
-- 构造函数
--
function OpenLeagueChatTeamRespond:ctor()
    OpenLeagueChatTeamRespond.super.ctor(self);
    --
    -- 名字
    --
    self.name = "";
    
    --
    -- 小组成员列表
    --
    self.teamList = List.new();
    
    --
    -- 能邀请的成员列表
    --
    self.canInventList = List.new();
end

--@Override
function OpenLeagueChatTeamRespond:_OnSerial() 
    self:WriteString(self.name);
    
    local teamListCount = self.teamList:Count();
    self:WriteInt32(teamListCount);
    for teamListIndex = 1, teamListCount, 1 do 
        local teamListValue = self.teamList:Get(teamListIndex);
        
        self:WriteInt64(teamListValue.playerId);
        self:WriteString(teamListValue.name);
    end
    
    local canInventListCount = self.canInventList:Count();
    self:WriteInt32(canInventListCount);
    for canInventListIndex = 1, canInventListCount, 1 do 
        local canInventListValue = self.canInventList:Get(canInventListIndex);
        
        self:WriteInt64(canInventListValue.playerId);
        self:WriteString(canInventListValue.name);
    end
end

--@Override
function OpenLeagueChatTeamRespond:_OnDeserialize() 
    self.name = self:ReadString();
    
    local teamListCount = self:ReadInt32();
    for i = 1, teamListCount, 1 do 
        local teamListValue = ChatMemberModel.new();
        teamListValue.playerId = self:ReadInt64();
        teamListValue.name = self:ReadString();
        self.teamList:Push(teamListValue);
    end
    
    local canInventListCount = self:ReadInt32();
    for i = 1, canInventListCount, 1 do 
        local canInventListValue = ChatMemberModel.new();
        canInventListValue.playerId = self:ReadInt64();
        canInventListValue.name = self:ReadString();
        self.canInventList:Push(canInventListValue);
    end
end

return OpenLeagueChatTeamRespond;
