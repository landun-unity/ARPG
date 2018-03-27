--region *.lua
--Date
local UIBase = require("Game/UI/UIBase");
local RankListItemUI = class("RankListItemUI",UIBase)

function RankListItemUI:ctor()
    
    RankListItemUI.super.ctor(self)

    self.Rank = nil;
    self.RankBgParent = nil;
    self.NameButton = nil;
    self.Name = nil;
    self.Param3 = nil;
    self.Param4 = nil;
    self.Param5 = nil;
    self.Param6 = nil;
    self.Value = nil;
    self.selectBg = nil;

    self.rankType = RankListType.PersonalRankList;
    self.rankInfo = nil;
end


function RankListItemUI:DoDataExchange()
    self.Rank = self:RegisterController(UnityEngine.UI.Text,"Rank");
    self.RankBgParent = self:RegisterController(UnityEngine.RectTransform,"RankBgParent");
    self.NameButton = self:RegisterController(UnityEngine.UI.Button,"NameButton");
    self.Name = self:RegisterController(UnityEngine.UI.Text,"NameButton/Name");
    self.Param3 = self:RegisterController(UnityEngine.UI.Text,"Param3");
    self.Param4 = self:RegisterController(UnityEngine.UI.Text,"Param4");
    self.Param5 = self:RegisterController(UnityEngine.UI.Text,"Param5");
    self.Param6 = self:RegisterController(UnityEngine.UI.Text,"Param6");
    self.Value = self:RegisterController(UnityEngine.UI.Text,"Value");
    self.selectBg = self:RegisterController(UnityEngine.UI.Image,"selectBg");
end

function RankListItemUI:DoEventAdd()

    self:AddListener(self.NameButton, self.OnCilckNameBtn);

end

function RankListItemUI:OnHide()
	self.rankInfo = nil;
end

-- info : PlayerModel
function RankListItemUI:SetInfo(rankType,info)
    if info == nil then
        return;
    end
    self.rankType = rankType;
    self.rankInfo = info;
    if type(info.rankPostion) == "string" then
        self.selectBg.gameObject:SetActive(true);
        self.NameButton.interactable = false;
    else
        self.selectBg.gameObject:SetActive(false);
    end
    self.RankBgParent.gameObject:SetActive(false);
    self.Rank.text = info.rankPostion;
    self.Name.text = info.name;
    self.Value.text = info.influence;
    local stateData = DataState[info.province];

    local myId = PlayerService:Instance():GetPlayerId();
    local myLeagueId = PlayerService:Instance():GetLeagueId();

    if rankType == RankListType.PersonalRankList then       
        if stateData ~= nil then
            self.Param3.text = stateData.Name;
        end
        self.Param4.text = info.subcityNum;
        self.Param5.text = info.fortNum;
        self.Param6.text = info.landNum;
        if info.playerid == myId then
             self.selectBg.gameObject:SetActive(true);
             self.NameButton.interactable = false;
        else
            self.NameButton.interactable = true;
        end
    else
        if type(info.rankPostion) ~= "string" and info.rankPostion >=1 and info.rankPostion <=3 then
            self.RankBgParent.gameObject:SetActive(true);
            for i =1 ,self.RankBgParent.childCount do
                if i == info.rankPostion then
                    self.RankBgParent:GetChild(i-1).gameObject:SetActive(true);
                else
                    self.RankBgParent:GetChild(i-1).gameObject:SetActive(false);
                end
            end
        end
        self.Param3.text = "Lv."..info.leagueLevel;
        if stateData ~= nil then
            self.Param4.text = stateData.Name;
        end
        self.Param5.text = info.memberNum;
        self.Param6.text = info.wildCityNum;
        if myLeagueId ~= 0 then
            if info.leagueId == myLeagueId then
                self.selectBg.gameObject:SetActive(true);
                self.NameButton.interactable = false;
            else
                self.NameButton.interactable = true;
            end
        end
    end
end

function RankListItemUI:OnCilckNameBtn()
    if self.rankInfo == nil then
        return;
    end
    if self.rankType == RankListType.PersonalRankList then
        if self.rankInfo.playerid ~= PlayerService:Instance():GetPlayerId() then
            CommonService:Instance():RequestPlayerInfo(self.rankInfo.playerid);
        end
    else
        if self.rankInfo.leagueId ~= 0 then
            --if self.rankInfo.leagueId ~= PlayerService:Instance():GetLeagueId() then
                LeagueService:Instance():SendOpenAppiontLeague(0,self.rankInfo.leagueId);
            --end
        end
    end
end

return RankListItemUI