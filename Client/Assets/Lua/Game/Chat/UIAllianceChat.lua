-- region *.lua
-- Date16/10/22


local UIBase = require("Game/UI/UIBase")
local List = require("common/List");
local MoveTime = 0.3;
local UIAllianceChat = class("UIAllianceChat", UIBase);

function UIAllianceChat:ctor()
    UIAllianceChat.super.ctor(self);
    self.closeBtn = nil;
    --创建
    self.creatChannelBtn = nil;
    self.noCreatChannelBtn = nil;

    --self.channelNameBtn = nil;
    self.channelQuestionBtn = nil;
    self.channelText = nil;
    self.channelInputField = nil;
    self.channelBtn = nil;
    self.mText = nil;
    
    self.channel = nil;
    self.member = nil;
    self.channelContent = nil;
    self.memberContent = nil;
    
    self._channelItem = List.new();
    self._memberItem = List.new();

    self.memberBtn = nil;
    self.memberText = nil;
    --添加
    self.addMemberBtn = nil;
    self.noAddMemberBtn = nil;
    self.removeChannelBtn = nil;

    self._chatTream = nil;
    --成员处理
    self._channelList = List.new();
    self._memberList = List.new();
    --预设缓存
    self._cacheChannelItem = Queue.new();
    self._cacheMemberItem = Queue.new();
    --临时
    self._addMemberList = List.new();
    --self:_addChannelList = List.new();
end

-- 注册控件
function UIAllianceChat:DoDataExchange()
    self.closeBtn = self:RegisterController(UnityEngine.UI.Button, "channel/Image/CloseButton");

    self.creatChannelBtn = self:RegisterController(UnityEngine.UI.Button, "channel/Image/CreatButton");
    self.noCreatChannelBtn = self:RegisterController(UnityEngine.UI.Button, "channel/Image/NoCreatButton");
    --self.channelNameBtn = self:RegisterController(UnityEngine.UI.Button, "channel/Image/Name/channelname");
    self.channelQuestionBtn = self:RegisterController(UnityEngine.UI.Button, "channel/Image/PopupG/questionBtn");
    self.channelText = self:RegisterController(UnityEngine.UI.Text, "channel/Image/PopupG/NumText");
    self.channelInputField = self:RegisterController(UnityEngine.UI.InputField, "channel/Image/Name/InputField");
    self.channelBtn = self:RegisterController(UnityEngine.UI.Button, "channel/channelbutton");
    self.mText = self:RegisterController(UnityEngine.UI.Text, "member/Image/Text");
    self.channelContent = self:RegisterController(UnityEngine.Transform, "channel/Image/Scroll View/Viewport/Content");
    self.memberContent = self:RegisterController(UnityEngine.Transform, "member/Scroll View/Viewport/Content");
    
    self.channel = self:RegisterController(UnityEngine.Transform, "channel");
    self.member = self:RegisterController(UnityEngine.Transform, "member");
    self.channelImage = self:RegisterController(UnityEngine.Transform, "channel/channelbutton/Image");
    --
    self.memberBtn = self:RegisterController(UnityEngine.UI.Button, "member/Image/memberbutton");
    self.memberText = self:RegisterController(UnityEngine.UI.Text, "member/Image/NumText");
    
    self.addMemberBtn = self:RegisterController(UnityEngine.UI.Button, "member/AddButton");
    self.noAddMemberBtn = self:RegisterController(UnityEngine.UI.Button, "member/NoAddButton");
    self.removeChannelBtn = self:RegisterController(UnityEngine.UI.Button, "channel/Image/RemoveButton");
end

-- 监测控件
function UIAllianceChat:DoEventAdd()
    self:AddListener(self.closeBtn, self.OnClickCloseBtn)

    self:AddListener(self.creatChannelBtn, self.OnClickCreatChannelBtn)
    self:AddListener(self.noCreatChannelBtn, self.OnClickNoCreatChannelBtn)
    self:AddListener(self.channelQuestionBtn, self.OnClickChannelQuestionBtn)
    self:AddListener(self.channelBtn, self.OnClickChannelBtn)
    self:AddListener(self.memberBtn, self.OnClickMemberBtn)

    self:AddListener(self.addMemberBtn, self.OnClickAddMemberBtn)
    self:AddListener(self.noAddMemberBtn, self.OnClickNoAddMemberBtn)
    self:AddListener(self.removeChannelBtn, self.OnClickRemoveChannelBtn)

    self:AddInputFieldOnEndEdit(self.channelInputField, self.OnClickChannelInputField)
