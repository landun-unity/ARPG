
local GameService = require("FrameWork/Game/GameService")

local ChatHandler = require("Game/Chat/ChatHandler")
local ChatManage = require("Game/Chat/ChatManage");
ChatService = class("ChatService", GameService)

-- 构造函数
function ChatService:ctor()
    ChatService._instance = self;
    ChatService.super.ctor(self, ChatManage.new(), ChatHandler.new());
end

-- 单例
function ChatService:Instance()
    return ChatService._instance;
end

--清空数据
function ChatService:Clear()
    self._logic:ctor()
end

--获取对应聊天List
function ChatService:GetChatTableByChatType(ChatType, groupingChat)
	return self._logic:GetChatTableByChatType(ChatType, groupingChat);
end

function ChatService:RemoveChatTableByChatType(ChatType, groupingChat)
	self._logic:RemoveChatTableByChatType(ChatType, groupingChat);
end

--获取对应聊天List
function ChatService:SetUnread(chatType, groupingChat)
	self._logic:SetUnread(chatType, groupingChat);
end

function ChatService:ChangeUnread(index, value)
	self._logic:ChangeUnread(index, value);
end

--获取对应聊天List
function ChatService:GetUnread(chatType, groupingChat)
	return self._logic:GetUnread(chatType, groupingChat);
end

function ChatService:ClearChatByType(chatType)
	self._logic:ClearChatByType(chatType);
end

function ChatService:HandlerString(chatType, ...)
	return self._logic:HandlerString(chatType, ...);
end

function ChatService:GetBuilding(id)
	return self._logic:GetBuilding(id);
end

function ChatService:GetRegion(id)
	return self._logic:GetRegion(id);
end

function ChatService:GetConstruction(id)
	return self._logic:GetConstruction(id);
end

function ChatService:GetAlliesMemberAuthority(id)
	return self._logic:GetAlliesMemberAuthority(id);
end

function ChatService:GetCardType(id)
	return self._logic:GetCardType(id);
end

function ChatService:GetExperienceType(id)
	return self._logic:GetExperienceType(id);
end

return ChatService;