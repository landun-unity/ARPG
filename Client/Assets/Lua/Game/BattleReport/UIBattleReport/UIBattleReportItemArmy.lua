--[[游戏主界面]]

local UIBase= require("Game/UI/UIBase");
local UIBattleReportItemArmy=class("UIBattleReportItemArmy",UIBase);
local List = require("common/List");
local HeroData = require("Game/Table/model/DataHero")

function UIBattleReportItemArmy:ctor()
    UIBattleReportItemArmy.super.ctor(self)
    self._Lv = nil;
    self._ArmyNum = nil;
    self._Name = nil;
    self._Icon = nil;
    self.armyicon = nil;
    self._AttackDis = nil;
    self._ArmyType = nil;
    self._YelloStar1 = nil;
    self._YelloStar2 = nil;
    self._YelloStar3 = nil;
    self._YelloStar4 = nil;
    self._YelloStar5 = nil;
    self._RedStar1 = nil;
    self._RedStar2 = nil;
    self._RedStar3 = nil;
    self._RedStar4 = nil;
    self._RedStar5 = nil;
    self._HaveNoArmy = nil;
    self._YellowStars = List.new();
    self._RedStars = List.new();
end

function  UIBattleReportItemArmy:DoDataExchange(args)
    self._Lv = self:RegisterController(UnityEngine.UI.Text,"Lv")
    self._ArmyNum = self:RegisterController(UnityEngine.UI.Text,"ArmyNum")
    self._Name = self:RegisterController(UnityEngine.UI.Text,"Name")
    self._AttackDis = self:RegisterController(UnityEngine.UI.Text,"AttackDis")
    self._ArmyType = self:RegisterController(UnityEngine.UI.Image,"ArmyType")
    self._Icon = self:RegisterController(UnityEngine.UI.Image,"icon")
    self.armyicon = self:RegisterController(UnityEngine.UI.Image,"armyicon")
    self._YelloStar1 = self:RegisterController(UnityEngine.Transform,"StarImage/YellowStar/YellowImage1")
    self._YelloStar2 = self:RegisterController(UnityEngine.Transform,"StarImage/YellowStar/YellowImage2")
    self._YelloStar3 = self:RegisterController(UnityEngine.Transform,"StarImage/YellowStar/YellowImage3")
    self._YelloStar4 = self:RegisterController(UnityEngine.Transform,"StarImage/YellowStar/YellowImage4")
    self._YelloStar5 = self:RegisterController(UnityEngine.Transform,"StarImage/YellowStar/YellowImage5")
    self._RedStar1 = self:RegisterController(UnityEngine.Transform,"StarImage/RedStar/RedImage1")
    self._RedStar2 = self:RegisterController(UnityEngine.Transform,"StarImage/RedStar/RedImage2")
    self._RedStar3 = self:RegisterController(UnityEngine.Transform,"StarImage/RedStar/RedImage3")
    self._RedStar4 = self:RegisterController(UnityEngine.Transform,"StarImage/RedStar/RedImage4")
    self._RedStar5 = self:RegisterController(UnityEngine.Transform,"StarImage/RedStar/RedImage5")
    self._HaveNoArmy = self:RegisterController(UnityEngine.Transform,"HaveNoArmy")
end

--卡牌兵力显示隐藏
function UIBattleReportItemArmy:HideCardSoldiers(show)
    self.armyicon.gameObject:SetActive(show);
    self._ArmyNum.gameObject:SetActive(show);
end

--设置卡牌相关的信息
function UIBattleReportItemArmy:SetInfo(TableID,Level,ArmyNum,Redstar)
    if Level ~= nil then
        self._Lv.text = "Lv."..Level;
    end
    self._ArmyNum.text = tostring(ArmyNum)
    local line = HeroData[TableID];
    if(line~=nil) then
        self._Name.text = line.Name;
        self._AttackDis.text = tostring(line.AttackRange)
        self._ArmyType.sprite = GameResFactory.Instance():GetResSprite((HeroService:Instance():GetSpriteByTppe(line.BaseArmyType)));
        self._Icon.sprite = GameResFactory.Instance():GetResSprite(line.HeadPortrait);
        LogManager:Instance():Log(line.Name.." 的 Redstar:"..Redstar);
        self:SetStars(line.Star,Redstar);
        self._HaveNoArmy.gameObject:SetActive(false);
        self:HideCardSoldiers(true)
    else
        self._HaveNoArmy.gameObject:SetActive(true);
        self:HideCardSoldiers(false)
    end
end

--设置星星总个数 红色星星个数
function UIBattleReportItemArmy:SetStars(AllNum,redNum)   
    if(self._YellowStars:Count() == 0) then
        self._YellowStars:Push(self._YelloStar1);
        self._YellowStars:Push(self._YelloStar2);
        self._YellowStars:Push(self._YelloStar3);
        self._YellowStars:Push(self._YelloStar4);
        self._YellowStars:Push(self._YelloStar5);
    end
    if(self._RedStars:Count() == 0) then
        self._RedStars:Push(self._RedStar1);
        self._RedStars:Push(self._RedStar2);
        self._RedStars:Push(self._RedStar3);
        self._RedStars:Push(self._RedStar4);
        self._RedStars:Push(self._RedStar5);
    end
    for i=1,5 do
        if i<=AllNum then
            self._YellowStars:Get(i).gameObject:SetActive(true);
        else
            self._YellowStars:Get(i).gameObject:SetActive(false);
        end
        if i<=redNum then
            self._RedStars:Get(i).gameObject:SetActive(true);
        else
            self._RedStars:Get(i).gameObject:SetActive(false);
        end   
    end
end

return UIBattleReportItemArmy