end

function UIAllianceChat:RegisterAllNotice()
   --离开频道
   --self:RegisterNotice(L2C_League.OpenLeagueChatTeamRespond, self.OnShow);
end

function UIAllianceChat:_AllocChannelItem()
   if self._cacheChannelItem:Count() == 0 then
        return nil;
   end
   return self._cacheChannelItem:Pop();
end

function UIAllianceChat:_ReleaseChannelItem(cache)
  if cache == nil then
    return;
  end
  self._cacheChannelItem:Push(cache);
  cache.gameObject:SetActive(false);
end

function UIAllianceChat:_AllocMemberItem()
   if self._cacheMemberItem:Count() == 0 then
        return nil;
   end
   return self._cacheMemberItem:Pop();
end

function UIAllianceChat:_ReleaseMemberItem(cache)
  if cache == nil then
    return;
  end
  self._cacheMemberItem:Push(cache);
  cache.gameObject:SetActive(false);
end

function UIAllianceChat:OnShow()
    self._addMemberList:Clear();
    self:RefreshName();
    self:RefreshBtn();
    self:RefreshChannelBtn();
end

function UIAllianceChat:RefreshChannelBtn()
    if LeagueService:Instance():FindLeagueChatTeam(PlayerService:Instance():GetPlayerId()) == nil then
        self.removeChannelBtn.gameObject:SetActive(false);
    else
        self.removeChannelBtn.gameObject:SetActive(true);
    end
end

function UIAllianceChat:RefreshName()
    local name = LeagueService:Instance():GetChatTeamName();
    if name == "" or name == nil then
        self.channelInputField.text = "";
        --self.channelNameBtn.gameObject:SetActive(false);
    else
        self.channelInputField.text = name;
        --self.channelNameBtn.gameObject:SetActive(true);
    end
end

function UIAllianceChat:OnClickCreatChannelBtn()
    if CommonService:Instance():LimitText(self.channelInputField.text) then
        self.channelInputField.text = LeagueService:Instance():GetChatTeamName();
        self:RefreshAddBtn();
        return;
    end

    local msg = require("MessageCommon/Msg/C2L/League/CreateLeagueChatTeamQuest").new();
    msg:SetMessageId(C2L_League.CreateLeagueChatTeamQuest);
    msg.name = self.channelInputField.text;
    local count = self._channelList:Count();
    for i = 1, count do
        msg.list:Push(self._channelList:Get(i).playerId);
    end
    --msg.list = self._channelList;
    NetService:Instance():SendMessage(msg);
end

function UIAllianceChat:OnClickNoCreatChannelBtn()
    if self._addMemberList:Count() == 0 then
       UIService:Instance():ShowUI(UIType.UICueMessageBox, 513);
    end
    
    if self.channelInputField.text == "" then
       UIService:Instance():ShowUI(UIType.UICueMessageBox, 514);
    end
end

function UIAllianceChat:RefreshBtn()
    self:HideBtnChannelItem();
    self:HideBtnMemberItem();
    self:ShowBtn();
end

function UIAllianceChat:HideBtnChannelItem()
    self._channelItem:ForEach(function ( ... )
        self:_HideChannelItem(...)
    end);

    self._channelItem:Clear();
end

function UIAllianceChat:HideBtnMemberItem()
    self._memberItem:ForEach(function ( ... )
        self:_HideMemberItem(...)
    end);

    self._memberItem:Clear();
end

function UIAllianceChat:_HideChannelItem(item)
    self:_ReleaseChannelItem(item);
    --item.gameObject:SetActive(false);
end

function UIAllianceChat:_HideMemberItem(item)
    self:_ReleaseMemberItem(item);
    --item.gameObject:SetActive(false);
end

