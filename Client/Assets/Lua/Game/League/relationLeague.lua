-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local relationLeague = class("relationLeague", UIBase)
require("Game/League/RelationShipType")
function relationLeague:ctor()

    relationLeague.super.ctor(self)
    self.nameBtn = nil;
    self.name = nil;
    self.level = nil;
    self.pro = nil;
    self.memberNum = nil;
    self.influence = nil;
    self.relation = nil;
    self.LeagueId = nil;
    self.itemRedImage = nil;
    self.nextDiplomacyTime = 0
end


function relationLeague:DoDataExchange()

    self.nameBtn = self:RegisterController(UnityEngine.UI.Button, "Name")
    self.name = self:RegisterController(UnityEngine.UI.Text, "Name/Text")
    self.level = self:RegisterController(UnityEngine.UI.Text, "level")
    self.pro = self:RegisterController(UnityEngine.UI.Text, "pro");
    self.memberNum = self:RegisterController(UnityEngine.UI.Text, "memberNum");
    self.influence = self:RegisterController(UnityEngine.UI.Text, "influence");
    self.relation = self:RegisterController(UnityEngine.UI.Text, "relation");
    self.relationBtn = self:RegisterController(UnityEngine.UI.Button, "relationBtn");
    self.firend = self:RegisterController(UnityEngine.UI.Image, "AmityImage");
    self.enemyImage = self:RegisterController(UnityEngine.UI.Image, "HostilityImage");
    self.itemRedImage = self:RegisterController(UnityEngine.UI.Image, "redImage");

end

function relationLeague:DoEventAdd()

    self:AddListener(self.nameBtn.gameObject, self.OnClicknameBtn);
    self:AddListener(self.relationBtn.gameObject, self.OnClickrelationBtn);
end


function relationLeague:OnShow()

    if PlayerService:Instance():GetPlayerTitle() < LeagueTitleType.Command then

        self.relationBtn.gameObject:SetActive(true)
    else
        self.relationBtn.gameObject:SetActive(false)
    end

end

function relationLeague:SetMessage(args, isfriend)
    self.name.text = args.name;
    self.level.text = args.level;
    self.pro.text = args.province;
    self.memberNum.text = args.num;
    self.influence.text = args.influence;
    self.nextDiplomacyTime = args.nextSettingTime
    self.leagueRelation = RelationShipType.None
    if isfriend then
        self.firend.gameObject:SetActive(true);
        self.leagueRelation = RelationShipType.Firend
        self.enemyImage.gameObject:SetActive(false);
    else
        self.firend.gameObject:SetActive(false);
        self.leagueRelation = RelationShipType.Enemy
        self.enemyImage.gameObject:SetActive(true);
    end
    self.LeagueId = args.leagueId;

end

function relationLeague:OnClicknameBtn()
    LeagueService:Instance():SendOpenAppiontLeague(playerId, self.LeagueId)
end

function relationLeague:OnClickrelationBtn()
    local time = self.nextDiplomacyTime;
    local relationtype = self.leagueRelation
    local data = { self.LeagueId, relationtype, time };
    UIService:Instance():ShowUI(UIType.RelationUI, data)

end


function relationLeague:SetRedImage(args)
    self.itemRedImage.gameObject:SetActive(args)
end


return relationLeague