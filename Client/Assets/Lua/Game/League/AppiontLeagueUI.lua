-- region *.lua
-- Date16/10/20
-- 打开指定同盟UI界面


local DataAlliesLevel = require("Game/Table/model/DataAlliesLevel")
local UIBase = require("Game/UI/UIBase")
local UIService = require("Game/UI/UIService")
local UIType = require("Game/UI/UIType")
require("Game/Table/model/DataState")
local AppiontLeagueUI = class("AppiontLeagueUI", UIBase);

function AppiontLeagueUI:ctor()

    AppiontLeagueUI.super.ctor(self);

    self.LeagueBackBtn = nil;
    self.JoinBtn = nil;
    self.Name = nil;
    self.LeagueId = nil;
    self.LeaderId = nil;
    self.LeaderName = nil;
    self.Level = nil;
    self.Exp = nil;
    self.MemberNum = nil;
    self.Province = nil;
    self.CityNum = nil;
    self.Influence = nil;
    self.Notice = nil;
    self.leagueRelation = nil;
    self.nextDiplomacyTime = 0;
    self.relationPic = nil;
    self.relationship = nil;
    self.supuriorText = nil;
    self.WoodAdd = nil
    self.RockAdd = nil
    self.FoodAdd = nil
    self.slider = nil;
    self.IronAdd = nil
    self.wood = nil
    self.metal = nil
    self.joinImage = nil;
    self.food = nil
    self.isHaveApplied = nil;
    self.ApplyText = nil;
    self.rock = nil
end


-- 注册控件
function AppiontLeagueUI:DoDataExchange()

    self.LeagueBackBtn = self:RegisterController(UnityEngine.UI.Button, "Back")
    self.JoinBtn = self:RegisterController(UnityEngine.UI.Button, "Join")
    self.joinImage = self:RegisterController(UnityEngine.UI.Image, "Join/Image")
    self.Name = self:RegisterController(UnityEngine.UI.Text, "Text")
    self.LeaderName = self:RegisterController(UnityEngine.UI.Text, "Text1")
    self.LeaderNameBtn = self:RegisterController(UnityEngine.UI.Button, "Text1")
    self.ApplyText = self:RegisterController(UnityEngine.UI.Text, "Join/Text")
    self.Level = self:RegisterController(UnityEngine.UI.Text, "Text2")
    self.Exp = self:RegisterController(UnityEngine.UI.Text, "Text3")
    self.MemberNum = self:RegisterController(UnityEngine.UI.Text, "Text4")
    self.Province = self:RegisterController(UnityEngine.UI.Text, "Text5")
    self.CityNum = self:RegisterController(UnityEngine.UI.Text, "Text6")
    self.Influence = self:RegisterController(UnityEngine.UI.Text, "Text7")
    self.Notice = self:RegisterController(UnityEngine.UI.Text, "Text8")
    self.leagueRelation = self:RegisterController(UnityEngine.UI.Button, "leagueRelation/SetButton")
    self.relationPic = self:RegisterController(UnityEngine.Transform, "leagueRelation/relationPic")
    self.supuriorText = self:RegisterController(UnityEngine.Transform, "supuriorText")
    self.WoodAdd = self:RegisterController(UnityEngine.UI.Text, "MarkUP/Image/TimberText")
    self.RockAdd = self:RegisterController(UnityEngine.UI.Text, "MarkUP/Image/StoneText")
    self.FoodAdd = self:RegisterController(UnityEngine.UI.Text, "MarkUP/Image/GrainText")
    self.slider = self:RegisterController(UnityEngine.UI.Image, "grade/expstrip/expstrip_Image")
    self.IronAdd = self:RegisterController(UnityEngine.UI.Text, "MarkUP/Image/IronText")
    self.leagueRelationObj = self:RegisterController(UnityEngine.Transform, "leagueRelation")
    self.cityAdd = self:RegisterController(UnityEngine.Transform, "MarkUP/cityAdd")
    self.wood = self:RegisterController(UnityEngine.UI.Text, "MarkUP/cityAdd/TimberText1")
    self.metal = self:RegisterController(UnityEngine.UI.Text, "MarkUP/cityAdd/StoneText1")
    self.food = self:RegisterController(UnityEngine.UI.Text, "MarkUP/cityAdd/GrainText1")
    self.rock = self:RegisterController(UnityEngine.UI.Text, "MarkUP/cityAdd/IronText1")
end

-- 注册点击事件

function AppiontLeagueUI:DoEventAdd()

    self:AddListener(self.LeagueBackBtn, self.OnClickLeagueBackBtn)
    self:AddListener(self.JoinBtn, self.OnClickJoinBtn)
    self:AddListener(self.leagueRelation, self.OnClickleagueRelationBtn)
    self:AddListener(self.LeaderNameBtn, self.OnClickLeaderNameBtn)
    self:AddOnDown(self.JoinBtn, self.AddOnDown)
    self:AddOnUp(self.JoinBtn, self.OnClickUp)
end

-- 按钮的亮片
function AppiontLeagueUI:AddOnDown()
    self.joinImage.gameObject:SetActive(true)