function UIAllianceChat:ShowBtn()

    self._memberList = LeagueService:Instance():GetCanInventList();
    self._channelList = LeagueService:Instance():GetTeamList();
    local canInventCount = 0;
    local teamCount = 0;
    if self._memberList ~= nil then
       canInventCount = self._memberList:Count();
    end

    if self._channelList ~= nil then
       teamCount = self._channelList:Count();
    end

    if teamCount == 0 then
        local mChatMember = require("MessageCommon/Msg/L2C/League/ChatMemberModel").new();
        mChatMember.playerId = PlayerService:Instance():GetPlayerId();
        mChatMember.name = PlayerService:Instance():GetName();
        self._channelList:Push(mChatMember);
        teamCount = teamCount + 1;
    end
    self:CreatBtn(canInventCount, teamCount)
end

function UIAllianceChat:CreatBtn(canInventCount, teamCount)
    self.memberText.text = "("..teamCount.."/50)";

    if canInventCount == 0 then
        self.mText.gameObject:SetActive(true);
    else
        self.mText.gameObject:SetActive(false);
    end

    for i = 1, canInventCount do
        local MemberItem = self:_AllocMemberItem();
        if MemberItem == nil then
            MemberItem = require("Game/Chat/UIAllocMemberItem").new();
            GameResFactory.Instance():GetUIPrefab("UIPrefab/".."AllianceChaTwo", self.memberContent, MemberItem, function (go)
            MemberItem:DoDataExchange();
            MemberItem:DoEventAdd();
            MemberItem:OnShow(self._memberList:Get(i), self);
            self:_ItemSibling(MemberItem, self._memberList:Get(i).playerId);
            self:_SetMemberItem(MemberItem);
            end);
        else
           MemberItem:OnShow(self._memberList:Get(i), self);
           self:_ItemSibling(MemberItem, self._memberList:Get(i).playerId);
           MemberItem.gameObject:SetActive(true);
           self:_SetMemberItem(MemberItem);
        end
    end

    self.channelText.text = "("..teamCount.."/50)";
    for n = 1, teamCount do
        local ChannelItem = self:_AllocChannelItem();
        if ChannelItem == nil then
            ChannelItem = require("Game/Chat/UIAllocChannelItem").new();
            GameResFactory.Instance():GetUIPrefab("UIPrefab/".."AllianceChatOne", self.channelContent, ChannelItem, function (go)
            ChannelItem:DoDataExchange();
            ChannelItem:DoEventAdd();
            ChannelItem:OnShow(self._channelList:Get(n), self);
            self:_ItemSibling(ChannelItem, self._channelList:Get(n).playerId);
            self:_SetChannelItem(ChannelItem);
            end);
        else
           ChannelItem:OnShow(self._channelList:Get(n), self);
           self:_ItemSibling(ChannelItem, self._channelList:Get(n).playerId);
           ChannelItem.gameObject:SetActive(true);
           self:_SetChannelItem(ChannelItem);
        end
    end
    self:RefreshAddBtn();
end

function UIAllianceChat:_ItemSibling(item, id)
    if id == PlayerService:Instance():GetPlayerId() then
        item.transform:SetAsFirstSibling();
    else
        item.transform:SetAsLastSibling();
    end
end

function UIAllianceChat:_SetChannelItem(value)
      if value == nil then
         return;
      end
      self._channelItem:Push(value);
end

function UIAllianceChat:_SetMemberItem(value)
      if value == nil then
        return;
      end
      self._memberItem:Push(value);
end

function UIAllianceChat:AddChatMember(value)
    if self:AddLimitChatMember() then
        return;
    end
    self._addMemberList:Push(value);
    self:RefreshAddBtn();
end

function UIAllianceChat:AddLimitChatMember(channelNum)
    local mchannelNum = 1;
    if channelNum ~= nil then
        mchannelNum = channelNum;
    end

    if self._addMemberList:Count() + mchannelNum > 50 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 511);
        return true;
    end
    return false;
end

function UIAllianceChat:FindAddChatMember(value)
    if value == nil then
        return;
    end
    local count = self._addMemberList:Count();
    for i = 1, count do
        if self._addMemberList:Get(i) == value then
            return true;
        end
    end
    return false;
end

function UIAllianceChat:FindChatChannel(value)
    if value == nil then
        return;
    end
    local count = self._channelList:Count();
    for i = 1, count do
        if self._channelList:Get(i) == value then
            return true;
        end
    end
    return false;
end

