-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase")
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local List = require("common/List")
local LeagueMemberAddUI = class("LeagueMemberAddUI", UIBase)
local UIConfigTable = require("Game/Table/model/DataUIConfig");
local AddMemberUI = require("Game/League/AddMemberUI")
function LeagueMemberAddUI:ctor()

    LeagueMemberAddUI.super.ctor(self);
    self.InviteBtn = nil;
    self.LeagueBackBtn = nil;
    self.InputField = nil;
    self._parentObj = nil;
    self._prefabPath = UIConfigTable[UIType.AddMemberUI].ResourcePath;
    self.roundPlayerList = List.new()
    self._MembMap = { };
    self.InviteBtnImage = nil;
end


function LeagueMemberAddUI:DoDataExchange()

    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self._parentObj = self:RegisterController(UnityEngine.Transform, "Scroll/Gird")
    self.InputField = self:RegisterController(UnityEngine.UI.InputField, "InputField");
    self.InviteBtnImage = self:RegisterController(UnityEngine.UI.Image, "InviteBtn");
    self.InviteBtn = self:RegisterController(UnityEngine.UI.Button, "InviteBtn");

end


function LeagueMemberAddUI:DoEventAdd()

    self:AddListener(self.InviteBtn, self.OnClickInviteBtn)
    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddInputFieldOnValueChanged(self.InputField, self.OnChange)

end

function LeagueMemberAddUI:OnChange()
    if self.InputField.text == "" then
        GameResFactory.Instance():LoadMaterial(self.InviteBtnImage, "Shader/HeroCardGray")
    else
        self.InviteBtnImage.material = nil;
    end
end


function LeagueMemberAddUI:OnShow(msg)

    --//ÉêÇë°´Å¥ÖÃ»Ò
    self.InputField.text = ""
    GameResFactory.Instance():LoadMaterial(self.InviteBtnImage, "Shader/HeroCardGray")

    self._parentObj.localPosition = Vector3.New(Vector3.zero)

    local oldSize = self._parentObj.transform.childCount;
    self.roundPlayerList = self:SetMemberList(msg.list);
    local size = self.roundPlayerList:Count();
    for i = 1, size do

        local mAddMemberUI = AddMemberUI.new();
        local memberData = self.roundPlayerList:Get(i)

        if i > oldSize then
            GameResFactory.Instance():GetUIPrefab( self._prefabPath, self._parentObj, mAddMemberUI, function(go)
                mAddMemberUI:Init();
                mAddMemberUI:SetAddMemberMessage(memberData)
                mAddMemberUI.gameObject:SetActive(true);
                if self._MembMap[i] == nil then
                    self._MembMap[i] = mAddMemberUI;
                end
            end
            )
        else
            local mdata = self._MembMap[i];
            if mdata ~= nil then
                mdata:Init();
                mdata:SetAddMemberMessage(memberData)
                mdata.gameObject:SetActive(true);
            end
        end
    end


    for i = 1, oldSize do
        if size < i then
            local child = self._parentObj.transform:GetChild(i-1);
            child.gameObject:SetActive(false);
        end
    end





end


function LeagueMemberAddUI:OnClickLeagueBackBtn()

    UIService:Instance():HideUI(UIType.LeagueMemberAddUI)


end


function LeagueMemberAddUI:OnClickInviteBtn()

    LeagueService:Instance():ImmediateInvite(PlayerService:Instance():GetPlayerId(), self.InputField.text);

end


function LeagueMemberAddUI:SetMemberList(list)

    local inlist = List.new();
    local outList = List.new();
    local Alllsit = List.new();

    for i = 1, list:Count() do
        if list:Get(i).isInvented then
            inlist:Push(list:Get(i))
        else
            outList:Push(list:Get(i))
        end
    end

    for k, v in pairs(inlist._list) do

        Alllsit:Push(v)

    end

    for k, v in pairs(outList._list) do

        Alllsit:Push(v)

    end

    return Alllsit
end




return LeagueMemberAddUI
-- endregion
