-- 聊天
local UIBase = require("Game/UI/UIBase");
local List = require("common/List");
local Queue = require("common/Queue");
local UIAllianceInformation = class("UIAllianceInformation", UIBase)

function UIAllianceInformation:ctor()
    UIAllianceInformation.super.ctor(self);

    self._closeBtn = nil;
    self._quitButton = nil;
    self._content = nil;
    self._numText = nil;

    self._item = List.new();
    self._cacheItem = Queue.new();
    self._chatTream = nil;
    self._chatLeagueId = 0;
end

function UIAllianceInformation:RegisterAllNotice()
   -- 聊天
   self:RegisterNotice(C2L_League.HandleRemoveLeagueChatTeam, self.OnClickCloseBtn);
end

function UIAllianceInformation:DoDataExchange()
    self._closeBtn = self:RegisterController(UnityEngine.UI.Button, "channel/Image/CloseButton");
    self._quitButton = self:RegisterController(UnityEngine.UI.Button, "channel/Image/QuitButton");
    self._numText = self:RegisterController(UnityEngine.UI.Text, "channel/Image/PopupG/numText");
    self._content = self:RegisterController(UnityEngine.Transform, "channel/Image/Scroll View/Viewport/Content");
end

function UIAllianceInformation:DoEventAdd()
    self:AddListener(self._closeBtn, self.OnClickCloseBtn);
    self:AddListener(self._quitButton, self.OnClickQuitBtn);
end

function UIAllianceInformation:OnShow(chatLeagueId)
    self._chatLeagueId = chatLeagueId;
    self:RefreshBtn();
end

function UIAllianceInformation:OnHide()
    self._chatLeagueId = 0;
    self._chatTream = nil;
end

function UIAllianceInformation:RefreshBtn()
    self:HideBtn();
    self:ShowBtn();
end

function UIAllianceInformation:HideBtn()
    self._item:ForEach(function ( ... )
        self:_HideChannelBtn(...)
    end);

    self._item:Clear();
end

function UIAllianceInformation:_HideChannelBtn(item)
     self:_ReleaseBtnItem(item);
end

function UIAllianceInformation:_ReleaseBtnItem(cache)
    if cache == nil then
       return;
    end
    self._cacheItem:Push(cache);
    cache.gameObject:SetActive(false);
end

function UIAllianceInformation:_AllocBtnItem()
    if self._cacheItem:Count() == 0 then
        return nil;
    end
    return self._cacheItem:Pop();
end

function UIAllianceInformation:ShowBtn()
    self._chatTream = LeagueService:Instance():GetTeamList();
    local count = self._chatTream:Count();
    self._numText.text = "("..count.."/50)"
    for i = 1, count do
        local item = self:_AllocBtnItem();
        if item == nil then
            item = require("Game/Chat/UIAllocChannelItem").new();
            GameResFactory.Instance():GetUIPrefab("UIPrefab/".."AllianceChatOne", self._content, item, function (go)
            item:DoDataExchange();
            item:DoEventAdd();
            item:OnShow(self._chatTream:Get(i));
            self:_SetItem(item);
            end);
        else
           item:OnShow(self._chatTream:Get(i));
           item.transform:SetAsLastSibling();
           item.gameObject:SetActive(true);
           self:_SetItem(item);
        end
    end
end

function UIAllianceInformation:_SetItem(item)
    if item == nil then
        return;
    end
    self._item:Push(item);
end

function UIAllianceInformation:OnClickCloseBtn()
    UIService:Instance():HideUI(UIType.UIAllianceInformation);
end

function UIAllianceInformation:OnClickQuitBtn()
   CommonService:Instance():ShowOkOrCancle(
        self,function()  self:CommonOk() end,
        function()  end,
        "离开频道",
        "确认离开频道",
        "确认",
        "取消")
end

function UIAllianceInformation:CommonOk()
    local msg = require("MessageCommon/Msg/C2L/League/QuitLeagueChatTeam").new();
    msg:SetMessageId(C2L_League.QuitLeagueChatTeam);
    print(self._chatLeagueId);
    msg.chatTeamId = self._chatLeagueId;
    NetService:Instance():SendMessage(msg);
end

return UIAllianceInformation