-- 聊天
local UIBase = require("Game/UI/UIBase");
--local ChatService = require("Game/Chat/ChatService");
local List = require("common/List");
local Queue = require("common/Queue");
local UIChatContentItemBtnItem = require("Game/Chat/UIChatContentItemBtnItem");
local UIChannelItem = require("Game/Chat/UIChannelItem");
--local PlayerService = require("Game/Player/PlayerService");
--local LeagueService = require("Game/League/LeagueService")
require("Game/Chat/ChatType");
require("Game/Chat/ChatContentType")
require("Game/Player/CurrencyEnum");
require("Game/Chat/ChatsTotalType")
require("Game/League/LeagueTitleType")
--local DataBannedWord = require("Game/Table/model/DataBannedWord");
local UIChat = class("UIChat", UIBase)

function UIChat:ctor()
    UIChat.super.ctor(self);

    self._closeBtn =　nil;
    
    self._chatScrollView = nil;
    self._chatBtnContent = nil;
    self._worldChatBtn = nil;
    --self._worldChatImage = nil;
    self._stateChatBtn = nil;
    --self._stateChatImage = nil;
    self._leagueChatBtn = nil;
    --self._leagueChatImage = nil;
    self._systemChatBtn = nil;
    --self._systemChatImage = nil;

    self._competitionChatBtn = nil;
    self._addBtn = nil;
    --聊天框
    self._chatContent = nil;
    self._chatChannelBtnContent = nil;
    self._Text = nil;
    self._leagueBtn = nil;
    self._timetext = nil;
    --发送
    self._chatSent = nil;
    self._chatNotSent = nil;
    --输入框
    self._chatInputText = nil;
    --精灵
    self._spriteBtn = nil;
    --语音
    self._voiceChatBtn = nil;
    --table-list聊天
    --self._chatTable = {};
    --脚本
    self._Item = List.new();
    --脚本
    self._btnItem = List.new();
    --预设
    self._cacheBtnItem = Queue.new();
    --预设
    self._cacheItem = Queue.new();
    --预设
    self._cacheCaptureItem = Queue.new();
    --预设
    self._cacheItemBtn= Queue.new();
    --预设
    --self._cacheChatContentItem = List.new();

    self._time = {};

    self._currentType = 0;

    self._imageRedImage = {};
    self._imageBtnImage = {};
    --输入框
    self._allianceChatBtn = nil;
    --初始化个数
    self._initCount = 5;

    self._chatTream = {};
    self._groupingChat = 0;
    self._channelBtnItem = nil;

    self._currentHeight = 0;
    self._limitHeight = 491;
end

function UIChat:RegisterAllNotice()
   -- 聊天
   --self:RegisterNotice(Chat2C_Chat.BroadcastChat, self.Refresh);
   -- 创建同盟分组
   self:RegisterNotice(L2C_League.OpenLeagueChatTeamRespond, self.OpenAllianceChat);
   --离开频道
   --self:RegisterNotice(L2C_League.HandleRemoveLeagueChatTeam, self.OnShow);
end

function UIChat:OnInit()
    local mType = ChatContentType.FightAAType;
    local mchatType = ChatType.WorldChat;
    for i = 1 ,self._initCount do
        local item = UIChatContentItemBtnItem.new();
        GameResFactory.Instance():GetUIPrefab("UIPrefab/".."ChatDetailsCaptureButton", self._chatContent, item, function (go)
        item:DoDataExchange(mType);
        item:OnInit(mType, mchatType);
        item:DoEventAdd();
        item:Hide();
        self:_SetItem(item);
        end);
    end
    
    local myType = ChatContentType.StringType;
    local mychatType = ChatType.WorldChat;
    for i = 1 ,self._initCount do
        local mitem = UIChatContentItemBtnItem.new();
        GameResFactory.Instance():GetUIPrefab("UIPrefab/".."ChatDetailsButton", self._chatContent, mitem, function (go)
        mitem:DoDataExchange(mType);
        mitem:OnInit(myType, mychatType);
        mitem:DoEventAdd();
        mitem:Hide();
        self:_SetItem(mitem);
        end);
    end
end

function UIChat:_SetItem(value)
  if value == nil then
    return;
  end
  self._Item:Push(value);
  self._currentHeight = self._currentHeight + value.gameObject:GetComponent(typeof(UnityEngine.UI.LayoutElement)).minHeight;
end

