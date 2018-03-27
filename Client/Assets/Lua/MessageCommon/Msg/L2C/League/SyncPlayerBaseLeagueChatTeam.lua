--
-- 逻辑服务器 --> 客户端
-- 同盟聊天分组基础信息
-- @author czx
--
local List = require("common/List");

local BaseLeagueChatTeamModel = require("MessageCommon/Msg/L2C/League/BaseLeagueChatTeamModel");

local GameMessage = require("common/Net/GameMessage");
local SyncPlayerBaseLeagueChatTeam = class("SyncPlayerBaseLeagueChatTeam", GameMessage);

--
-- 构造函数
--
function SyncPlayerBaseLeagueChatTeam:ctor()
    SyncPlayerBaseLeagueChatTeam.super.ctor(self);
    --
    -- 玩家拥有同盟聊天分组频道
    --
    self.list = List.new();
end

--@Override
function SyncPlayerBaseLeagueChatTeam:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.leaderId);
        self:WriteString(listValue.name);
        self:WriteString(listValue.leaderName);
    end
end

--@Override
function SyncPlayerBaseLeagueChatTeam:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = BaseLeagueChatTeamModel.new();
        listValue.leaderId = self:ReadInt64();
        listValue.name = self:ReadString();
        listValue.leaderName = self:ReadString();
        self.list:Push(listValue);
    end
end

return SyncPlayerBaseLeagueChatTeam;
