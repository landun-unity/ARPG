-- region *.lua
-- Date16/10/22


local UIBase = require("Game/UI/UIBase")
require("Game/Chat/ChatType");
local OperationItem = class("OperationItem", UIBase);

function OperationItem:ctor()
    OperationItem.super.ctor(self);
    self.chatTeam = nil;
    self.btn = nil;
    self.text = nil;

    self.battle = nil;
end

-- 注册控件
function OperationItem:DoDataExchange()
    self.btn = self:RegisterController(UnityEngine.UI.Button, "");
    self.text = self:RegisterController(UnityEngine.UI.Text, "Text");
end

-- 监测控件
function OperationItem:DoEventAdd()
    self:AddListener(self.btn, self.OnClickBtn)
end

function OperationItem:OnShow(chatTeam, battle)
    self.battle = battle;
    self.chatTeam = chatTeam;
    self.text.text = "【"..chatTeam.name.."】频道";
end

function OperationItem:OnClickBtn()
    local msg = require("MessageCommon/Msg/C2Chat/Chat/SendChat").new();
    msg:SetMessageId(C2Chat_Chat.SendChat);
    msg.channelId = ChatType.GroupingChat * 10000 + self.chatTeam.leaderId;
    msg.playerId = PlayerService:Instance():GetPlayerId();
    msg.mType = ChatContentType.BattleReportType;
    
    msg.dCardTableID = self.battle._dCardTableID;
    msg.aCardTableID = self.battle._aCardTableID;
    msg.tileIndex = self.battle._tileIndex;
    local beforeRound = self:HandlerBeforeRound();
    msg.buildingId = beforeRound.buildingID;
    msg.buildingName = beforeRound.name;
    msg.placeType = beforeRound.type;
    msg.iD = self.battle._id;
    msg.group = self.battle._group;
    msg.battleId = self.battle._iD;
    msg.index = self.battle._index;
    NetService:Instance():SendMessage(msg);
end

function OperationItem:HandlerBeforeRound()
    local beforeRoundList = BattleReportService:Instance():GetBattleReportInfoById(self.battle._iD, self.battle._index).BeforeRound;
    for i = 1, beforeRoundList:Count() do
        if beforeRoundList:Get(i).buildingID ~= nil then
            return beforeRoundList:Get(i);
        end
    end
end

return OperationItem