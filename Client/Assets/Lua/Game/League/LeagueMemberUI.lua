-- region *.lua
-- Date16/10/13
-- 同盟成员界面
--------------------------------------------------------------------------
local UIBase = require("Game/UI/UIBase")
local LeagueMemberUI = class("LeagueMemberUI", UIBase)
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
local List = require("common/List")
local UIConfigTable = require("Game/Table/model/DataUIConfig");
local MemberLeagueUI = require("Game/League/MemberLeagueUI")
local underMemberLeagueUI = require("Game/League/underMemberLeagueUI")


function LeagueMemberUI:ctor()

    LeagueMemberUI.super.ctor(self);
    self.LeagueBackBtn = nil;
    self._parentObj = nil;
    self._memberList = List.new()
    self._prefabPath = UIConfigTable[UIType.MemberLeagueUI].ResourcePath;
    self.Xs_prefabPath = UIConfigTable[UIType.underMemberLeagueUI].ResourcePath;

    self._leagueAddBtn = nil;
    self.RequireInBtn = nil;
    self._MembMap = { };
    self.Xs_MembMap = { };

    self.Red = nil;
    self.myInfoBtn = nil;

    self.memberBtn = nil;
    self.memberXsBtn = nil;
    self.Scorll = nil;
    self.Scorll1 = nil;
    self.Image1 = nil;
    self.Image2 = nil;
    self.NoUnderMemberText = nil;
    self.Xs_parentObj = nil;

    self.memberdefult = nil
    self.memberdefultext = nil;

    self.memberType = nil
    self.memberType1 = nil
    self.memberType2 = nil
    self.memberType3 = nil
    self.memberType4 = nil
    self.IntroContent = nil;
    self.comfirm = nil;
end


-- 注册控件
function LeagueMemberUI:DoDataExchange()

    self.Xs_parentObj = self:RegisterController(UnityEngine.Transform, "BackGound/ScrollXs/Gird")
    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self._parentObj = self:RegisterController(UnityEngine.Transform, "BackGound/Scroll/Gird")
    self._leagueAddBtn = self:RegisterController(UnityEngine.UI.Button, "BackGound/TwoBottomImage/LeagueMemberAdd");
    self.RequireInBtn = self:RegisterController(UnityEngine.UI.Button, "BackGound/TwoBottomImage/RequireInBtn");
    self.Red = self:RegisterController(UnityEngine.UI.Image, "BackGound/TwoBottomImage/RequireInBtn/Red");
    self.myInfoBtn = self:RegisterController(UnityEngine.UI.Button, "BackGound/TwoBottomImage/MyLeagueInfo");

    self.memberBtn = self:RegisterController(UnityEngine.UI.Button, "BackGound/TwoBottomImage/memberButton");
    self.memberXsBtn = self:RegisterController(UnityEngine.UI.Button, "BackGound/TwoBottomImage/XS");
    self.Scorll = self:RegisterController(UnityEngine.Transform, "BackGound/Scroll");
    self.Scorll1 = self:RegisterController(UnityEngine.Transform, "BackGound/ScrollXs");
    self.Image1 = self:RegisterController(UnityEngine.Transform, "BackGound/Image1");
    self.Image2 = self:RegisterController(UnityEngine.Transform, "BackGound/Image2");
    self.Intro = self:RegisterController(UnityEngine.UI.Button, "BackGound/Intro");

    self.memberdefult = self:RegisterController(UnityEngine.UI.Button, "BackGound/TwoBottomImage/Allance");
    self.memberdefultext = self:RegisterController(UnityEngine.UI.Text, "BackGound/TwoBottomImage/Allance/Text");
    self.NoUnderMemberText = self:RegisterController(UnityEngine.UI.Text, "BackGound/ScrollXs/NoUnderMemberText");
    self.memberType = self:RegisterController(UnityEngine.Transform, "BackGound/TwoBottomImage/type");
    self.typeBack = self:RegisterController(UnityEngine.UI.Button, "BackGound/TwoBottomImage/type/Image");
    self.memberType1 = self:RegisterController(UnityEngine.UI.Button, "BackGound/TwoBottomImage/type/type1");
    self.memberType2 = self:RegisterController(UnityEngine.UI.Button, "BackGound/TwoBottomImage/type/type2");
    self.memberType3 = self:RegisterController(UnityEngine.UI.Button, "BackGound/TwoBottomImage/type/type3");
    self.memberType4 = self:RegisterController(UnityEngine.UI.Button, "BackGound/TwoBottomImage/type/type4");
    self.IntroContent = self:RegisterController(UnityEngine.Transform, "IntroContent");
    self.comfirm = self:RegisterController(UnityEngine.UI.Button, "IntroContent/comfirm");