function UIChat:_ReleaseItem(cache)
  if cache == nil then
    return;
  end
  self._cacheItem:Push(cache);
  cache:ClearContentSizeFitter();
end

--回收
function UIChat:_AllocItem()
   if self._cacheItem:Count() == 0 then
        return nil;
   end
   return self._cacheItem:Pop();
end

function UIChat:_ReleaseCaptureItem(cache)
  if cache == nil then
    return;
  end
  self._cacheCaptureItem:Push(cache);
end

--回收
function UIChat:_AllocCaptureItem()
   if self._cacheCaptureItem:Count() == 0 then
        return nil;
   end
   return self._cacheCaptureItem:Pop();
end

function UIChat:_ReleaseItemBtn(cache)
  if cache == nil then
    return;
  end
  self._cacheItemBtn:Push(cache);
end

--回收
function UIChat:_AllocItemBtn()
   if self._cacheItemBtn:Count() == 0 then
        return nil;
   end
   return self._cacheItemBtn:Pop();
end

function UIChat:DoDataExchange()
    self._closeBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/CloseButton");
    
    self._chatScrollView = self:RegisterController(UnityEngine.UI.ScrollRect, "BackgroundImage/DialogBoxObj/Scroll View");
    self._chatBtnContent = self:RegisterController(UnityEngine.Transform, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content");
    self._worldChatBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/WorldButton");
    self._imageRedImage[ChatType.WorldChat] = self:RegisterController(UnityEngine.Transform, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/WorldButton/Image");
    self._imageBtnImage[ChatType.WorldChat] = self:RegisterController(UnityEngine.Transform, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/WorldButton/PWorldButton");
    self._stateChatBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/HonshuButton");
    self._imageRedImage[ChatType.StateChat] = self:RegisterController(UnityEngine.Transform, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/HonshuButton/Image");
    self._imageBtnImage[ChatType.StateChat] = self:RegisterController(UnityEngine.Transform, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/HonshuButton/PHonshuButton");
    self._leagueChatBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/LeagueButton");
    self._imageRedImage[ChatType.AllianceChat] = self:RegisterController(UnityEngine.Transform, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/LeagueButton/Image");
    self._imageBtnImage[ChatType.AllianceChat] = self:RegisterController(UnityEngine.Transform, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/LeagueButton/PLeagueButton");
    self._systemChatBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/SystemButton");
    self._imageRedImage[ChatType.SystemChat] = self:RegisterController(UnityEngine.Transform, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/SystemButton/Image");
    self._imageBtnImage[ChatType.SystemChat] = self:RegisterController(UnityEngine.Transform, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/SystemButton/PSystemButton");

    self._competitionChatBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/CompetitionButton");
    self._imageRedImage[ChatType.CompetitionChat] = self:RegisterController(UnityEngine.Transform, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/CompetitionButton/Image");

    self._addBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content/AddButton");
    --聊天框
    self._chatChannelBtnContent = self:RegisterController(UnityEngine.Transform, "BackgroundImage/NotOpenedBorderImage/Scroll View/Viewport/Content");
    self._chatContent = self:RegisterController(UnityEngine.Transform, "BackgroundImage/DialogBoxObj/Scroll View/Viewport/Content");
    self._Text = self:RegisterController(UnityEngine.UI.Text, "BackgroundImage/DialogBoxObj/Scroll View/Viewport/Text");
    self._leagueBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/DialogBoxObj/Scroll View/Viewport/Button");
    self._timetext = self:RegisterController(UnityEngine.UI.Text, "BackgroundImage/ChatField/Text")
    --发送
    self._chatSent = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/ChatField/SendButton");
    self._chatNotSent = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/ChatField/NotSendButton");
    --输入框
    self._chatInputText = self:RegisterController(UnityEngine.UI.InputField, "BackgroundImage/ChatField/InputField");
    self._chatFieldTransform = self:RegisterController(UnityEngine.Transform, "BackgroundImage/ChatField");
    --精灵
    self._spriteBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/GameGenieButton");
    --语音
    self._voiceChatBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/ChatField/VoiceButton");
    --同盟
    self._allianceChatBtn = self:RegisterController(UnityEngine.UI.Button, "BackgroundImage/ChatField/AllianceChatBtn");
    --次数钻石
    self._spend = self:RegisterController(UnityEngine.Transform, "BackgroundImage/ChatField/NotSpend");
    self._notSpend = self:RegisterController(UnityEngine.Transform, "BackgroundImage/ChatField/Spend");
    self._spendText = self:RegisterController(UnityEngine.UI.Text, "BackgroundImage/ChatField/NotSpend/Text");
end

function UIChat:DoEventAdd()
    self:AddListener(self._closeBtn, self.OnClickCloseBtn);
    
    self:AddListener(self._worldChatBtn, self.OnClickWorldChatBtn);
    self:AddListener(self._stateChatBtn, self.OnClickStateChatBtn);
    self:AddListener(self._leagueChatBtn, self.OnClickLeagueChatBtn);
    self:AddListener(self._systemChatBtn, self.OnClickSystemChatBtn);

    self:AddListener(self._competitionChatBtn, self.OnClickCompetitionChatBtn);
   -- self:AddListener(self._addLeagueChannelChatBtn, self.OnClickAddLeagueChannelChatBtn);
    --self:AddListener(self._addLeagueChatBtn, self.OnClickAddLeagueChatBtnChatBtn);
    self:AddListener(self._addBtn, self.OnClickAddBtn);
    
    self:AddListener(self._leagueBtn, self.OnClickLeagueBtn);

    self:AddListener(self._chatSent, self.OnClickChatSent);
    self:AddListener(self._chatNotSent, self.OnClickChatSent);
    
    self:AddListener(self._spriteBtn, self.OnClickSpriteBtn);
    self:AddListener(self._voiceChatBtn, self.OnClickVoiceChatBtn);

    self:AddListener(self._allianceChatBtn, self.OnClickAllianceChatBtn);
end

--管理
function UIChat:OnClickAllianceChatBtn()
    local msg = require("MessageCommon/Msg/C2L/League/OpenLeagueChatTeam").new();
    msg:SetMessageId(C2L_League.OpenLeagueChatTeam);
    msg.teamPlayerId = self._currentType - ChatType.GroupingChat * 10000;
    NetService:Instance():SendMessage(msg);
end


function UIChat:LoadChatListByType(ChatType, groupingChat)
    return ChatService:Instance():GetChatTableByChatType(ChatType, groupingChat);
end

function UIChat:OnShow()
    self:RefreshContent();
    if self._currentType == 0 then
       self:OnClickWorldChatBtn();
    else
        if self._groupingChat == ChatType.GroupingChat and self._channelBtnItem ~= nil then
            self:_LoadChatListByType(self._currentType, self._groupingChat, self._channelBtnItem);
        else
            self:_LoadChatListByType(self._currentType);
        end
        self._chatInputText.text = "";
    end
    
    for i = 1 ,ChatType.CompetitionChat do
      self:RefreshRedImage(i);
    end
    --显示左侧btn
    self:_ShowBtn();
end

function UIChat:HandleRemoveLeagueChatTeam()
    self:RefreshContent();
    self:OnClickWorldChatBtn();
    self:_ShowBtn();
end

function UIChat:OnHide()
    self._chatScrollView.enabled = false;
end

--创建分组
function UIChat:OnClickAddBtn()
    self._groupingChat = 0;
    local msg = require("MessageCommon/Msg/C2L/League/OpenCreateLeagueChatTeam").new();
    msg:SetMessageId(C2L_League.OpenCreateLeagueChatTeam);
    NetService:Instance():SendMessage(msg);
end

function UIChat:HandlerRnown(chatType, value)
    if chatType == ChatType.StateChat or chatType == ChatType.WorldChat then
        if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue() > value then
            self._chatSent.interactable = true;
        else
            self._chatSent.interactable = false;
        end
    end
end

function UIChat:ShowContent()
    self._chatContent:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D = Vector3.New(
    self._chatContent:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D.x, 0, 0);
    self._chatScrollView.enabled = true;
end

--
function UIChat:RefreshContent()
    self._chatScrollView.enabled = false;
    self._chatContent:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D = Vector3.New(
    self._chatContent:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D.x, 0, 0);
    self._chatScrollView.enabled = true;
end


function UIChat:OpenAllianceChat()
    if self._currentType - (ChatType.GroupingChat * 10000) == PlayerService:Instance():GetPlayerId()
    or self._groupingChat == 0 then
        local baseClass1 = UIService:Instance():GetUIClass(UIType.UIAllianceChat);
        local isopen1 = UIService:Instance():GetOpenedUI(UIType.UIAllianceChat);
        if baseClass1 == nil or isopen1 == false then
            UIService:Instance():ShowUI(UIType.UIAllianceChat);
        end
        return;
    end

    if self._currentType - (ChatType.GroupingChat * 10000) ~= PlayerService:Instance():GetPlayerId() and 
    self._groupingChat == ChatType.GroupingChat then
       local chatLeagueId = self._currentType - (ChatType.GroupingChat * 10000);
       UIService:Instance():ShowUI(UIType.UIAllianceInformation, chatLeagueId);
       return;
    end
end

-- function UIChat:RefreshAddLeagueChatBtn(chatTream)
--     self._addLeagueChatBtn.gameObject:SetActive(true);
--     self._addLeagueChatText.text = chatTream.name;
--     self._imageRedImage[ChatType.AllianceManagerChat].gameObject:SetActive(true);
-- end

-- function UIChat:RefreshAddLeagueChannelChatBtn(chatTream)
--     self._addLeagueChannelChatBtn.gameObject:SetActive(true);
--     self._addLeagueChannelChatText.text = chatTream.name.."/n"..chatTream.leaderName;
--     self._imageRedImage[ChatType.GroupingChat].gameObject:SetActive(true);
-- end

function UIChat:RefreshAddBtn()
    if PlayerService:Instance():GetLeagueId() ~= 0 and PlayerService:Instance():GetPlayerTitle() ~= LeagueTitleType.Nomal
    and LeagueService:Instance():FindLeagueChatTeam(PlayerService:Instance():GetPlayerId()) == nil then
       self._addBtn.transform:SetAsLastSibling();
       self._addBtn.gameObject:SetActive(true);
    else
       self._addBtn.gameObject:SetActive(false);
    end
end

function UIChat:_ShowBtn()
    self:RefreshAddBtn();
   -- self._addLeagueChatBtn.gameObject:SetActive(false);
  --  self._addLeagueChannelChatBtn.gameObject:SetActive(false);
    --分组按钮
    self:RefreshChannelBtn();
end

function UIChat:OnClickLeagueBtn()
     LeagueService:Instance():SendLeagueMessage();
     UIService:Instance():HideUI(UIType.UIChat);
end

function UIChat:OnClickCloseBtn()
   self._chatTream = {};
   --self._currentType = 0;
   UIService:Instance():HideUI(UIType.UIChat);
   UIService:Instance():ShowUI(UIType.UIGameMainView);
end

function UIChat:OnClickWorldChatBtn()
    self:_LoadChatListByType(ChatType.WorldChat);
    self._chatInputText.text = "";
end

--赛季
function UIChat:OnClickCompetitionChatBtn()
    self:_LoadChatListByType(ChatType.CompetitionChat);
    self._chatInputText.text = "";
end

--同盟分组
-- function UIChat:OnClickAddLeagueChannelChatBtn()
--     self:_LoadChatListByType(ChatType.GroupingChat);
-- end

--创建同盟分组
function UIChat:OnClickAddLeagueChatBtnChatBtn()
  --print("聊天分组"..UIType.UIAllianceChat)
  --UIService:Instance():ShowUI(UIType.UIAllianceChat);
  --self:_LoadChatListByType(ChatType.AllianceManagerChat);
end

function UIChat:_AllocBtnItem()
    if self._cacheBtnItem:Count() == 0 then
        return nil;
    end
    return self._cacheBtnItem:Pop();
end

function UIChat:_ReleaseBtnItem(cache)
    if cache == nil then
       return;
    end
    self._cacheBtnItem:Push(cache);
    cache.gameObject:SetActive(false);
end

function UIChat:_HideChannelBtn(item)
    self:_ReleaseBtnItem(item);
    self:RemoveChannelBtn(item._chatType);
end

function UIChat:SetChannelBtn(transform, chatType, redTransform)
    self._imageBtnImage[chatType] = transform;
    self._imageRedImage[chatType] = redTransform;
end

function UIChat:RemoveChannelBtn(chatType)
    self._imageBtnImage[chatType] = nil;
    self._imageRedImage[chatType] = nil;
end

function UIChat:_CreatChannelBtn(chatTeam)
    local item = self:_AllocBtnItem();
    if item == nil then
        item = UIChannelItem.new();
        GameResFactory.Instance():GetUIPrefab("UIPrefab/".."AddLeagueChannelButton", self._chatChannelBtnContent, item, function (go)
        item:DoDataExchange();
        item:DoEventAdd();
        item:OnShow(chatTeam, self);
        item.transform:SetSiblingIndex(self._chatChannelBtnContent:GetChild(self._chatChannelBtnContent.childCount - 1):GetSiblingIndex());
        self:_SetBtnItem(item);
        end);
    else
       item:OnShow(chatTeam, self);
       item.transform:SetSiblingIndex(self._chatChannelBtnContent:GetChild(self._chatChannelBtnContent.childCount - 1):GetSiblingIndex());
       item.gameObject:SetActive(true);
       self:_SetBtnItem(item);
    end
end

function UIChat:RefreshChannelBtn()
    self:HideChannelBtn();
    self:ShowChannelBtn();
end

function UIChat:ShowChannelBtn()
    self._chatTream = LeagueService:Instance():GetLeagueChatTeam();
    for k,v in pairs(self._chatTream) do
        -- if k == PlayerService:Instance():GetPlayerId() then
        --     self:RefreshAddLeagueChatBtn(v);
        if k ~= 0 then
            self:_CreatChannelBtn(v);
            --self:RefreshAddLeagueChannelChatBtn(v);
        end
        if k == PlayerService:Instance():GetPlayerId() then
            self._addBtn.gameObject:SetActive(false);
        end
    end
end

-- function UIChat:ShowChannelBtnRedImage()
--     self._btnItem:ForEach(function ( ... )
--         self:ShowBtnRedImage(...)
--     end);
-- end

-- function UIChat:ShowBtnRedImage(item)
--     item:ShowRedImage();
-- end

function UIChat:HideChannelBtn()
    self._btnItem:ForEach(function ( ... )
        self:_HideChannelBtn(...)
    end);

    self._btnItem:Clear();
end

function UIChat:_SetBtnItem(item)
    self._btnItem:Push(item);
end

function UIChat:_CreatBtn(chatContent)
    local item = nil;
    if self:judgeChatContenType(chatContent.mType) == ChatsTotalType.Battle
    and self._currentType == ChatType.WorldChat then
        item = self:_AllocCaptureItem();
        if item == nil then
            item = UIChatContentItemBtnItem.new();
            GameResFactory.Instance():GetUIPrefab("UIPrefab/".."ChatDetailsCaptureButton", self._chatContent, item, function (go)
            item:DoDataExchange();
            item:DoEventAdd();
            item:OnShow(self._currentType, chatContent);
            self:_SetItem(item);
            end);
        else
           item:OnShow(self._currentType, chatContent);
           item.transform:SetAsLastSibling();
           item.gameObject:SetActive(true);
           self:_SetItem(item);
        end
        item.transform:SetAsFirstSibling();
    else
        item = self:_AllocItem();
        if item == nil then
            item = UIChatContentItemBtnItem.new();
            GameResFactory.Instance():GetUIPrefab("UIPrefab/".."ChatDetailsButton", self._chatContent, item, function (go)
            item:DoDataExchange();
            item:DoEventAdd();
            item:OnShow(self._currentType, chatContent);
            self:_SetItem(item);
            end);
        else
           item:OnShow(self._currentType, chatContent);
           item.transform:SetAsLastSibling();
           item.gameObject:SetActive(true);
           self:_SetItem(item);
        end
    end
end

function UIChat:judgeChatContenType(chatContentType)
    if chatContentType == ChatContentType.FightAAType or chatContentType == ChatContentType.FightAWType 
    or chatContentType == ChatContentType.FirstWildBattleWType or chatContentType == ChatContentType.FirstWildBattleSType 
    or chatContentType == ChatContentType.FallAllianceType then
       return ChatsTotalType.Battle;
    elseif chatContentType == ChatContentType.StringType then
       return ChatsTotalType.String;
    else
       return ChatsTotalType.Event;
    end
end

function UIChat:_HideBtn()
    self._Item:ForEach(function ( ... )
        self:_HideBtnByType(...)
    end);

    self._Item:Clear();
end

function UIChat:_HideBtnByType(item)
    local mType, mchatType = item:GetType();
    if self:judgeChatContenType(mType) == ChatsTotalType.Battle and mchatType == ChatType.WorldChat then 
         self:_ReleaseCaptureItem(item);
    else
         self:_ReleaseItem(item);
    end
    self._currentHeight = self._currentHeight - item.gameObject:GetComponent(typeof(UnityEngine.UI.LayoutElement)).minHeight;

    item.gameObject:SetActive(false);
end

function UIChat:RefreshBtnImageByType(chatType)
    for k,v in pairs(self._imageBtnImage) do
        if chatType == k then
            if v.gameObject.activeSelf == false then
               v.gameObject:SetActive(true);
            end
        else
            if v.gameObject.activeSelf == true then
               v.gameObject:SetActive(false);
            end
        end
    end
end

function UIChat:_LoadChatListByType(chatType, groupingChat, item)
    self:RefreshBtnImageByType(chatType);
    self._groupingChat = groupingChat;
    self._channelBtnItem = item;
    self._currentType = chatType;
    self:RefreshSentBtn(self._currentType);
    self:RefreshContent();
    self:HandlerSpend(self._currentType);

    if PlayerService:Instance():GetLeagueId() == 0 then
       ChatService:Instance():ClearChatByType(ChatType.AllianceChat);
    end
    --未读处理
    ChatService:Instance():SetUnread(chatType, groupingChat);
    if item == nil then 
        if self._imageRedImage[chatType].gameObject.activeSelf == true then
           self._imageRedImage[chatType].gameObject:SetActive(false);
        end
    else
        item:ClickRedImage();
    end
   
    local chatQueue = self:LoadChatListByType(chatType, groupingChat);
    --输入框
    if chatType == ChatType.StateChat or (chatType == ChatType.AllianceChat and PlayerService:Instance():GetLeagueId() ~= 0) 
      or chatType == ChatType.WorldChat or groupingChat == ChatType.GroupingChat then
        self._chatFieldTransform.gameObject:SetActive(true);
    else
        self._chatFieldTransform.gameObject:SetActive(false);
    end

    --声望判断
    if chatType == ChatType.WorldChat then
        self:HandlerRnown(chatType, 3000);
    end
    if chatType == ChatType.StateChat then
        self:HandlerRnown(chatType, 2500);
    end

    --同盟管理
    self:RefreshAllianceChatBtn(groupingChat);

    self:_HideBtn();

    if chatQueue == nil or chatQueue:Count() == 0 then
        self._Text.text = "无内容";
    else
        self._Text.text = "";
        chatQueue:ForEach(function(...)
           self:_CreatBtn(...);
        end);
        if self._currentHeight > self._limitHeight then
            self._chatContent:GetComponent(typeof(UnityEngine.UI.ContentSizeFitter)).enabled = true;
        else
            self._chatContent:GetComponent(typeof(UnityEngine.UI.ContentSizeFitter)).enabled = false;
            self._chatContent:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(954, self._limitHeight);
        end
    end
    
    self:RefreshTime(self._currentType);
    
    if self._currentType == ChatType.AllianceChat then
        self._chatInputText.text = "";
        if PlayerService:Instance():GetLeagueId() == 0 then
            self._Text.text = "请先加入同盟";
            self._leagueBtn.gameObject:SetActive(true);
        elseif self._leagueBtn.gameObject.activeSelf == true and PlayerService:Instance():GetLeagueId() ~= 0 then
            self._leagueBtn.gameObject:SetActive(false);
        end
    else
        if self._leagueBtn.gameObject.activeSelf == true then
            self._leagueBtn.gameObject:SetActive(false);
        end
    end
end

function UIChat:HandlerSpend(chatType)
    if chatType == ChatType.WorldChat then
        if PlayerService:Instance():GetPlayerChatTimes() > 0 then
            if self._spend.gameObject.activeSelf == false then
               self._spend.gameObject:SetActive(true);
            end
            if self._notSpend.gameObject.activeSelf == true then
               self._notSpend.gameObject:SetActive(false);
            end
            self._spendText.text = "免费次数("..PlayerService:Instance():GetPlayerChatTimes().."/10)";
        else
            if self._spend.gameObject.activeSelf == true then
               self._spend.gameObject:SetActive(false);
            end
            if self._notSpend.gameObject.activeSelf == false then
               self._notSpend.gameObject:SetActive(true);
            end
        end
    else
        if self._spend.gameObject.activeSelf == true then
           self._spend.gameObject:SetActive(false);
        end
        if self._notSpend.gameObject.activeSelf == true then
           self._notSpend.gameObject:SetActive(false);
        end
    end
end

function UIChat:RefreshAllianceChatBtn(groupingChat)
    if groupingChat == ChatType.GroupingChat then
        if self._allianceChatBtn.gameObject.activeSelf == false then
           self._allianceChatBtn.gameObject:SetActive(true);
        end
    else
        if self._allianceChatBtn.gameObject.activeSelf == true then
           self._allianceChatBtn.gameObject:SetActive(false);
       end
    end
end

function UIChat:OnClickStateChatBtn()
    self:_LoadChatListByType(ChatType.StateChat);
    self._chatInputText.text = "";
end

function UIChat:OnClickLeagueChatBtn()
    self:_LoadChatListByType(ChatType.AllianceChat);
end

function UIChat:OnClickSystemChatBtn()
    self:_LoadChatListByType(ChatType.SystemChat);
    self._chatInputText.text = "";
end

function UIChat:OnClickChatSent()
    --冷却时间
    if self._time[self._currentType] ~= nil then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,114);
        return;
    end

    --声望不足
    if self._currentType == ChatType.WorldChat then
        if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue() < 3000 then
            local text = {};
            text[1] = 111;
            text[2] = {"3000"};
            UIService:Instance():ShowUI(UIType.UICueMessageBox, text);
            return;
        end
    elseif self._currentType == ChatType.StateChat then
      if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Rnown):GetValue() < 2500 then
          local text = {};
          text[1] = 111;
          text[2] = {"2500"};
          UIService:Instance():ShowUI(UIType.UICueMessageBox, text);
          return;
      end
    end
    --違禁字符
    if CommonService:Instance():LimitText(self._chatInputText.text) then
        self._chatInputText.text = "";
        return;
    end

    --字符限制
    if CommonService:Instance():JudeStringGetTrueCount(self._chatInputText.text, #self._chatInputText.text) > 60 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,503);
        return;
    end
    --空格处理
    self._chatInputText.text = self:HandlerSendChat(self._chatInputText.text, #self._chatInputText.text);

    --发送信息为空
    if self._chatInputText.text == nil or self._chatInputText.text == "" then
        UIService:Instance():ShowUI(UIType.UICueMessageBox,105);
        return;
    end
    
    if self._currentType == ChatType.WorldChat then
        if PlayerService:Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue() >= 5 then
            local msg = require("MessageCommon/Msg/C2L/Player/RequestChatTimes").new();
            msg:SetMessageId(C2L_Player.RequestChatTimes);
            NetService:Instance():SendMessage(msg);
        else
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 100);
        end
    else
        self:SendChatMessage();
    end
end

--发送聊天内容
function UIChat:SendChatMessage()
    if self._chatInputText.text == "" then
        return;
    end
    local msg = require("MessageCommon/Msg/C2Chat/Chat/SendChat").new();
    msg:SetMessageId(C2Chat_Chat.SendChat);
    if self._groupingChat == nil or self._groupingChat == 0 then
       msg.channelId = self._currentType * 10000 + self:_GetChannelId(self._currentType);
    else
       msg.channelId = self._currentType;
    end
    msg.playerId = PlayerService:Instance():GetPlayerId();
    msg.mType = ChatContentType.StringType;
    msg.content = self._chatInputText.text;
    msg.buildingName = "";
    NetService:Instance():SendMessage(msg);
end

function UIChat:HandlerTime()
    if self._currentType == ChatType.WorldChat or self._currentType == ChatType.StateChat then
        self:_timeText(self._currentType);
    end
    self._chatInputText.text = "";
end

function UIChat:HandlerSendChat(value, index)
    local str = value;
    local i = 1;
    local lastCount = 1;
    repeat
        str, i = self:HandlerSpace(str, i, index);
        lastCount = self:SubStringGetByteCount(value, i);
        i = i + lastCount;
    until(i > index);
    return str;
end

function UIChat:HandlerSpace(str, index, maxIndex)
    local i = index;
    local lastCount = 1;
    repeat
        lastCount = self:SubStringGetByteCount(str, i);
        i = i + lastCount;
    until(tostring(string.sub(str, i, i)) == "" or self:SubSpace(string.sub(str, i, i)) == false or i > maxIndex);
    if self:SubSpace(string.sub(str, 1, 1)) == true then
        if index == 1 and i - 1 ~= index then
            return string.sub(str, i, maxIndex), i;
        end
        return string.sub(str, 2, 1), i;
    else
        return string.sub(str, 1, maxIndex), i;
    end

    if i - 1 == maxIndex and i - 1 ~= index and index ~= 1 then
        return string.sub(str, 1, i), maxIndex;
    end
    
    return str, index;
end

function UIChat:SubSpace(str)
    local curByte = string.byte(str)
    if curByte == 32 then
        return true;
    end
    return false;
end

function UIChat:SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte>=192 and curByte<=223 then
        byteCount = 2
    elseif curByte>=224 and curByte<=239 then
        byteCount = 3
    elseif curByte>=240 and curByte<=247 then
        byteCount = 4
    end
    return byteCount;
end

function UIChat:_GetChannelId(chatType)
    if chatType == ChatType.WorldChat then
      return 0;
    elseif chatType == ChatType.StateChat then
      return PlayerService:Instance():GetSpawnState();
    elseif chatType == ChatType.AllianceChat then
      return PlayerService:Instance():GetLeagueId();
    elseif chatType == ChatType.SystemChat then
      return PlayerService:Instance():GetPlayerId();
    -- elseif chatType == ChatType.GroupingChat then
    --   return self.chatTeam;
    elseif ChatType == ChatType.CompetitionChat then
      return 500000000000000;
    end
end

--刷新界面
function UIChat:Refresh()
    local baseClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIGameMainView);

    if baseClass ~= nil and isopen == true then
        return;
    end

    if self._currentType == 0 then
       return;
    end

    for i = 1 ,ChatType.CompetitionChat do
      self:RefreshRedImage(i);
    end
    local chatTream = LeagueService:Instance():GetLeagueChatTeam();
    for k,v in pairs(chatTream) do
         self:RefreshRedImage(ChatType.GroupingChat * 10000 + v.leaderId, ChatType.GroupingChat);
    end

    if self._groupingChat == ChatType.GroupingChat and self._channelBtnItem ~= nil then
        self:_LoadChatListByType(self._currentType, self._groupingChat, self._channelBtnItem);
    else
        self:_LoadChatListByType(self._currentType);
    end
    --self:RefreshContent();
end

function UIChat:RefreshRedImage(chatType, groupingChat)
  if chatType == self._currentType then
    return;
  end

  local count = ChatService:Instance():GetUnread(chatType, groupingChat);

  if count ~= 0 then
      if self._imageRedImage[chatType].gameObject.activeSelf == false then
         self._imageRedImage[chatType].gameObject:SetActive(true);
      end
  end
end

function UIChat:RefreshSentBtn(chatType)
    if self._currentType == chatType then
        if self._time[chatType] ~= nil then
            self._chatNotSent.gameObject:SetActive(true);
        else
            self._chatNotSent.gameObject:SetActive(false);
        end
    end
end

function UIChat:RefreshTime(chatType)
    if chatType == nil then
        return;
    end

    if self._time[chatType] == nil then
        self._timetext.text = "";
    end
end

--开始冷却
function UIChat:_timeText(chatType)
    local cdTime = 0;
    if self._time[chatType] == nil then
        if chatType == ChatType.WorldChat then
            cdTime = 21;
        elseif chatType == ChatType.StateChat then
            cdTime = 6;
        end
        --按钮变色
        self._chatNotSent.gameObject:SetActive(true);
          self._time[chatType] = Timer.New(function()
          cdTime = cdTime > 0 and cdTime - 1 or 0
              if self._currentType == chatType then
                self._timetext.text = cdTime.."s";
              end
              if cdTime == 0 then
                if self._currentType == chatType then
                    self._timetext.text = "";
                end
                 self._time[chatType]:Stop();
                 self._time[chatType] = nil;
                 self:RefreshSentBtn(chatType)
              end
          end, 1, -1, false);
          self._time[chatType]:Start();
    else
        --UIService:Instance():ShowUI(UIType.UICueMessageBox,114);
    end
end

--懲罰時間
function UIChat:_penaltyTimeText(chatType, haveTime)
    local cdTime = 0;
    if self._time[chatType] == nil then
        cdTime = 20 * haveTime;
        --按钮变色
        self._chatNotSent.gameObject:SetActive(true);
          self._time[chatType] = Timer.New(function()
          cdTime = cdTime > 0 and cdTime - 1 or 0
              if self._currentType == chatType then
                 self._timetext.text = cdTime.."s";
              end
              if cdTime == 0 then
                 self._timetext.text = "";
                 self._time[chatType]:Stop();
                 self._time[chatType] = nil;
                 self._chatNotSent.gameObject:SetActive(false);
              end
          end, 1, -1, false);
          self._time[chatType]:Start();
    else
        --UIService:Instance():ShowUI(UIType.UICueMessageBox,114);
    end
end

function UIChat:OnClickSpriteBtn()
    UIService:Instance():ShowUI(UIType.UICueMessageBox,103);
end

function UIChat:OnClickVoiceChatBtn()
    UIService:Instance():ShowUI(UIType.UICueMessageBox,103);
end

return UIChat