--[[
	聊天管理
--]]
local GamePart = require("FrameWork/Game/GamePart")
local Queue = require("common/Queue");
local Chat = require("Game/Chat/Chat");
require("Game/Chat/ChatType");
require("Game/Table/model/DataBuilding")
require("Game/Table/model/DataRegion")
require("Game/Table/model/DataConstruction")
require("Game/Table/model/DataAlliesMemberAuthority")
require("Game/Table/model/DataCardSet")
require("Game/Table/model/DataExperienceBook")
local DataChat = require("Game/Table/model/DataChat");
local ChatManage = class("ChatManage", GamePart)

function ChatManage:ctor()
    ChatManage.super.ctor(self);
    --保存上限
    self._chatCount = 30;
    --聊天频道数据
    self._allChatTable = {};
    --未读状态
    self.unreadTable = {};
end

function ChatManage:_OnInit()
    for i = 1, ChatType.CompetitionChat do
        self.unreadTable[i] = 0;
    end
end

function ChatManage:HandleSyncChatSever()
end

function ChatManage:SetChatTable(index, value)
    if index == nil or value == nil then
        return;
    end

    local ChatQueue = self:FindChatValueByChannelId(index);

    if ChatQueue == nil then
        ChatQueue = Queue.new();
        self._allChatTable[index] = ChatQueue;
        ChatQueue:Push(value);
    else
        if self:GetChatCount(ChatQueue) == self._chatCount then
            self._allChatTable[index]:Pop();
            self._allChatTable[index]:Push(value);
        else
           self._allChatTable[index]:Push(value);
        end
    end
    self:ChangeUnread(index, value);
end

function ChatManage:ChangeUnread(index, value)
    if value == 0 or value.playerId ~= PlayerService:Instance():GetPlayerId() then
        if self.unreadTable[index] == nil then
            self.unreadTable[index] = 0;
        end

        self.unreadTable[index] = self.unreadTable[index] + 1;

        local baseClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
        local isopen = UIService:Instance():GetOpenedUI(UIType.UIGameMainView);
        if baseClass ~= nil and isopen == true then
            baseClass:ChatRedImage();
        end
    end
end

function ChatManage:SetUnread(chatType, groupingChat)
    if chatType == nil then
        return;
    end

    local channelId = self:_GetAllChannelId(chatType, groupingChat);

    self.unreadTable[channelId] = 0;
end

function ChatManage:GetUnread(chatType, groupingChat)
    if chatType == nil then
        return;
    end

    local channelId = self:_GetAllChannelId(chatType, groupingChat);

    if self.unreadTable[channelId] == nil then
        return 0;
    end

    return self.unreadTable[channelId];
end

function ChatManage:_GetAllChannelId(chatType, groupingChat)
    local channelId = 0;
    if groupingChat == ChatType.GroupingChat then
        channelId = chatType;
    else
        channelId = chatType * 10000 + self:_GetChannelId(chatType);
    end

    return channelId;
end

function ChatManage:_GetChannelId(chatType)
    --print(chatType)
    if chatType == ChatType.WorldChat then
      return 0;
    elseif chatType == ChatType.StateChat then
      return PlayerService:Instance():GetSpawnState();
    elseif chatType == ChatType.AllianceChat then
      return PlayerService:Instance():GetLeagueId();
    elseif chatType == ChatType.SystemChat then
      return PlayerService:Instance():GetPlayerId();
    -- elseif chatType == ChatType.GroupingChat then
    --   return PlayerService:Instance():GetLeagueId() + PlayerService:Instance():GetPlayerId();
    elseif chatType == ChatType.CompetitionChat then
      return 50000000;
    end
end

function ChatManage:GetChatTableByChatType(chatType, groupingChat)
    if chatType == nil or chatType == 0 then
        return;
    end

    local channelId = self:_GetAllChannelId(chatType, groupingChat);

    return self._allChatTable[channelId];
end

function ChatManage:RemoveChatTableByChatType(chatType, groupingChat)
    if chatType == nil or chatType == 0 then
        return;
    end

    local channelId = self:_GetAllChannelId(chatType, groupingChat);

    self._allChatTable[channelId] = nil;
end

function ChatManage:ClearChatByType(chatType)
    if chatType == nil then
        return;
    end

    local ChatQueue = self:GetChatTableByChatType(chatType);
    if ChatQueue == nil then
        return;
    end

    ChatQueue:Clear();
end

function ChatManage:HandleSyncBroadcastChat(syncChat)
    if syncChat == nil then
        return;
    end
    --print(syncChat.channelId)
    self:SetChatTable(syncChat.channelId, syncChat);
end

function ChatManage:HandleSyncChat(synChatListValue)
    --print(synChatListValue)
    if synChatListValue == nil then
        return;
    end
    --print(synChatListValue.channelId)
    self:SetChatTable(synChatListValue.channelId, synChatListValue);
end

function ChatManage:HandleSyncLeaveChannel(channelId)
    if channelId == nil then
        return;
    end

    self._allChatTable[channelId] = nil;
end

function ChatManage:FindChatValueByChannelId(ChannelId)
    if ChannelId == nil then
        return;
    end
    
    for k,v in pairs(self._allChatTable) do
        if ChannelId == k then
            return self._allChatTable[k];
        end
    end
    
    return;
end

function ChatManage:GetChatCount(ChatQueue)
    if ChatQueue == nil then
        return;
    end
    
    return ChatQueue:Count();
end

--事件类型格式化
function ChatManage:HandlerString(eventType, ...)
    if eventType == nil then
        return;
    end

    local chatString = string.format(DataChat[eventType].Describe, ...);
    
    return chatString;
end

--building
function ChatManage:GetBuilding(id)
    if id == nil then
        return;
    end

    return DataBuilding[id];
end

--DataRegion
function ChatManage:GetRegion(id)
    if id == nil then
        return;
    end

    return DataState[id];
end

--DataConstruction
function ChatManage:GetConstruction(id)
    if id == nil then
        return;
    end
    return DataConstruction[id];
end

--DataAlliesMemberAuthority
function ChatManage:GetAlliesMemberAuthority(id)
    if id == nil then
        return;
    end
    return DataAlliesMemberAuthority[id];
end

--资源地
function ChatManage:GetCardType(id)
    if id == nil then
        return;
    end
    return DataCardSet[id];
end

function ChatManage:GetExperienceType(id)
    if id == nil then
        return;
    end
    return DataExperienceBook[id];
end

return ChatManage;