end

-- 注册点击事件
function LeagueMemberUI:DoEventAdd()
    self:AddListener(self.myInfoBtn, self.OnClickmyInfoBtn)
    self:AddListener(self.RequireInBtn, self.OnClickRequireInBtn)
    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddListener(self._leagueAddBtn, self.OnClick_leagueAddBtn)
    self:AddListener(self.memberBtn, self.OnClickmemberBtn)
    self:AddListener(self.memberXsBtn, self.OnClickmemberXsBtn)
    self:AddListener(self.Intro, self.OnClickIntroBtn)
    self:AddListener(self.memberdefult, self.OnClickmemberdefult)
    self:AddListener(self.memberType1, self.OnClickmemberType1)
    self:AddListener(self.memberType2, self.OnClickmemberType2)
    self:AddListener(self.memberType3, self.OnClickmemberType3)
    self:AddListener(self.memberType4, self.OnClickmemberType4)
    self:AddListener(self.typeBack, self.OnClicktypeBack)
    self:AddListener(self.comfirm, self.OnClickcomfirm)
end

function LeagueMemberUI:OnClickIntroBtn()
    self.IntroContent.gameObject:SetActive(true)
end

function LeagueMemberUI:OnClickcomfirm()
    self.IntroContent.gameObject:SetActive(false)
end
-- 点击按钮逻辑

function LeagueMemberUI:OnClickmemberdefult()
    if self.memberType.gameObject.activeInHierarchy then
        self.memberType.gameObject:SetActive(false)
    else
        self.memberType.gameObject:SetActive(true)
    end
end

function LeagueMemberUI:OnClicktypeBack()
    self.memberType.gameObject:SetActive(false)
end

function LeagueMemberUI:OnClickmemberType1()
    self.memberdefultext.text = "默认"
    self.memberType.gameObject:SetActive(false)

end
function LeagueMemberUI:OnClickmemberType2()
    self.memberdefultext.text = "贡献"
    self.memberType.gameObject:SetActive(false)
end
function LeagueMemberUI:OnClickmemberType3()
    self.memberdefultext.text = "势力值"
    self.memberType.gameObject:SetActive(false)
end
function LeagueMemberUI:OnClickmemberType4()
    self.memberdefultext.text = "武勋"
    self.memberType.gameObject:SetActive(false)
end

function LeagueMemberUI:OnClickLeagueBackBtn()
    UIService:Instance():HideUI(UIType.LeagueMemberUI)
end


function LeagueMemberUI:OnClickRequireInBtn()
    LeagueService:Instance():SendOpenApplyList(PlayerService:Instance():GetPlayerId())
end



function LeagueMemberUI:OnShow()
    self.memberdefultext.text = "默认"
    self.memberType.gameObject:SetActive(false)

    if LeagueService:Instance():GetApplyNum() == 0 then
        self.Red.gameObject:SetActive(false)
    else
        self.Red.gameObject:SetActive(true)
    end

    if PlayerService:Instance():GetPlayerTitle() < LeagueTitleType.Command then
        self.RequireInBtn.gameObject:SetActive(true)
        self._leagueAddBtn.gameObject:SetActive(true)
    else
        self.RequireInBtn.gameObject:SetActive(false)
        self._leagueAddBtn.gameObject:SetActive(false)
    end

    local oldSize = self._parentObj.transform.childCount;
    self._memberList = LeagueService:Instance():GetLeagueMemberList();

    local size = self._memberList:Count();
    for i = 1, size do

        local mMemberLeagueUI = MemberLeagueUI.new();
        local memberData = self._memberList:Get(i)

        if i > oldSize then
            GameResFactory.Instance():GetUIPrefab(self._prefabPath, self._parentObj, mMemberLeagueUI, function(go)
                mMemberLeagueUI:Init();
                mMemberLeagueUI:SetMemberLeagueMessage(memberData)
                mMemberLeagueUI.gameObject:SetActive(true);
                if self._MembMap[i] == nil then
                    self._MembMap[i] = mMemberLeagueUI;
                end
            end
            )
        else
            local mdata = self._MembMap[i];
            if mdata ~= nil then
                mdata:Init();
                mdata:SetMemberLeagueMessage(memberData)
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
    self:LightmyInfoBtn()
    -- 刷新时隐藏同盟中我的信息的提示边框
    -- 点击一下成员按钮
    self:OnClickmemberBtn()
