-- 建筑物消息处理
local IOHandler = require("FrameWork/Game/IOHandler")
local ChatContent = require("MessageCommon/Msg/Chat2C/Chat/ChatContent");
require("Game/Chat/ChatContentType")
local ChatHandler = class("ChatHandler", IOHandler)

-- 构造函数
function ChatHandler:ctor()
    -- body
    ChatHandler.super.ctor(self);
end

-- 注册所有消息
function ChatHandler:RegisterAllMessage()
    --获取端口	IP ID
    --self:RegisterMessage(L2C_Chat.ChatSever, self.HandleSyncChatSever, require("MessageCommon/Msg/C2Chat/Chat/JoinChannel"));

    self:RegisterMessage(Chat2C_Chat.BroadcastChat, self.HandleSyncBroadcastChat, require("MessageCommon/Msg/Chat2C/Chat/BroadcastChat"));
    self:RegisterMessage(Chat2C_Chat.RegisterChatSuccess, self.HandleSyncRegisterChatSuccess, require("MessageCommon/Msg/Chat2C/Chat/RegisterChatSuccess"));
    self:RegisterMessage(Chat2C_Chat.SyncChat, self.HandleSyncChat, require("MessageCommon/Msg/Chat2C/Chat/SyncChat"));
    self:RegisterMessage(Chat2C_Chat.SyncLeaveChannel, self.HandleSyncLeaveChannel, require("MessageCommon/Msg/Chat2C/Chat/SyncLeaveChannel"));
end

--接受聊天服信息
function ChatHandler:HandleSyncChatSever(msg)
	--self._logicManage:HandleSyncChatSever(syncChat);
end

--处理加入频道
function ChatHandler:HandleSyncBroadcastChat(msg)
	--print("HandleSyncBroadcastChat")
	local syncChat = ChatContent.new();
	syncChat.channelId = msg.chat.channelId;
	syncChat.zoneId = msg.chat.zoneId;
	syncChat.country = msg.chat.country;
	syncChat.state = msg.chat.state;
	--print(msg.chat.playerId)
	syncChat.playerId = msg.chat.playerId;
	syncChat.playerName = msg.chat.playerName;
	syncChat.leagueName = msg.chat.leagueName;
	syncChat.leadership = msg.chat.leadership;
	--print("HandleSyncBroadcastChat"..msg.chat.content)
	syncChat.content = msg.chat.content;
	syncChat.sendTime = msg.chat.sendTime;
	syncChat.mType = msg.chat.mType;
	syncChat.buildingName = msg.chat.buildingName;
	syncChat.buildingIndex = msg.chat.buildingIndex;
	syncChat.buildingId = msg.chat.buildingId;
	syncChat.otherLeagueName = msg.chat.otherLeagueName;
    syncChat.otherLeagueState = msg.chat.otherLeagueState;
    syncChat.otherOPlayerName = msg.chat.otherOPlayerName;
    syncChat.otherTPlayerName = msg.chat.otherTPlayerName;

    syncChat.dCardTableID = msg.chat.dCardTableID;
    syncChat.aCardTableID = msg.chat.aCardTableID;
    syncChat.tileIndex = msg.chat.tileIndex;
    syncChat.placeType = msg.chat.placeType;
    syncChat.iD = msg.chat.iD;
    syncChat.group = msg.chat.group;
    syncChat.battleId = msg.chat.battleId;
    syncChat.index = msg.chat.index;
	self._logicManage:HandleSyncBroadcastChat(syncChat);
    
    local baseClass1 = UIService:Instance():GetUIClass(UIType.UIChat);
    local isopen1 = UIService:Instance():GetOpenedUI(UIType.UIChat);
    if baseClass1 ~= nil and isopen1 == true then
    	baseClass1:Refresh();
    	baseClass1:HandlerTime();
    end

    if syncChat.mType == ChatContentType.BattleReportType then
    	local baseClass1 = UIService:Instance():GetUIClass(UIType.OperationUI);
        local isopen1 = UIService:Instance():GetOpenedUI(UIType.OperationUI);
        if baseClass1 ~= nil and isopen1 == true then
            UIService:Instance():HideUI(UIType.OperationUI);
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 512);
        end
    end
end

--注册聊天服务器
function ChatHandler:HandleSyncRegisterChatSuccess(msg)
	--print("HandleSyncRegisterChatSuccess")
end

--在一个频道中发送聊天
function ChatHandler:HandleSyncChat(msg)
	--print("HandleSyncChat")
	local count = msg.allChatList:Count();
	if count == 0 then
		return;
	end
	for i = 1, count do
		local synChatListValue = msg.allChatList:Get(i);
		local syncChat = ChatContent.new();
		syncChat.channelId = synChatListValue.channelId;
		syncChat.zoneId = synChatListValue.zoneId;
		syncChat.country = synChatListValue.country;
		syncChat.state = synChatListValue.state;
		--print(synChatListValue.playerId)
		syncChat.playerId = synChatListValue.playerId;
		syncChat.playerName = synChatListValue.playerName;
		syncChat.leagueName = synChatListValue.leagueName;
		syncChat.leadership = synChatListValue.leadership;
		--print(synChatListValue.content)
		syncChat.content = synChatListValue.content;
		syncChat.sendTime = synChatListValue.sendTime;
		syncChat.mType = synChatListValue.mType;
		syncChat.buildingName = synChatListValue.buildingName;
		syncChat.buildingIndex = synChatListValue.buildingIndex;
		syncChat.buildingId = synChatListValue.buildingId;
		syncChat.otherLeagueName = synChatListValue.otherLeagueName;
	    syncChat.otherLeagueState = synChatListValue.otherLeagueState;
	    syncChat.otherOPlayerName = synChatListValue.otherOPlayerName;
	    syncChat.otherTPlayerName = synChatListValue.otherTPlayerName;

	    syncChat.dCardTableID = synChatListValue.dCardTableID;
	    syncChat.aCardTableID = synChatListValue.aCardTableID;
	    syncChat.tileIndex = synChatListValue.tileIndex;
	    syncChat.placeType = synChatListValue.placeType;
	    syncChat.iD = synChatListValue.iD;
	    syncChat.group = synChatListValue.group;
	    syncChat.battleId = synChatListValue.battleId;
	    syncChat.index = synChatListValue.index;
        self._logicManage:HandleSyncChat(syncChat);
	end
end

function ChatHandler:HandleSyncLeaveChannel(msg)
	--print("HandleSyncLeaveChannel")
	self._logicManage:HandleSyncLeaveChannel(msg.channelId);
end

return ChatHandler;
