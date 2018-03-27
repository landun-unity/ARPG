-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local RelationUI = class("RelationUI", UIBase)
require("Game/League/RelationShipType")

function RelationUI:ctor()

    RelationUI.super.ctor(self)

    self.firendBtn = nil;
    self.enemyBtn = nil;
    self.norelationBtn = nil;
    self.leagueid = nil;
    self.firendText = nil;
    self.enemyText = nil;
    self.noText = nil;
    self.time = nil;
    self.relationtype = nil;
    self.timer = nil;
    self.backBtn = nil;
end


function RelationUI:DoDataExchange()

    self.firendBtn = self:RegisterController(UnityEngine.UI.Button, "firend")
    self.enemyBtn = self:RegisterController(UnityEngine.UI.Button, "enemy")
    self.norelationBtn = self:RegisterController(UnityEngine.UI.Button, "norelation")

    self.firendText = self:RegisterController(UnityEngine.UI.Text, "firendtext/Text")
    self.firendText1 = self:RegisterController(UnityEngine.UI.Text, "firendtext")

    self.enemyText = self:RegisterController(UnityEngine.UI.Text, "enemytext/Text")
    self.enemyText1 = self:RegisterController(UnityEngine.UI.Text, "enemytext")

    self.noText = self:RegisterController(UnityEngine.UI.Text, "notext/Text")
    self.noText1 = self:RegisterController(UnityEngine.UI.Text, "notext")

    self.BackBtn = self:RegisterController(UnityEngine.UI.Button, "BackBtn")

end

function RelationUI:DoEventAdd()

    self:AddListener(self.firendBtn, self.OnClickfirendBtn)
    self:AddListener(self.enemyBtn, self.OnClickenemyBtn)
    self:AddListener(self.norelationBtn, self.OnClicknorelationBtn)
    self:AddListener(self.BackBtn, self.OnClickBackBtn)
end

function RelationUI:OnShow(data)

    self.leagueid = data[1]
    self.relationtype = data[2]
    self.time = data[3]
    print(data[3])
    self.firendText.gameObject:SetActive(false)
    self.enemyText.gameObject:SetActive(false)
    self.noText.gameObject:SetActive(false)
    if self.time - PlayerService:Instance():GetLocalTime() > 0 then
        if self.relationtype == RelationShipType.Firend then
            self.firendText.gameObject:SetActive(true)
            self.enemyText.gameObject:SetActive(false)
            self.noText.gameObject:SetActive(false)
            CommonService:Instance():TimeDown(UIType.RelationUI, self.time,self.firendText,function() self:EndTimer() end)
        end
        if self.relationtype == RelationShipType.Enemy then
            self.firendText.gameObject:SetActive(false)
            self.enemyText.gameObject:SetActive(true)
            self.noText.gameObject:SetActive(false)
            CommonService:Instance():TimeDown(UIType.RelationUI,self.time,self.enemyText, function() self:EndTimer() end)
        end
        if self.relationtype == RelationShipType.None then
            self.firendText.gameObject:SetActive(false)
            self.enemyText.gameObject:SetActive(false)
            self.noText.gameObject:SetActive(true)
            CommonService:Instance():TimeDown(UIType.RelationUI,self.time,self.noText, function() self:EndTimer() end)
        end
    else
        self.firendText.gameObject:SetActive(false)
        self.enemyText.gameObject:SetActive(false)
        self.noText.gameObject:SetActive(false)
    end


end




function RelationUI:OnClickfirendBtn()

    if self.firendText.gameObject.activeSelf or self.noText.gameObject.activeSelf or self.noText.gameObject.activeSelf then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.timeCooling)
    else
    print("点击友好 ")
        LeagueService:Instance():SendLeagueRelationMsg(self.leagueid, RelationShipType.Firend)
    end
end


function RelationUI:OnClickenemyBtn()

    if self.firendText.gameObject.activeSelf or self.noText.gameObject.activeSelf or self.noText.gameObject.activeSelf   then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.timeCooling)
    else
    print("点击敌对 ")

        LeagueService:Instance():SendLeagueRelationMsg(self.leagueid, RelationShipType.Enemy)
    end
end


function RelationUI:OnClicknorelationBtn()

    if self.firendText.gameObject.activeSelf or self.noText.gameObject.activeSelf or self.noText.gameObject.activeSelf  then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.timeCooling)
    else
        LeagueService:Instance():SendLeagueRelationMsg(self.leagueid, RelationShipType.None)
    end

end

function RelationUI:EndTimer()
    self.firendText.gameObject:SetActive(false)
    self.enemyText.gameObject:SetActive(false)
    self.noText.gameObject:SetActive(false)
end


function RelationUI:OnClickBackBtn()
    UIService:Instance():HideUI(UIType.RelationUI)
end


return RelationUI