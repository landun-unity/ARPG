-- region *.lua
-- Date16/10/19

local UIBase = require("Game/UI/UIBase")

local MemberLeagueUI = class("MemberLeagueUI", UIBase)

function MemberLeagueUI:ctor()

    MemberLeagueUI.super.ctor(self);
    self.playerid = nil;
    self.name = nil;
    self.totalContribution = nil;
    self.weekContribution = nil;
    self.battleAchievment = nil;
    self.influence = nil;
    self.coord = nil;
    self.title = nil;
    self.titleNum = nil;
    self.nameBtn = nil;
    self.appiontBtn = nil;
    self.myInfo = nil;
    self.panel = nil;
    self.posx = nil;
    self.posy = nil;
    self.nextAppointCoolingTime = 0;
    self.tiledid = nil;
    self.coordBtn = nil;
    self.panelBtn = nil;
end


function MemberLeagueUI:DoDataExchange()

    self.name = self:RegisterController(UnityEngine.UI.Text, "nameButton/nameText");

    self.totalContribution = self:RegisterController(UnityEngine.UI.Text, "All");

    self.weekContribution = self:RegisterController(UnityEngine.UI.Text, "Week");

    self.battleAchievment = self:RegisterController(UnityEngine.UI.Text, "Wuxun");

    self.influence = self:RegisterController(UnityEngine.UI.Text, "Influence");

    self.coord = self:RegisterController(UnityEngine.UI.Text, "Coord");

    self.coordBtn = self:RegisterController(UnityEngine.UI.Button, "Coord");

    self.title = self:RegisterController(UnityEngine.UI.Text, "Title");

    self.nameBtn = self:RegisterController(UnityEngine.UI.Button, "nameButton")

    self.appiontBtn = self:RegisterController(UnityEngine.UI.Button, "appointButton")

    self.state = self:RegisterController(UnityEngine.UI.Text, "Location");

    self.panel = self:RegisterController(UnityEngine.Transform, "panel");

    self.floodImage = self:RegisterController(UnityEngine.Transform, "FloodImage");

    self.MyImageBtn = self:RegisterController(UnityEngine.UI.Button, "Image1");

end

function MemberLeagueUI:SetMemberLeagueMessage(mMemberLeagueUI)


    self.playerid = mMemberLeagueUI.playerid;
    self.titleNum = mMemberLeagueUI.title

    if mMemberLeagueUI.title == LeagueTitleType.Leader then
        self.title.text = "盟主";
    elseif mMemberLeagueUI.title == LeagueTitleType.ViceLeader then
        self.title.text = "副盟主";
    elseif mMemberLeagueUI.title == LeagueTitleType.Command then
        self.title.text = "指挥官";
    elseif mMemberLeagueUI.title == LeagueTitleType.Officer then
        self.title.text = "官员";
    elseif mMemberLeagueUI.title == LeagueTitleType.Nomal then
        self.title.text = "";
    end
    -- print(mMemberLeagueUI.isBeFall)
    if mMemberLeagueUI.isBeFall == true then
        self.panel.gameObject:SetActive(true)
        self.floodImage.gameObject:SetActive(true)
    else
        self.floodImage.gameObject:SetActive(false)
        self.panel.gameObject:SetActive(false)
    end
    self.tiledid = mMemberLeagueUI.coord
    self.name.text = mMemberLeagueUI.name;
    self.totalContribution.text = mMemberLeagueUI.totalContribution;
    self.weekContribution.text = mMemberLeagueUI.weekContribution;
    self.battleAchievment.text = mMemberLeagueUI.battleAchievment;
    self.influence.text = mMemberLeagueUI.influence;
    local posx, posy = MapService:Instance():GetTiledCoordinate(mMemberLeagueUI.coord)
    local stateID = PmapService:Instance():GetStateIDbyIndex(mMemberLeagueUI.coord)
    self.coord.text = "" .. "(" .. posx .. "," .. posy .. ")";
    self.state.text = DataState[stateID].Name
    self.posx = posx
    self.posy = posy
    if LeagueService:Instance():GetMyinfo().title >= LeagueTitleType.Command and self.playerid ~= PlayerService:Instance():GetPlayerId() then
        self.appiontBtn.gameObject:SetActive(false);
    end
    if LeagueService:Instance():GetMyinfo().title > mMemberLeagueUI.title then
        self.appiontBtn.gameObject:SetActive(false);
    end
    self.nextAppointCoolingTime = mMemberLeagueUI.nextAppointCoolingTime

