-- region *.lua
-- Date16/10/13


local UIBase = require("Game/UI/UIBase")

local LeagueExistUI = class("LeagueExistUI", UIBase)

require("Game/Table/model/DataAlliesLevel")
require("Game/League/LeagueTitleType")
require("Game/Table/model/DataState")

function LeagueExistUI:ctor()

    LeagueExistUI.super.ctor(self);
    self.LeagueBackBtn = nil;
    self.startBtn = nil;
    self.LeagueIntroBtn = nil;
    self.LeagueLeaderBtn = nil;
    self.LeagueLeaderName = nil;
    self.LeaderId = nil;

    self.Red = nil;
    self.leagueId = nil;

    self.applyNum = nil;
    self.notice = nil;
    self.noNotice = nil;
    self.donateBtn = nil;
    self.SLbutton = nil;
    self.WJbutton = nil;

    -- 同盟加成
    self.WoodAdd = nil;
    self.RockAdd = nil;
    self.FoodAdd = nil;
    self.IronAdd = nil;

    -- 城池加成
    self.LeagueAddMeun = nil;
    self.leaguefalled = nil;
    self.cityAdd = nil;
    self.leagueExpSlider = nil;

    --红dian
    self.redNotice = nil;
    self.leagueForeignRed = nil;
end


function LeagueExistUI:DoDataExchange()

    self.leaguefalled = self:RegisterController(UnityEngine.Transform, "falled")
    self.leagueExpSlider = self:RegisterController(UnityEngine.UI.Image, "component/grade/expstrip/expstrip_Image")
    self.LeagueIntroBtn = self:RegisterController(UnityEngine.UI.Button, "component/announcement/NoticeButton")
    self.startBtn = self:RegisterController(UnityEngine.UI.Button, "component/Button/Button")
    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "background/Back")
    self.LeagueLeaderBtn = self:RegisterController(UnityEngine.UI.Button, "component/name/Text1/LeagueLeader")
    self.LeagueName = self:RegisterController(UnityEngine.UI.Text, "component/name/Text")
    self.LeagueLeaderName = self:RegisterController(UnityEngine.UI.Text, "component/name/Text1")
    self.LeagueLevel = self:RegisterController(UnityEngine.UI.Text, "component/grade/LeagueLevel")
    self.LeagueExe = self:RegisterController(UnityEngine.UI.Text, "component/grade/exe_Text")
    self.LeagueMemberNum = self:RegisterController(UnityEngine.UI.Text, "component/grade/member_Text")
    self.LeagueCityNum = self:RegisterController(UnityEngine.UI.Text, "component/grade/city_Text")
    self.LeagueState = self:RegisterController(UnityEngine.UI.Text, "component/grade/state_Text")
    self.LeaguePower = self:RegisterController(UnityEngine.UI.Text, "component/grade/influence_Text")
    self.Red = self:RegisterController(UnityEngine.UI.Image, "component/Button/Button/Red")
    self.donateBtn = self:RegisterController(UnityEngine.UI.Image, "component/grade/donate_Button")
    self.notice = self:RegisterController(UnityEngine.UI.Text, "component/announcement/Text")
    self.noNotice = self:RegisterController(UnityEngine.UI.Text, "component/announcement/Noatt")
    self.SLbutton = self:RegisterController(UnityEngine.UI.Button, "component/Button/SLbutton")
    self.WJbutton = self:RegisterController(UnityEngine.UI.Button, "component/Button/WJbutton")
    self.reportbutton = self:RegisterController(UnityEngine.UI.Button, "component/Button/reportbutton")
    -- 同盟加成
    self.WoodAdd = self:RegisterController(UnityEngine.UI.Text, "component/mark-up/Image/TimberText")
    self.RockAdd = self:RegisterController(UnityEngine.UI.Text, "component/mark-up/Image/StoneText")
    self.FoodAdd = self:RegisterController(UnityEngine.UI.Text, "component/mark-up/Image/GrainText")
    self.IronAdd = self:RegisterController(UnityEngine.UI.Text, "component/mark-up/Image/IronText")
    self.cityAdd = self:RegisterController(UnityEngine.Transform, "component/mark-up/CityImage")
    self.wood = self:RegisterController(UnityEngine.UI.Text, "component/mark-up/CityImage/CityAdd/wood")
    self.metal = self:RegisterController(UnityEngine.UI.Text, "component/mark-up/CityImage/CityAdd/metal")
    self.food = self:RegisterController(UnityEngine.UI.Text, "component/mark-up/CityImage/CityAdd/food")
    self.rock = self:RegisterController(UnityEngine.UI.Text, "component/mark-up/CityImage/CityAdd/rock")
    self.memberBtnImage = self:RegisterController(UnityEngine.UI.Image, "component/Button/Button/Image")
    self.SlBtnImage = self:RegisterController(UnityEngine.UI.Image, "component/Button/SLbutton/Image")
    self.WJBtnImage = self:RegisterController(UnityEngine.UI.Image, "component/Button/WJbutton/Image")


    self.leagueForeignRed = self:RegisterController(UnityEngine.UI.Image, "component/Button/WJbutton/RedFor")
    self.redNotice =  self:RegisterController(UnityEngine.UI.Image, "component/announcement/redNotice")


