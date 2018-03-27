--
-- 聊天服务器 --> 客户端
-- 一条聊天信息
-- @author czx
--
local ChatContent = require("MessageCommon/Msg/Chat2C/Chat/ChatContent");

local GameMessage = require("common/Net/GameMessage");
local BroadcastChat = class("BroadcastChat", GameMessage);

--
-- 构造函数
--
function BroadcastChat:ctor()
    BroadcastChat.super.ctor(self);
    --
    -- 聊天内容
    --
    self.chat = ChatContent.new();
end

--@Override
function BroadcastChat:_OnSerial() 
    self:WriteInt64(self.chat.channelId);
    self:WriteInt32(self.chat.zoneId);
    self:WriteInt64(self.chat.country);
    self:WriteInt32(self.chat.state);
    self:WriteInt64(self.chat.playerId);
    self:WriteString(self.chat.playerName);
    self:WriteString(self.chat.leagueName);
    self:WriteInt32(self.chat.leadership);
    self:WriteString(self.chat.content);
    self:WriteInt64(self.chat.sendTime);
    self:WriteInt32(self.chat.mType);
    self:WriteString(self.chat.buildingName);
    self:WriteInt64(self.chat.buildingIndex);
    self:WriteInt64(self.chat.buildingId);
    self:WriteString(self.chat.otherLeagueName);
    self:WriteInt32(self.chat.otherLeagueState);
    self:WriteString(self.chat.otherOPlayerName);
    self:WriteString(self.chat.otherTPlayerName);
    self:WriteInt64(self.chat.dCardTableID);
    self:WriteInt64(self.chat.aCardTableID);
    self:WriteInt64(self.chat.tileIndex);
    self:WriteInt32(self.chat.placeType);
    self:WriteInt64(self.chat.iD);
    self:WriteInt32(self.chat.group);
    self:WriteInt64(self.chat.battleId);
    self:WriteInt32(self.chat.index);
end

--@Override
function BroadcastChat:_OnDeserialize() 
    self.chat.channelId = self:ReadInt64();
    self.chat.zoneId = self:ReadInt32();
    self.chat.country = self:ReadInt64();
    self.chat.state = self:ReadInt32();
    self.chat.playerId = self:ReadInt64();
    self.chat.playerName = self:ReadString();
    self.chat.leagueName = self:ReadString();
    self.chat.leadership = self:ReadInt32();
    self.chat.content = self:ReadString();
    self.chat.sendTime = self:ReadInt64();
    self.chat.mType = self:ReadInt32();
    self.chat.buildingName = self:ReadString();
    self.chat.buildingIndex = self:ReadInt64();
    self.chat.buildingId = self:ReadInt64();
    self.chat.otherLeagueName = self:ReadString();
    self.chat.otherLeagueState = self:ReadInt32();
    self.chat.otherOPlayerName = self:ReadString();
    self.chat.otherTPlayerName = self:ReadString();
    self.chat.dCardTableID = self:ReadInt64();
    self.chat.aCardTableID = self:ReadInt64();
    self.chat.tileIndex = self:ReadInt64();
    self.chat.placeType = self:ReadInt32();
    self.chat.iD = self:ReadInt64();
    self.chat.group = self:ReadInt32();
    self.chat.battleId = self:ReadInt64();
    self.chat.index = self:ReadInt32();
end

return BroadcastChat;