end




function MemberLeagueUI:DoEventAdd()
    self:AddListener(self.appiontBtn, self.OnClickappiontBtn)
    self:AddListener(self.nameBtn, self.OnClicknameBtn)
    self:AddListener(self.coordBtn, self.OnClickcoordBtn)
end

function MemberLeagueUI:OnClickMyImageBtn()

end

function MemberLeagueUI:OnClickcoordBtn()
    -- body

    self.temp = { };
    self.temp[1] = "是否跳转到坐标<color=#599ba9>(" .. self.posx .. "," .. self.posy .. ")</color>"
    self.temp[2] = self;
    self.temp[3] = self.CommonOk;
    UIService:Instance():ShowUI(UIType.CommonGoToPosition, self.temp)

end
-- 获取格子耐久

function MemberLeagueUI:CommonOk()
    -- body
    MapService:Instance():ScanTiledMark(self.tiledid);
    UIService:Instance():ShowUI(UIType.UIGameMainView);
    UIService:Instance():HideUI(UIType.LeagueMemberUI);
    UIService:Instance():HideUI(UIType.LeagueExistUI)
end
function MemberLeagueUI:CommonCancle(...)
    -- body	
    UIService:Instance():HideUI(UIType.CommonOkOrCancle);
end



function MemberLeagueUI:OnClickappiontBtn()


    if LeagueService:Instance():GetMyinfo().title == LeagueTitleType.Leader then
        if PlayerService:Instance():GetPlayerId() == self.playerid then
            UIService:Instance():ShowUI(UIType.LeaderSelfPowerUI)
        else
            if self.titleNum == 5 then
                local data = { self.playerid, self.name.text };
                UIService:Instance():ShowUI(UIType.LeaderOtherPowerUI, data)
            else
                local data = { self.playerid, self.name.text, self.nextAppointCoolingTime };
                UIService:Instance():ShowUI(UIType.LeaderRecallOtherPowerUI, data)
            end
        end
    end

    if LeagueService:Instance():GetMyinfo().title == LeagueTitleType.ViceLeader then
        if PlayerService:Instance():GetPlayerId() == self.playerid then
            UIService:Instance():ShowUI(UIType.SLeaderSelfPower)
        else
            if self.titleNum == 5 then
                local data = { self.playerid, self.name.text };
                UIService:Instance():ShowUI(UIType.SLeaderOtherPower, data)
            else
                local data = { self.playerid, self.name.text, self.nextAppointCoolingTime };
                UIService:Instance():ShowUI(UIType.SLeaderRecallOtherPower, data)
            end
        end
    end

    if LeagueService:Instance():GetMyinfo().title > LeagueTitleType.ViceLeader then
        UIService:Instance():ShowUI(UIType.MemberPowerUI)
    end

end


function MemberLeagueUI:OnClicknameBtn()
    -- 请求成员信息
    if self.playerid == PlayerService:Instance():GetPlayerId() then
        UIService:Instance():ShowUI(UIType.UIPersonalPower)
    else
        local msg = require("MessageCommon/Msg/C2L/Player/RequestOtherPlayerBaseInfo").new();
        msg:SetMessageId(C2L_Player.RequestOtherPlayerBaseInfo);
        msg.playerId = self.playerid;
        NetService:Instance():SendMessage(msg);
    end
end


return MemberLeagueUI
-- endregion
