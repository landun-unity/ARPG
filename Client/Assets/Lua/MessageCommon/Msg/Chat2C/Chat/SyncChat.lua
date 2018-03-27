--
-- 聊天服务器 --> 客户端
-- 同步聊天信息
-- @author czx
--
local List = require("common/List");

local ChatContent = require("MessageCommon/Msg/Chat2C/Chat/ChatContent");

local GameMessage = require("common/Net/GameMessage");
local SyncChat = class("SyncChat", GameMessage);

--
-- 构造函数
--
function SyncChat:ctor()
    SyncChat.super.ctor(self);
    --
    -- 所有缓存的聊天内容
    --
    self.allChatList = List.new();
end

--@Override
function SyncChat:_OnSerial() 
    
    local allChatListCount = self.allChatList:Count();
    self:WriteInt32(allChatListCount);
    for allChatListIndex = 1, allChatListCount, 1 do 
        local allChatListValue = self.allChatList:Get(allChatListIndex);
        
        self:WriteInt64(allChatListValue.channelId);
        self:WriteInt32(allChatListValue.zoneId);
        self:WriteInt64(allChatListValue.country);
        self:WriteInt32(allChatListValue.state);
        self:WriteInt64(allChatListValue.playerId);
        self:WriteString(allChatListValue.playerName);
        self:WriteString(allChatListValue.leagueName);
        self:WriteInt32(allChatListValue.leadership);
        self:WriteString(allChatListValue.content);
        self:WriteInt64(allChatListValue.sendTime);
        self:WriteInt32(allChatListValue.mType);
        self:WriteString(allChatListValue.buildingName);
        self:WriteInt64(allChatListValue.buildingIndex);
        self:WriteInt64(allChatListValue.buildingId);
        self:WriteString(allChatListValue.otherLeagueName);
        self:WriteInt32(allChatListValue.otherLeagueState);
        self:WriteString(allChatListValue.otherOPlayerName);
        self:WriteString(allChatListValue.otherTPlayerName);
        self:WriteInt64(allChatListValue.dCardTableID);
        self:WriteInt64(allChatListValue.aCardTableID);
        self:WriteInt64(allChatListValue.tileIndex);
        self:WriteInt32(allChatListValue.placeType);
        self:WriteInt64(allChatListValue.iD);
        self:WriteInt32(allChatListValue.group);
        self:WriteInt64(allChatListValue.battleId);
        self:WriteInt32(allChatListValue.index);
    end
end

--@Override
function SyncChat:_OnDeserialize() 
    
    local allChatListCount = self:ReadInt32();
    for i = 1, allChatListCount, 1 do 
        local allChatListValue = ChatContent.new();
        allChatListValue.channelId = self:ReadInt64();
        allChatListValue.zoneId = self:ReadInt32();
        allChatListValue.country = self:ReadInt64();
        allChatListValue.state = self:ReadInt32();
        allChatListValue.playerId = self:ReadInt64();
        allChatListValue.playerName = self:ReadString();
        allChatListValue.leagueName = self:ReadString();
        allChatListValue.leadership = self:ReadInt32();
        allChatListValue.content = self:ReadString();
        allChatListValue.sendTime = self:ReadInt64();
        allChatListValue.mType = self:ReadInt32();
        allChatListValue.buildingName = self:ReadString();
        allChatListValue.buildingIndex = self:ReadInt64();
        allChatListValue.buildingId = self:ReadInt64();
        allChatListValue.otherLeagueName = self:ReadString();
        allChatListValue.otherLeagueState = self:ReadInt32();
        allChatListValue.otherOPlayerName = self:ReadString();
        allChatListValue.otherTPlayerName = self:ReadString();
        allChatListValue.dCardTableID = self:ReadInt64();
        allChatListValue.aCardTableID = self:ReadInt64();
        allChatListValue.tileIndex = self:ReadInt64();
        allChatListValue.placeType = self:ReadInt32();
        allChatListValue.iD = self:ReadInt64();
        allChatListValue.group = self:ReadInt32();
        allChatListValue.battleId = self:ReadInt64();
        allChatListValue.index = self:ReadInt32();
        self.allChatList:Push(allChatListValue);
    end
end

return SyncChat;
