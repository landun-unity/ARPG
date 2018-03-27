--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local List = require("common/List");
local Queue = require("common/Queue");
require("Game/BattleReport/UIBattleReport/ReportGroup");
local OperationUI = class("OperationUI",UIBase)
local MailWriteUI =  require("Game/Mail/MailWriteUI");

function OperationUI:ctor()
    
    OperationUI.super.ctor(self)

    self.personalInfoBtn = nil;
    self.sendMailBtn = nil;
    self.addBlackPropleBtn = nil;
    self.addLinkPeopleBtn = nil;
    self.backgroundBtn = nil;
    self.exitBtn = nil;
    self.coordinateBtn = nil;
    self.battlefieldBtn = nil;
    self.backgroundImage = nil;
    self.functionBtns = nil;
    self.sendBattlefieldBtn = nil;

    self.showPlayerId = 0;
    self.showPlayerName = "";

    self._chatCoordinateIndex = 0;

    --战报相关
    self.cacheItemBtn = Queue.new();
    self.itemBtn = List.new();
    self.battle = nil;
    self.battleChat = nil;
end


function OperationUI:DoDataExchange()
    self.personalInfoBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/FunctionBtns/PersonalInfoBtn");
    self.sendMailBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/FunctionBtns/SendMailBtn");
    self.addBlackPropleBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/FunctionBtns/AddBlackPropleBtn");
    self.addLinkPeopleBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/FunctionBtns/AddLinkPeopleBtn");
    self.backgroundBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundBgBtn");
    self.exitBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/ExitButton");
    self.functionBtns = self:RegisterController(UnityEngine.Transform, "BackgroundImage/FunctionBtns");
    self.coordinateBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/FunctionBtns/CoordinateBtn");
    self.battlefieldBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/FunctionBtns/BattlefieldBtn");
    self.backgroundImage = self:RegisterController(UnityEngine.Transform, "BackgroundImage");
    self.sendBattlefieldBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/FunctionBtns/SendBattlefieldBtn");
end

function OperationUI:DoEventAdd()
    self:AddListener(self.coordinateBtn, self.OnCilckCoordinateBtn);
    self:AddListener(self.battlefieldBtn, self.OnCilckBattlefieldBtn);
    self:AddListener(self.personalInfoBtn, self.OnCilckPersonalInfoBtn);
    self:AddListener(self.sendMailBtn, self.OnCilckSendMailBtn);
    self:AddListener(self.addBlackPropleBtn, self.OnCilckAddBlackPropleBtn);
    self:AddListener(self.addLinkPeopleBtn, self.OnCilckAddLinkPeopleBtn);
    self:AddListener(self.backgroundBtn, self.OnCilckExitBtn);
    self:AddListener(self.exitBtn, self.OnCilckExitBtn);
    self:AddListener(self.sendBattlefieldBtn, self.SendBattlefieldBtn);
end

function OperationUI:RegisterAllNotice()
   -- 单走聊天
   --self:RegisterNotice(Chat2C_Chat.BroadcastChat, self.Refresh);
end

function OperationUI:_ReleaseItem(cache)
  if cache == nil then
    return;
  end
  self.cacheItemBtn:Push(cache);
  cache.gameObject:SetActive(false);
  self:HandlerSizeDelta(-1);
end

--回收
function OperationUI:_AllocItem()
   if self.cacheItemBtn:Count() == 0 then
        return nil;
   end
   return self.cacheItemBtn:Pop();
end

function OperationUI:OnShow(params)
    --self:ShowBtn();
    self.showPlayerId = params[1];
    self.showPlayerName = params[2];

    self:OpenCoordinateBtn(params);

    self:RefreshBtn();

    self:BattleReport(params);
    self:OpenBattleReport(params);
end

function OperationUI:RefreshBtn()
    if PlayerService:Instance():GetPlayerId() == self.showPlayerId then
        if self.personalInfoBtn.gameObject.activeSelf == true then
           self:HideBtn();
        end
    else
        if self.personalInfoBtn.gameObject.activeSelf == false then
           self:ShowBtn();
        end
    end