end


function LeagueExistUI:DoEventAdd()

    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddListener(self.LeagueIntroBtn, self.OnClickLeagueIntroBtn)
    self:AddListener(self.LeagueLeaderBtn, self.OnClickLeagueLeaderBtn)
    self:AddListener(self.donateBtn, self.OnClickdonateBtn)
    self:AddListener(self.SLbutton, self.OnClickSLbutton)
    self:AddListener(self.startBtn, self.OnClickStartBtn)
    self:AddListener(self.WJbutton, self.OnClickWJbutton)
    self:AddListener(self.reportbutton, self.OnClickreportbutton)
    self:AddOnDown(self.startBtn, self.OnClickDownstartBtn)
    self:AddOnUp(self.startBtn, self.OnClickUpstartBtn)
    self:AddOnDown(self.SLbutton, self.OnClickDownSLbutton)
    self:AddOnUp(self.SLbutton, self.OnClickUpSLbutton)
    self:AddOnDown(self.WJbutton, self.OnClickDownWJbutton)
    self:AddOnUp(self.WJbutton, self.OnClickUpWJbutton)
end

-- 成员按钮的亮片
function LeagueExistUI:OnClickDownstartBtn()
    self.memberBtnImage.gameObject:SetActive(true)
end
function LeagueExistUI:OnClickUpstartBtn()
    self.memberBtnImage.gameObject:SetActive(false)
end
-- 势力按钮的亮片
function LeagueExistUI:OnClickDownSLbutton()
    self.SlBtnImage.gameObject:SetActive(true)
end
function LeagueExistUI:OnClickUpSLbutton()
    self.SlBtnImage.gameObject:SetActive(false)
end

-- 外交按钮的亮片
function LeagueExistUI:OnClickDownWJbutton()
    self.WJBtnImage.gameObject:SetActive(true)
end
function LeagueExistUI:OnClickUpWJbutton()
    self.WJBtnImage.gameObject:SetActive(false)
end



function LeagueExistUI:OnShow()

    -- print("REShow")
    self:ReShow()

end

function LeagueExistUI:ReShow()


    if PlayerService:Instance():GetsuperiorLeagueId() == 0 then
        self.leaguefalled.gameObject:SetActive(false)
    else
        self.leaguefalled.gameObject:SetActive(true)
    end

    local league = LeagueService:Instance():GetMyLeagueInfo();
    self.LeagueExe.text = league.exp - DataAlliesLevel[league.level].SumExp + DataAlliesLevel[league.level].UpgradeXP .. "/" .. DataAlliesLevel[league.level].UpgradeXP;
    self.LeagueName.text = league.leagueName;
    self.LeagueLeaderName.text = league.leaderName;
    self.LeagueLevel.text = "Lv." .. league.level;
    self.LeagueMemberNum.text = league.memberNum .. "/" .. DataAlliesLevel[league.level].MemberLimit;
    self.LeagueCityNum.text = league.cityNum;
    if DataState[league.province] ~= nil then
        self.LeagueState.text = DataState[league.province].Name;
    end
    self.LeaguePower.text = league.influnce;
    self.LeaderId = league.leaderid;
    self.leagueId = league.leagueid;
    self.applyNum = league.applyNum;
    self.notice.text = league.notice

    if league.notice == "" then
        self.noNotice.gameObject:SetActive(true)
    else
        self.noNotice.gameObject:SetActive(false)
    end

    if LeagueService:Instance():GetForeignBool() then
        self.leagueForeignRed.gameObject:SetActive(true)
        else
        self.leagueForeignRed.gameObject:SetActive(false)
    end


    if GameResFactory.Instance():GetString("LeagueNotice")~= league.notice then
        self.redNotice.gameObject:SetActive(true)
        GameResFactory.Instance():SetString("LeagueNotice", league.notice)
        else
        self.redNotice.gameObject:SetActive(false)
    end




    self.leagueExpSlider.fillAmount =(league.exp - DataAlliesLevel[league.level].SumExp + DataAlliesLevel[league.level].UpgradeXP) / DataAlliesLevel[league.level].UpgradeXP;


    if self.applyNum ~= 0 and PlayerService:Instance():GetPlayerTitle() < LeagueTitleType.Command then
        self.Red.gameObject:SetActive(true);
    else
        self.Red.gameObject:SetActive(false);
    end

    LeagueService:Instance():SetApplyNum(self.applyNum)
    self.WoodAdd.text = "+" .. DataAlliesLevel[league.level].WoodModifier / 100 .. "%"
    self.RockAdd.text = "+" .. DataAlliesLevel[league.level].StoneModifier / 100 .. "%"
    self.FoodAdd.text = "+" .. DataAlliesLevel[league.level].FoodModifier / 100 .. "%"
    self.IronAdd.text = "+" .. DataAlliesLevel[league.level].IronModifier / 100 .. "%"
    self:GetSource();
