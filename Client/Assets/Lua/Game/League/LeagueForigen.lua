-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local LeagueForigen = class("LeagueForigen", UIBase)
local List = require("common/list");
local relationLeague = require("Game/League/relationLeague");
require("Game/Table/model/DataUIConfig")
require("Game/League/RelationShipType")

function LeagueForigen:ctor()

    LeagueForigen.super.ctor(self)
    self._parentObj = nil;
    self.backBtn = nil;
    self.introBtn = nil;
    self.foreignTable = { }
    self.foreignList = List:new()
    self.IntroUI = nil;
    self.confirmBtn = nil;
    self._perfabPath = DataUIConfig[UIType.relationLeague].ResourcePath;
    self.leadObj = nil;
    self.setText = nil;
    self.noFriendText = nil;
    self.SreachBtnImage = nil;
end


function LeagueForigen:DoDataExchange()

    self.setText = self:RegisterController(UnityEngine.Transform, "Scroll View/Viewport/Content/HeadlineObj/Text6")
    self.leadObj = self:RegisterController(UnityEngine.Transform, "Scroll View/Viewport/Content/importOBJ")
    self._parentObj = self:RegisterController(UnityEngine.Transform, "Scrollw/Viewport/Content")
    self.backBtn = self:RegisterController(UnityEngine.UI.Button, "back")
    self.introBtn = self:RegisterController(UnityEngine.UI.Button, "intro")
    self.confirmBtn = self:RegisterController(UnityEngine.UI.Button, "IntroUI/Confirm")
    self.IntroUI = self:RegisterController(UnityEngine.Transform, "IntroUI")
    self.SreachBtn = self:RegisterController(UnityEngine.UI.Button, "Scroll View/Viewport/Content/importOBJ/Button")
    self.NameInput = self:RegisterController(UnityEngine.UI.InputField, "Scroll View/Viewport/Content/importOBJ/InputField")
    self.noFriendText = self:RegisterController(UnityEngine.Transform, "NoFriendText");
    self.SreachBtnImage = self:RegisterController(UnityEngine.UI.Image, "Scroll View/Viewport/Content/importOBJ/Button")
end

function LeagueForigen:DoEventAdd()

    self:AddListener(self.backBtn.gameObject, self.OnClickbackBtn);
    self:AddListener(self.introBtn.gameObject, self.OnClickintroBtn);
    self:AddListener(self.confirmBtn.gameObject, self.OnClickconfirmBtn);
    self:AddListener(self.SreachBtn.gameObject, self.OnClickcSreachBtn);
    self:AddInputFieldOnValueChanged(self.NameInput, self.OnChange)

end

function LeagueForigen:OnShow()

    self:ReShow()

end

function LeagueForigen:OnChange()
    if self.NameInput.text == "" then
        GameResFactory.Instance():LoadMaterial(self.SreachBtnImage, "Shader/HeroCardGray")
    else
        self.SreachBtnImage.material = nil;
    end
end

function LeagueForigen:ReShow()
    self.NameInput.text = "";
    GameResFactory.Instance():LoadMaterial(self.SreachBtnImage, "Shader/HeroCardGray")
    if PlayerService:Instance():GetPlayerTitle() < LeagueTitleType.Command then
        self.leadObj.gameObject:SetActive(true)
        self.setText.gameObject:SetActive(true)
        self._parentObj.localPosition = Vector3.New(180, 287, 0)
    else
        self.leadObj.gameObject:SetActive(false)
        self.setText.gameObject:SetActive(false)
        self._parentObj.localPosition = Vector3.New(180, 233, 0)
    end

    self.IntroUI.gameObject:SetActive(false)
    self._parentObj.transform.localPosition = Vector3.New(Vector3.zero)
    self.foreignList = LeagueService:Instance():GetLeagueForeignAll()
    for k, v in pairs(self.foreignList._list) do
        if v.leagueId == LeagueService:Instance():GetMyLeagueInfo().leagueid then
            self.foreignList:Remove(v)
        end
    end
    local sizeFriend = self.foreignList:Count();
    local num = GameResFactory.Instance():GetInt("forgionNum")
    GameResFactory.Instance():SetInt("forgionNum", sizeFriend)
    if sizeFriend == 0 then
        self.noFriendText.gameObject:SetActive(true)
    else
        self.noFriendText.gameObject:SetActive(false)
    end
    local isfriend = true;
    for k, v in pairs(self.foreignTable) do
        if (v.gameObject.activeSelf == true) then
            v.gameObject:SetActive(false);
        end
    end

    for index = 1, sizeFriend do
        -- print(index)
        local relationIndex = self.foreignList:Get(index);
        local mrelationLeague = self.foreignTable[index];
        if mrelationLeague == nil then
            GetFromUnVisable = false;
            mrelationLeague = relationLeague.new();
            GameResFactory.Instance():GetUIPrefab(self._perfabPath, self._parentObj, mrelationLeague, function(go)
                mrelationLeague:Init();
                if relationIndex.mType == RelationShipType.Firend then
                    isfriend = true;
                elseif relationIndex.mType == RelationShipType.Enemy then
                    isfriend = false;
                end
                mrelationLeague:SetMessage(relationIndex, isfriend)
                self.foreignTable[index] = mrelationLeague
                if index > num then
                    mrelationLeague:SetRedImage(true)
                else
                    mrelationLeague:SetRedImage(false)
                end
            end );
        else
            self.foreignTable[index].gameObject:SetActive(true);
            if relationIndex.mType == RelationShipType.Firend then
                isfriend = true;
            elseif relationIndex.mType == RelationShipType.Enemy then
                isfriend = false;
            end
            mrelationLeague:SetMessage(relationIndex, isfriend)
            if index > num then
                mrelationLeague:SetRedImage(true)
            else
                mrelationLeague:SetRedImage(false)
            end
        end
    end
end


function LeagueForigen:OnClickbackBtn()

    UIService:Instance():HideUI(UIType.LeagueForigen)

end

function LeagueForigen:OnClickintroBtn()

    self.IntroUI.gameObject:SetActive(true)

end

function LeagueForigen:OnClickconfirmBtn()

    self.IntroUI.gameObject:SetActive(false)

end


function LeagueForigen:OnClickcSreachBtn()

    -- 发消息  打开同盟名称
    if self.NameInput.text ~= "" then
        LeagueService:Instance():SendOpenImmLeague(self.NameInput.text)
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.PleaseInPutName)
    end

end


return LeagueForigen


-- endregion