end

function OperationUI:OpenCoordinateBtn(params)
    --跳转坐标
    if params[3] == 0 or params[3] == nil then
        if self.coordinateBtn.gameObject.activeSelf == true then
           self:HandlerSizeDelta(-1);
           self.coordinateBtn.gameObject:SetActive(false);
        end
    else
        self._chatCoordinateIndex = params[3];
        if self.coordinateBtn.gameObject.activeSelf == false then
            self:HandlerSizeDelta(1);
           self.coordinateBtn.gameObject:SetActive(true);
        end
    end
end

function OperationUI:OpenBattleReport(params)
    if params[5] == nil then
        if self.battlefieldBtn.gameObject.activeSelf == true then
           self:HandlerSizeDelta(-1);
           self.battlefieldBtn.gameObject:SetActive(false);
        end
    else
        self.battleChat = params[5];
        if self.battlefieldBtn.gameObject.activeSelf == false then
            self:HandlerSizeDelta(1);
           self.battlefieldBtn.gameObject:SetActive(true);
        end
    end
end

function OperationUI:BattleReport(params)
    self:HideItem();
    if params[4] == nil then
        if self.sendBattlefieldBtn.gameObject.activeSelf == true then
            self.sendBattlefieldBtn.gameObject:SetActive(false);
            self:HandlerSizeDelta(-1);
        end
        return;
    end

    self.battle = params[4];

    if self.sendBattlefieldBtn.gameObject.activeSelf == false then
        self.sendBattlefieldBtn.gameObject:SetActive(true);
        self:HandlerSizeDelta(1);
    end

    self:ShowItem();
end

function OperationUI:HideItem()
    self.itemBtn:ForEach(function ( ... )
        self:HideBtnItem(...)
    end);
    self.itemBtn:Clear();
end

function OperationUI:ShowItem()
    local chatTeam = LeagueService:Instance():GetLeagueChatTeam();
    for k,v in pairs(chatTeam) do
        self:CreatItem(v);
    end
end

function OperationUI:CreatItem(chatTeam)
    local item = self:_AllocItem();
    if item == nil then
        item = require("Game/Chat/OperationItem").new();
        GameResFactory.Instance():GetUIPrefab("UIPrefab/".."OperationBattlefieldBtn", self.functionBtns, item, function (go)
        item:DoDataExchange();
        item:DoEventAdd();
        item:OnShow(chatTeam, self.battle);
        item.transform:SetAsLastSibling();
        self:SetItem(item);
        item.gameObject:SetActive(true);
        end);
    else
       item:OnShow(chatTeam, self.battle);
       item.transform:SetAsLastSibling();
       item.gameObject:SetActive(true);
       self:SetItem(item);
    end
    self:HandlerSizeDelta(1);
end

function OperationUI:HideBtnItem(item)
    self:_ReleaseItem(item);
end

function OperationUI:SetItem(value)
    if value == nil then
        return;
    end
    self.itemBtn:Push(value);
end

function OperationUI:SendBattlefieldBtn()
    local msg = require("MessageCommon/Msg/C2Chat/Chat/SendChat").new();
    msg:SetMessageId(C2Chat_Chat.SendChat);
    msg.channelId = ChatType.AllianceChat * 10000 + PlayerService:Instance():GetLeagueId();
    msg.playerId = self.showPlayerId;
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

function OperationUI:HandlerBeforeRound()
    local beforeRoundList = BattleReportService:Instance():GetBattleReportInfoById(self.battle._iD, self.battle._index).BeforeRound;
    for i = 1, beforeRoundList:Count() do
        if beforeRoundList:Get(i).buildingID ~= nil then
            return beforeRoundList:Get(i);
        end
    end
end