end


function LeagueExistUI:GetSource()
    local league = LeagueService:Instance():GetMyLeagueInfo();
    local wood = league.cityWoodAdd
    local food = league.cityGrainAdd
    local metal = league.cityIronAdd
    local rock = league.cityStoneAdd
    self.wood.text = "+" .. wood
    self.rock.text = "+" .. rock
    self.food.text = "+" .. food
    self.metal.text = "+" .. metal
    if wood == 0 then
        self.wood.gameObject:SetActive(false)
    else
        self.wood.gameObject:SetActive(true)
    end
    if rock == 0 then
        self.rock.gameObject:SetActive(false)
    else
        self.rock.gameObject:SetActive(true)
    end
    if food == 0 then
        self.food.gameObject:SetActive(false)
    else
        self.food.gameObject:SetActive(true)
    end
    if metal == 0 then
        self.metal.gameObject:SetActive(false)
    else
        self.metal.gameObject:SetActive(true)
    end
    if wood == 0 and rock == 0 and food == 0 and metal == 0 then
        self.cityAdd.gameObject:SetActive(false)
    else
        self.cityAdd.gameObject:SetActive(true)
    end
end


function LeagueExistUI:OnClickStartBtn()

    LeagueService:Instance():SendLeagueMemberMessage(PlayerService:Instance():GetPlayerId())

end

function LeagueExistUI:OnClickreportbutton()
    local bassClass = UIService:Instance():GetUIClass(UIType.UIGameMainView)
    bassClass:OnClickBattleRePortBtn()
end



function LeagueExistUI:OnClickLeagueBackBtn()

    UIService:Instance():ShowUI(UIType.UIGameMainView)
    UIService:Instance():HideUI(UIType.LeagueExistUI)

end


function LeagueExistUI:OnClickLeagueIntroBtn()
    if PlayerService:Instance():GetPlayerTitle() > LeagueTitleType.Command then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HaveNoPower)
        return
    end
    UIService:Instance():ShowUI(UIType.LeagueIntroUI)

end


function LeagueExistUI:OnClickLeagueLeaderBtn()

    if self.LeaderId == PlayerService:Instance():GetPlayerId() then
        UIService:Instance():ShowUI(UIType.UIPersonalPower);
    else
        local msg = require("MessageCommon/Msg/C2L/Player/RequestOtherPlayerBaseInfo").new();
        msg:SetMessageId(C2L_Player.RequestOtherPlayerBaseInfo);
        msg.playerId = self.LeaderId;
        NetService:Instance():SendMessage(msg);
    end

end


function LeagueExistUI:OnClickdonateBtn()
    if tonumber(self.LeaguePower.text) >= 800 then
        UIService:Instance():ShowUI(UIType.LeagueDonate)
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LeagueInfluenceNotEnough)
    end


end

function LeagueExistUI:OnClickSLbutton()

    LeagueService:Instance():SendOpenWildBDingMessage()

end

function LeagueExistUI:OnClickWJbutton()
    UIService:Instance():ShowUI(UIType.LeagueForigen)
    LeagueService:Instance():SetForeignBool(false)
    self.leagueForeignRed.gameObject:SetActive(false)
end


return LeagueExistUI



-- endregion