function UIAllianceChat:RemoveAddChatMember(value)
    self._addMemberList:Remove(value);
    self:RefreshAddBtn();
end

function UIAllianceChat:RemoveChatMember(value)
    LeagueService:Instance():GetCanInventList():Push(value);
    LeagueService:Instance():GetTeamList():Remove(value);
   -- self._memberList:Push(value);
   -- self._channelList:Remove(value);
    self:RefreshBtn();
end

function UIAllianceChat:RefreshAddBtn()
    if self._addMemberList:Count() > 0 then
        self.noAddMemberBtn.gameObject:SetActive(false);
        --self.addMemberBtn.interactable = true;
    else
        self.noAddMemberBtn.gameObject:SetActive(true);
        --self.addMemberBtn.interactable = false;
    end

    if self._channelList:Count() > 1 and self.channelInputField.text ~= "" then
        self.noCreatChannelBtn.gameObject:SetActive(false);
        --self.creatChannelBtn.interactable = true;
    else
        self.noCreatChannelBtn.gameObject:SetActive(true);
        --self.creatChannelBtn.interactable = false;
    end
end

function UIAllianceChat:Refresh()
    self._chatTream = LeagueService:Instance():GetLeagueChatTeam();
    for k,v in pairs(self._chatTream) do
        if k == PlayerService:Instance():GetPlayerId() then
            self:RefreshAddLeagueChatBtn(v);
        elseif k == 0 then
        else
            self:RefreshAddLeagueChannelChatBtn(v);
        end
    end
end


-- 点击事件
function UIAllianceChat:OnClickCloseBtn()
    self._channelList:Clear();
    self._memberList:Clear();
    self._addMemberList:Clear();
    UIService:Instance():HideUI(UIType.UIAllianceChat)
end

--移动回来
function UIAllianceChat:OnClickChannelBtn()
    self.channelBtn.gameObject:SetActive(false);
    self:ChangeMemberTransform(function ()
      -- self:ChangeChannelTransform(function ()
      -- end, self.channelBtn:GetComponent(typeof(UnityEngine.Material)).color, Vector3.New(0, 0, 0));
   end, self.member:GetComponent(typeof(UnityEngine.RectTransform)), Vector3.New(330, self.member:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D.y, 0));

    self:ChangeMemberTransform(function ()
    end, self.channel:GetComponent(typeof(UnityEngine.RectTransform)), Vector3.New(-83, self.channel:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D.y, 0));
end

--名字
-- function UIAllianceChat:OnClickChannelNameBtn()
--     local msg = require("MessageCommon/Msg/C2L/League/ChangeLeagueChatTeamName").new();
--     msg:SetMessageId(C2L_League.ChangeLeagueChatTeamName);
--     msg.name = self.channelInputField.text;
--     NetService:Instance():SendMessage(msg);
-- end

--帮助
function UIAllianceChat:OnClickChannelQuestionBtn()
    local temp = {};
    temp[1] = "说明"
    temp[2] = "填表";
    UIService:Instance():ShowUI(UIType.UICommonTipSmall, temp)
end

-- function UIAllianceChat:_ShowChannelItem(item)
--     item:Refresh();
-- end

--移动
function UIAllianceChat:OnClickMemberBtn()
    self:ChangeMemberTransform(function ()
      self.channelBtn.gameObject:SetActive(true);
    end, self.member:GetComponent(typeof(UnityEngine.RectTransform)), 
    Vector3.New(0, self.member:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D.y, 0));
    
    self:ChangeMemberTransform(function ()
    end, self.channel:GetComponent(typeof(UnityEngine.RectTransform)), Vector3.New(0, self.channel:GetComponent(typeof(UnityEngine.RectTransform)).anchoredPosition3D.y, 0));
end