function OperationUI:OpenBattleReportDetail(mode)
    local infoDetail = BattleReportService:Instance():GetBattleReportInfoById(self.battleChat.battleId, self.battleChat.index);
    if(infoDetail ~= nil)then
        local pamp = {};
        pamp[1] = mode;
        pamp[2] = infoDetail;
        pamp[3] = self.battleChat.index;
        pamp[4] = self;
        UIService:Instance():ShowUI(UIType.UIBattleReportDetail,pamp)
    end
end

function OperationUI:HandlerSizeDelta(count)
    self.backgroundImage.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta
    = Vector2.New(self.backgroundImage.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta.x,
        self.backgroundImage.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta.y + 50 * count);
    self.functionBtns.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta
    = Vector2.New(self.functionBtns.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta.x,
        self.functionBtns.gameObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta.y + 50 * count);
end

function OperationUI:HideBtn()
    self:HandlerSizeDelta(-4);
    self.personalInfoBtn.gameObject:SetActive(false);
    self.sendMailBtn.gameObject:SetActive(false);
    self.addBlackPropleBtn.gameObject:SetActive(false);
    self.addLinkPeopleBtn.gameObject:SetActive(false);
end

function OperationUI:ShowBtn()
    self:HandlerSizeDelta(4);
    self.personalInfoBtn.gameObject:SetActive(true);
    self.sendMailBtn.gameObject:SetActive(true);
    self.addBlackPropleBtn.gameObject:SetActive(true);
    self.addLinkPeopleBtn.gameObject:SetActive(true);
end

function OperationUI:OnCilckCoordinateBtn()
    MapService:Instance():ScanTiled(self._chatCoordinateIndex, function ()end,0,true);
    UIService:Instance():HideUI(UIType.OperationUI);
    UIService:Instance():HideUI(UIType.UIChat);
    UIService:Instance():ShowUI(UIType.UIGameMainView);
    MapService:Instance():ChangeScreenCenter(self._chatCoordinateIndex);
end

function OperationUI:OnCilckBattlefieldBtn()
    BattleReportService:Instance():SetLastClickIndex(self.battleChat.index);
    local msg1 = require("MessageCommon/Msg/C2L/BattleReport/GetBattleReportDetail").new();
    msg1:SetMessageId(C2L_BattleReport.GetBattleReportDetail);
    msg1.battleReportGroup = self.battleChat.group;
    
    if(self.battleChat.group == ReportGroup.Alliance) then
        msg1.id = self.battleChat.country;
    else
        msg1.id = self.battleChat.playerId;
    end
    msg1.battleReportID = self.battleChat.battleId;
    msg1.index = self.battleChat.index;
    NetService:Instance():SendMessage(msg1);

    local msg = require("MessageCommon/Msg/C2L/BattleReport/GetBattleReportByID").new();
    msg:SetMessageId(C2L_BattleReport.GetBattleReportByID);
    msg.battleReportGroup = self.battleChat.group;
    msg.id = self.battleChat.iD;
    msg.battleReportid = self.battleChat.battleId;
    msg.index = self.battleChat.index;
    NetService:Instance():SendMessage(msg);
end

--μ??÷??è?D??￠
function OperationUI:OnCilckPersonalInfoBtn()
    CommonService:Instance():RequestPlayerInfo(self.showPlayerId);
    UIService:Instance():HideUI(UIType.OperationUI);
end

--μ??÷·￠?íóê?t
function OperationUI:OnCilckSendMailBtn()    
    UIService:Instance():HideUI(UIType.OperationUI);
    UIService:Instance():ShowUI(UIType.MailWriteUI,false);
    MailWriteUI:Instance():SetPersonalReceiveInfo(self.showPlayerName);
end

function OperationUI:OnCilckAddBlackPropleBtn()
 
end

function OperationUI:OnCilckAddLinkPeopleBtn()
 
end

function OperationUI:OnCilckExitBtn()
    self.showPlayerId = 0;
    self.showPlayerName = "";
    UIService:Instance():HideUI(UIType.OperationUI); 
end

return OperationUI