end
function AppiontLeagueUI:OnClickUp()
    self.joinImage.gameObject:SetActive(false)
end



function AppiontLeagueUI:OnClickLeaderNameBtn()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestOtherPlayerBaseInfo").new();
    msg:SetMessageId(C2L_Player.RequestOtherPlayerBaseInfo);
    msg.playerId = self.LeaderId;
    NetService:Instance():SendMessage(msg);
end


function AppiontLeagueUI:CancelSucess()
    self.isHaveApplied = 0
    self.ApplyText.text = "申请加入"
end

function AppiontLeagueUI:ApplySucess()
    self.isHaveApplied = 1
    self.ApplyText.text = "取消申请"
end


function AppiontLeagueUI:OnShow(msg)
    if PlayerService:Instance():GetLeagueId() == 0 then
        self.leagueRelationObj.gameObject:SetActive(false)
    else
        self.leagueRelationObj.gameObject:SetActive(true)
    end

    self.nextDiplomacyTime = msg.nextDiplomacyTime
    self.Name.text = msg.leagueName;
    self.LeagueId = msg.leagueid;
    self.LeaderId = msg.leaderid;
    self.LeaderName.text = msg.leaderName;
    self.Level.text = "Lv." .. msg.level;
    self.Exp.text = msg.exp;
    self.MemberNum.text = msg.memberNum .. "/" .. DataAlliesLevel[msg.level].MemberLimit;
    self.Province.text = DataState[msg.province].Name;
    self.CityNum.text = msg.cityNum;
    self.Influence.text = msg.influnce;
    self.isHaveApplied = msg.isHaveApplied;
    if self.isHaveApplied == 0 then
        self.ApplyText.text = "申请加入"
    else
        self.ApplyText.text = "取消申请"
    end
    if msg.notice == "" then
        self.Notice.text = "暂无公告"
    else
        self.Notice.text = msg.notice;
    end
    self.relationship = msg.diplomacyRelateion;

    for i = 1, self.relationPic.childCount do
        if self.relationship == i - 1 then
            self.relationPic:GetChild(i - 1).gameObject:SetActive(true)
        else
            self.relationPic:GetChild(i - 1).gameObject:SetActive(false)
        end
    end

    if PlayerService:Instance():GetLeagueId() ~= 0 then

        self.JoinBtn.gameObject:SetActive(false)
    else
        self.JoinBtn.gameObject:SetActive(true)
    end

    if PlayerService:Instance():GetPlayerTitle() > LeagueTitleType.ViceLeader then
        self.leagueRelation.gameObject:SetActive(false)
    else
        self.leagueRelation.gameObject:SetActive(true)
    end

    if self.LeagueId == PlayerService:Instance():GetsuperiorLeagueId() then

        self.supuriorText.gameObject:SetActive(true)
    else
        self.supuriorText.gameObject:SetActive(false)

    end
    self.Exp.text = msg.exp - DataAlliesLevel[msg.level].SumExp + DataAlliesLevel[msg.level].UpgradeXP .. "/" .. DataAlliesLevel[msg.level].UpgradeXP;
    self.slider.fillAmount =(msg.exp - DataAlliesLevel[msg.level].SumExp + DataAlliesLevel[msg.level].UpgradeXP) / DataAlliesLevel[msg.level].UpgradeXP;
    self.WoodAdd.text = "木材产量+" .. DataAlliesLevel[msg.level].WoodModifier / 100 .. "%"
    self.RockAdd.text = "石材产量+" .. DataAlliesLevel[msg.level].StoneModifier / 100 .. "%"
    self.FoodAdd.text = "粮食产量+" .. DataAlliesLevel[msg.level].FoodModifier / 100 .. "%"
    self.IronAdd.text = "铁矿产量+" .. DataAlliesLevel[msg.level].IronModifier / 100 .. "%"
    self:GetSource(msg)
end


function AppiontLeagueUI:GetSource(league)
    local wood = league.cityWoodAdd
    local food = league.cityGrainAdd
    local metal = league.cityIronAdd
    local rock = league.cityStoneAdd
    self.wood.text = "木材产量+" .. wood
    self.rock.text = "石材产量+" .. rock
    self.food.text = "粮食产量+" .. food
    self.metal.text = "铁矿产量+" .. metal
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

-- 点击逻辑

function AppiontLeagueUI:OnClickLeagueBackBtn()

    UIService:Instance():HideUI(UIType.AppiontLeagueUI)

end

function AppiontLeagueUI:OnClickJoinBtn()

    if self.isHaveApplied == 0 then
        LeagueService:Instance():SendApplyJoin(PlayerService:Instance():GetPlayerId(), self.LeagueId)
    else
        LeagueService:Instance():CancelApplyJoin(PlayerService:Instance():GetPlayerId(), self.LeagueId)
    end

end

function AppiontLeagueUI:OnClickleagueRelationBtn()

    local time = self.nextDiplomacyTime
    local relationtype = self.relationship
    local data = { self.LeagueId, relationtype, time };
    UIService:Instance():ShowUI(UIType.RelationUI, data)

end


return AppiontLeagueUI
-- endregion






-- endregion