--添加
function UIAllianceChat:OnClickAddMemberBtn()
    if LeagueService:Instance():FindLeagueChatTeam(PlayerService:Instance():GetPlayerId()) == nil then
        local count = self._addMemberList:Count();
        for i = 1, count do
            LeagueService:Instance():GetCanInventList():Remove(self._addMemberList:Get(i));
            LeagueService:Instance():GetTeamList():Push(self._addMemberList:Get(i));
            -- self._memberList:Remove(self._addMemberList:Get(i));
            -- self._channelList:Push(self._addMemberList:Get(i));
        end
        self._addMemberList:Clear();
        self:RefreshBtn();
        self:OnClickMemberBtn();
    else
        if self:AddLimitChatMember(self._channelList:Count()) then
            return;
        end
        local msg = require("MessageCommon/Msg/C2L/League/InviteOtherJoinLeagueChatTeam").new();
        msg:SetMessageId(C2L_League.InviteOtherJoinLeagueChatTeam);
        local count = self._addMemberList:Count();
        for i = 1, count do
            msg.list:Push(self._addMemberList:Get(i).playerId);
        end
        NetService:Instance():SendMessage(msg);
    end
end

function UIAllianceChat:OnClickNoAddMemberBtn()
    UIService:Instance():ShowUI(UIType.UICueMessageBox, 513);
end

--解散
function UIAllianceChat:OnClickRemoveChannelBtn()
    CommonService:Instance():ShowOkOrCancle(
        self,function()  self:CommonOk() end,
        function()  end,
        "解散频道",
        "确认解散频道",
        "确认",
        "取消")
end

function UIAllianceChat:CommonOk()
    local msg = require("MessageCommon/Msg/C2L/League/DissolveLeagueChatTeamQuest").new();
    msg:SetMessageId(C2L_League.DissolveLeagueChatTeamQuest);
    NetService:Instance():SendMessage(msg);
end

function UIAllianceChat:ChangeMemberTransform(callback, mvalue, value)

    
    local ltDescr = mvalue:DOLocalMove(value, MoveTime)
    if callback ~= nil then
        ltDescr:OnComplete(self,callback);
    end

end

function UIAllianceChat:ChangeChannelTransform(callback, mvalue, value)
    local ltDescr = mvalue:DOColor(value, MoveTime)
      if callback ~= nil then
        ltDescr:OnComplete(self,callback);
    end
end

function UIAllianceChat:JudeStringGetTrueCount(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat
        if self:JudeStringByte(string.sub(str, i, i)) then
            UIService:Instance():ShowUI(UIType.UICueMessageBox,504);
            return true;
        end
        lastCount = self:SubStringGetByteCount(str, i);
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(i > index);
    if curIndex > 4 then
       UIService:Instance():ShowUI(UIType.UICueMessageBox,505);
       return true;
    end
    return false;
end
--汉字单词数字
function UIAllianceChat:JudeStringByte(str)
    local curByte = string.byte(str)
    local byteCount = 1;
    if (curByte>=224 and curByte<=239) 
    or (curByte>=48 and curByte<=57) 
    or (curByte>=97 and curByte<=122)
    or (curByte>=65 and curByte<=90) then
        return false;
    end
    return true;
end

function UIAllianceChat:SubStringGetByteCount(str, index)
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

function UIAllianceChat:OnClickChannelInputField()
    

    self:RefreshAddBtn();
    
    if LeagueService:Instance():FindLeagueChatTeam(PlayerService:Instance():GetPlayerId()) == nil then
        return;
    end

    if self.channelInputField.text ~= "" and self:JudeStringGetTrueCount(self.channelInputField.text, #self.channelInputField.text) then
        self.channelInputField.text = LeagueService:Instance():GetChatTeamName();
        return;
    end
    
    if CommonService:Instance():LimitText(self.channelInputField.text) then
        self.channelInputField.text = LeagueService:Instance():GetChatTeamName();
        self:RefreshAddBtn();
        return;
    end

    if self.channelInputField.text == LeagueService:Instance():GetChatTeamName() then
        return;
    end

    if LeagueService:Instance():GetChatTeamName() ~= "" then
        CommonService:Instance():ShowOkOrCancle(
        self,function()  self:CommonNameOk() end,
        function()  end,
        "改名频道",
        "确认修改频道名称为"..self.channelInputField.text,
        "确认",
        "取消");
    end
end

function UIAllianceChat:CommonNameOk()
    local msg = require("MessageCommon/Msg/C2L/League/ChangeLeagueChatTeamName").new();
    msg:SetMessageId(C2L_League.ChangeLeagueChatTeamName);
    msg.name = self.channelInputField.text;
    NetService:Instance():SendMessage(msg);
end

return UIAllianceChat