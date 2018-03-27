-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase")
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local List = require("common/List")
local LeagueRequireInUI = class("LeagueRequireInUI", UIBase)
local UIConfigTable = require("Game/Table/model/DataUIConfig");
local RequireMemberUI = require("Game/League/RequireMemberUI")
function LeagueRequireInUI:ctor()

    LeagueRequireInUI.super.ctor(self);
    self.closeBtn = nil;
    self.LeagueBackBtn = nil
    self._parentObj = nil;
    self._prefabPath = UIConfigTable[UIType.RequireMemberUI].ResourcePath;
    self._applyJoinLeaguelList = List.new()
    self._MembMap = { };
    self.NoRequire = nil;
end


function LeagueRequireInUI:DoDataExchange()
    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self._parentObj = self:RegisterController(UnityEngine.Transform, "Scroll View/Grid")
    self.closeBtn = self:RegisterController(UnityEngine.UI.Button, "Close");
    self.NoRequire = self:RegisterController(UnityEngine.Transform, "NoRequire");
end


function LeagueRequireInUI:DoEventAdd()

    self:AddListener(self.closeBtn, self.OnClickcloseBtn)
    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddListener(self.closeBtn, self.OnClickcloseBtn)
end



function LeagueRequireInUI:OnShow(msg)

    local oldSize = self._parentObj.transform.childCount;
    self._applyJoinLeaguelList = msg.list;
    if self._applyJoinLeaguelList == nil then
        return
    end
    local size = self._applyJoinLeaguelList:Count();
    if size == 0 then
        self.NoRequire.gameObject:SetActive(true)
    else
        self.NoRequire.gameObject:SetActive(false)
    end
    for i = 1, size do
        local mRequireMemberUI = RequireMemberUI.new();
        local memberData = self._applyJoinLeaguelList:Get(i)

        if i > oldSize then
            GameResFactory.Instance():GetUIPrefab(self._prefabPath, self._parentObj, mRequireMemberUI, function(go)
                mRequireMemberUI:Init();
                mRequireMemberUI:SetRequireMemberMessage(memberData)
                mRequireMemberUI.gameObject:SetActive(true);
                if self._MembMap[i] == nil then
                    self._MembMap[i] = mRequireMemberUI;
                end
            end
            )
        else
            local mdata = self._MembMap[i];
            if mdata ~= nil then
                mdata:Init();
                mdata:SetRequireMemberMessage(memberData)
                mdata.gameObject:SetActive(true);
            end

        end
    end


    for i = 1, oldSize do


        if size < i then
            local child = self._parentObj.transform:GetChild(i - 1);
            child.gameObject:SetActive(false);
        end



    end





end


function LeagueRequireInUI:OnClickLeagueBackBtn()

    UIService:Instance():HideUI(UIType.LeagueRequireInUI)


end


function LeagueRequireInUI:OnClickcloseBtn()

    -- print("close Apply UIlist+!+++++++++++++++++++++++++++++")
    LeagueService:Instance():SendShutMsg(PlayerService:Instance():GetPlayerId(), true)

end


return LeagueRequireInUI
-- endregion