end


function LeagueMemberUI:LightmyInfoBtn()
    for k, v in pairs(self._MembMap) do
        if v.playerid == PlayerService:Instance():GetPlayerId() then
            v.gameObject.transform:GetChild(0).gameObject:SetActive(true)
        end
    end
end

function LeagueMemberUI:OnClickmyInfoBtn()
    for k, v in pairs(self._MembMap) do
        if v.playerid == PlayerService:Instance():GetPlayerId() then
            self._parentObj.localPosition = Vector3.New(v.gameObject.transform.localPosition)
        end
    end
end



function LeagueMemberUI:OnClick_leagueAddBtn()
    LeagueService:Instance():SendRoundPlayerMsg(PlayerService:Instance():GetPlayerId());
end


function LeagueMemberUI:OnClickmemberBtn()
    self.memberdefult.gameObject:SetActive(true)
    self.myInfoBtn.gameObject:SetActive(true)
    self.Scorll.gameObject:SetActive(true)
    self.Intro.gameObject:SetActive(true)
    if PlayerService:Instance():GetPlayerTitle() < LeagueTitleType.Command then
        self.RequireInBtn.gameObject:SetActive(true)
        self._leagueAddBtn.gameObject:SetActive(true)
    end
    self.memberBtn.transform:GetChild(1).gameObject:SetActive(true)
    self.memberXsBtn.transform:GetChild(1).gameObject:SetActive(false)
    self.Image1.gameObject:SetActive(true)
    self.Scorll1.gameObject:SetActive(false)
    self.Image2.gameObject:SetActive(false)
end



function LeagueMemberUI:OnClickmemberXsBtn(args)
    self.myInfoBtn.gameObject:SetActive(false)
    self.memberType.gameObject:SetActive(false)
    self.memberBtn.transform:GetChild(1).gameObject:SetActive(false)
    self.memberXsBtn.transform:GetChild(1).gameObject:SetActive(true)
    self.memberdefult.gameObject:SetActive(false)
    self.Intro.gameObject:SetActive(false)
    self.RequireInBtn.gameObject:SetActive(false)
    self._leagueAddBtn.gameObject:SetActive(false)
    LeagueService:Instance():SendUnderMemberMessage()

end

function LeagueMemberUI:SetUnderMemberInfo()

    self.Scorll.gameObject:SetActive(false)
    self.Image1.gameObject:SetActive(false)
    self.Scorll1.gameObject:SetActive(true)
    self.Image2.gameObject:SetActive(true)

    local oldSize = self.Xs_parentObj.transform.childCount;
    local list = LeagueService:Instance():GetUnderMemberList()

    local size = list:Count();
    if size == 0 then
        self.Image2.gameObject:SetActive(false)
        self.NoUnderMemberText.gameObject:SetActive(true)
    else
        self.NoUnderMemberText.gameObject:SetActive(false)
        self.Image2.gameObject:SetActive(true)
    end
    for i = 1, size do
        local munderMemberLeagueUI = underMemberLeagueUI.new();
        local memberData = list:Get(i)

        if i > oldSize then
            GameResFactory.Instance():GetUIPrefab(self.Xs_prefabPath, self.Xs_parentObj, munderMemberLeagueUI, function(go)
                munderMemberLeagueUI:Init();
                munderMemberLeagueUI:SetMemberLeagueMessage(memberData)
                munderMemberLeagueUI.gameObject:SetActive(true);
                if self.Xs_MembMap[i] == nil then
                    self.Xs_MembMap[i] = munderMemberLeagueUI;
                end
            end
            )
        else
            local mdata = self.Xs_MembMap[i];
            if mdata ~= nil then
                mdata:Init();
                mdata:SetMemberLeagueMessage(memberData)
                mdata.gameObject:SetActive(true);
            end

        end
    end

    for i = 1, oldSize do
        if size < i then
            local child = self.Xs_parentObj.transform:GetChild(i - 1);
            child.gameObject:SetActive(false);
        end
    end



end


return LeagueMemberUI
-- endregion
