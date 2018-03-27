-- region *.lua
-- Date 16/10/13
-- 请求加入同盟界面



local UIBase = require("Game/UI/UIBase")
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local List = require("common/List")
local UIConfigTable = require("Game/Table/model/DataUIConfig");


local LeagueAddUI = class("LeagueAddUI", UIBase);
local AddLeagueUI = require("Game/League/AddLeagueUI")

function LeagueAddUI:ctor()

    LeagueAddUI.super.ctor(self);
    self.LeagueBackBtn = nil;
    self._parentObj = nil;
    self._roundLeagueList = List:new();
    self._prefabPath = UIConfigTable[UIType.AddLeagueUI].ResourcePath;
    self.InputField = nil;
    self.ApplyBtn = nil;
    self._MembMap = { };
    self.ApplyBtnImage = nil;
    self.timeText = nil;
end


-- 注册控件
function LeagueAddUI:DoDataExchange()

    self.ApplyBtn = self:RegisterController(UnityEngine.UI.Button, "ApplyButton");
    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "XBack")
    self._parentObj = self:RegisterController(UnityEngine.Transform, "Scroll/Grid")
    self.InputField = self:RegisterController(UnityEngine.UI.InputField, "InputField");
    self.ApplyBtn = self:RegisterController(UnityEngine.UI.Button, "ApplyButton");
    self.ApplyBtnImage = self:RegisterController(UnityEngine.UI.Image, "ApplyButton");
    self.timeText = self:RegisterController(UnityEngine.UI.Text, "timeText");

end

-- 注册点击事件

function LeagueAddUI:DoEventAdd()

    self:AddListener(self.ApplyBtn, self.OnClickApplyBtn)
    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddInputFieldOnValueChanged(self.InputField, self.OnChange)
end


function LeagueAddUI:OnChange()
    if self.InputField.text == "" then
        GameResFactory.Instance():LoadMaterial(self.ApplyBtnImage, "Shader/HeroCardGray")
    else
        self.ApplyBtnImage.material = nil;
    end
end


function LeagueAddUI:OnShow(msg)
    
    -- //申请按钮置灰
    self.InputField.text = ""
    GameResFactory.Instance():LoadMaterial(self.ApplyBtnImage, "Shader/HeroCardGray")


    self._parentObj.localPosition = Vector3.zero
    local oldSize = self._parentObj.transform.childCount;

    self._roundLeagueList = msg.list;
    self._roundLeagueList = self:SetMemberList(self._roundLeagueList)

    local size = self._roundLeagueList:Count();

    for i = 1, size do

        local mAddLeagueUI = AddLeagueUI.new();
        local memberData = self._roundLeagueList:Get(i)
        print(self._roundLeagueList:Get(i).alreadApply)
        if i > oldSize then
            GameResFactory.Instance():GetUIPrefab(self._prefabPath, self._parentObj, mAddLeagueUI, function(go)
                mAddLeagueUI:Init();
                mAddLeagueUI:SetAddLeagueMessage(memberData)
                mAddLeagueUI.gameObject:SetActive(true);
                if self._MembMap[i] == nil then
                    self._MembMap[i] = mAddLeagueUI;
                end
            end
            )
        else
            local mdata = self._MembMap[i];
            if mdata ~= nil then
                mdata:Init();
                mdata:SetAddLeagueMessage(memberData)
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
    print(LeagueService:Instance():GetJoinTime())
    print(PlayerService:Instance():GetLocalTime())
    if LeagueService:Instance():GetJoinTime() - PlayerService:Instance():GetLocalTime() > 0 then
        self.timeText.gameObject:SetActive(true)
    else
        self.timeText.gameObject:SetActive(false)
    end
    -- 加入时间显示
    CommonService:Instance():TimeDown(UIType.LeagueAddUI, LeagueService:Instance():GetJoinTime(), self.timeText, function() self.timeText.gameObject:SetActive(false) end)

end


-- 点击逻辑

function LeagueAddUI:OnClickLeagueBackBtn()

    UIService:Instance():HideUI(UIType.LeagueAddUI)
    UIService:Instance():ShowUI(UIType.LeagueDisExistUI)

end


function LeagueAddUI:OnClickApplyBtn()

    if self.InputField.text == "" then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LeagueMarkWriteFalseInfo)
        return
    end
    LeagueService:Instance():ImmediateApply(PlayerService:Instance():GetPlayerId(), self.InputField.text);

end

function LeagueAddUI:SetMemberList(list)

    local inlist = List.new();
    local outList = List.new();
    local Alllsit = List.new();
    for i = 1, list:Count() do
        if list:Get(i).alreadApply then
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


return LeagueAddUI
-- endregion
