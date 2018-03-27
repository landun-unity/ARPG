--[[游戏主界面]]

local UIBase= require("Game/UI/UIBase");
local UIBattleReportDetailCard=class("UIBattleReportDetailCard",UIBase);
local List = require("common/List");
local DataHero = require("Game/Table/model/DataHero")

function UIBattleReportDetailCard:ctor()
    UIBattleReportDetailCard.super.ctor(self)

    self.campGrey = nil;
    self.soldierTypeGrey = nil;
    self.StarGreyParent = nil;
    self.yellowStarGreyParent = nil;
    self.redStarGreyParent = nil;

    self.campNormalParent = nil;
    self.HeroHeadImage = nil;
    self.StateImage = nil;
    self.HeroNameText = nil;
    self.costTextBg = nil;
    self.CostValue = nil;
    self.LevelBg = nil;
    self.Level = nil;
    self.LeftTroops = nil;
    self.Dis = nil;
    self.TypeImageParent = nil;
    self._WoundTroops= nil;
    self._YellowStars = List.new();
    self._RedStars = List.new();
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
    self._go = nil;
    self._attackNAme = nil;
    self.HeroID = 0;
    self.cardInfo = nil;
end

--注册控件
function UIBattleReportDetailCard:DoDataExchange()
    
    self.campGrey = self:RegisterController(UnityEngine.Transform,"CampGrey");
    self.soldierTypeGrey = self:RegisterController(UnityEngine.Transform,"SoldierTypeGray");
    self.StarGreyParent = self:RegisterController(UnityEngine.Transform,"StarGreyImage");
    self.yellowStarGreyParent = self:RegisterController(UnityEngine.Transform,"StarGreyImage/YellowStar");
    self.redStarGreyParent = self:RegisterController(UnityEngine.Transform,"StarGreyImage/RedStar");

    self.campNormalParent = self:RegisterController(UnityEngine.Transform,"StateFormImage");
    self.HeroHeadImage = self:RegisterController(UnityEngine.UI.Image,"HeroHeadImage")
    self.StateImage = self:RegisterController(UnityEngine.UI.Image,"StateImage")
    self.HeroNameText = self:RegisterController(UnityEngine.UI.Text,"HeroNameText")
    self.costTextBg = self:RegisterController(UnityEngine.UI.Text,"Cost")
    self.CostValue = self:RegisterController(UnityEngine.UI.Text,"Cost/CostValue")
    self.LevelBg = self:RegisterController(UnityEngine.UI.Text,"GradeText")
    self.Level = self:RegisterController(UnityEngine.UI.Text,"GradeText/Text")
    self.Dis = self:RegisterController(UnityEngine.UI.Text,"Dis")
    self.TypeImageParent = self:RegisterController(UnityEngine.Transform,"SoldierType");
    self.LeftTroops = self:RegisterController(UnityEngine.UI.Text,"NumberImage/LeftTroops")
    self._WoundTroops = self:RegisterController(UnityEngine.UI.Text,"NumberImage/OverTroops")
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

    self._attackNAme = nil;
end

--注册控件点击事件
function UIBattleReportDetailCard:DoEventAdd()
    
end

--设置对象
function UIBattleReportDetailCard:SetGo(goObj)
    self._go = goObj;
end

--初始化卡牌
function UIBattleReportDetailCard:InitCard(info)

    local line = DataHero[info.heroid];
    self.HeroID = info.heroid;
    self.cardInfo = info;
    -- print("line.Pic:"..line.Pic);
    self.HeroHeadImage.sprite = GameResFactory.Instance():GetResSprite(line.Pic)

    for i =1 ,self.TypeImageParent.childCount do
        local item = self.TypeImageParent:GetChild(i-1);
        if i == line.BaseArmyType then 
            item.gameObject:SetActive(true);
        else
            item.gameObject:SetActive(false); 
        end
    end
    self.StateImage.sprite = GameResFactory.Instance():GetResSprite(HeroService:Instance():GetCampSprite(line.Camp))

    self._go:SetActive(true);
    self.HeroNameText.text = line.Name
    self.CostValue.text = line.Cost;
    self.Level.text = tostring(info.cardLevel);
    --self.LeftTroops.text = tostring(info.startTroopNum)  --这个数据是临时的 
    self._WoundTroops.text = ""
    self.Dis.text = tostring(line.AttackRange)
    self:SetStars(line.Star,info.advanceTimes);
    self:SetGreyCard(info,false);
    self:SetNormalCamp(line.Camp);
end

function UIBattleReportDetailCard:SetNormalCamp(camp)
    for i =1 ,self.campNormalParent.childCount do
        local item = self.campNormalParent:GetChild(i-1);
        if i == camp then 
            item.gameObject:SetActive(true);
        else
            item.gameObject:SetActive(false); 
        end
    end
end

--设置伤兵数量
function UIBattleReportDetailCard:SetWoundTroop(dic)
    if(dic[self.HeroID]~=nil) then
        self._WoundTroops.text = tostring(dic[self.HeroID])
    end
end

--设置卡牌的剩余兵种数量
function UIBattleReportDetailCard:SetLeftTroop(dic)
    if(dic[self.HeroID]~=nil) then
        self.LeftTroops.text = tostring(dic[self.HeroID])
        --设置死亡的情况        
        if(dic[self.HeroID]<=0) then            
            self:SetGreyCard(self.cardInfo,true);
        else
            self:SetGreyCard(self.cardInfo,false);
        end
    end
end

--设置星星总个数 红色星星个数
function UIBattleReportDetailCard:SetStars(AllNum,redNum)
    --print("AllNum:"..AllNum.." redNum:"..redNum)
    if self._YellowStars:Count() == 0 then
        self._YellowStars:Push(self._YelloStar1);
        self._YellowStars:Push(self._YelloStar2);
        self._YellowStars:Push(self._YelloStar3);
        self._YellowStars:Push(self._YelloStar4);
        self._YellowStars:Push(self._YelloStar5);
    end
    if self._RedStars:Count() == 0 then
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

function UIBattleReportDetailCard:SetGreyCard(cardInfo,isGrey)
    local dataHeroCard = DataHero[self.HeroID];
    if isGrey == true then
        --local deadName = "dead_"..dataHeroCard.Pic;
        self.HeroHeadImage.sprite = GameResFactory.Instance():GetResSprite(dataHeroCard.Pic);

        --self.HeroHeadImage
        GameResFactory.Instance():LoadMaterial(self.HeroHeadImage,"Shader/HeroCardGray");

        --阵营图片变灰
        self.campGrey.gameObject:SetActive(true);
        for i =1 ,self.campGrey.childCount do
            local item = self.campGrey:GetChild(i-1);
            if i == dataHeroCard.Camp then 
                item.gameObject:SetActive(true);
            else
                item.gameObject:SetActive(false); 
            end
        end
        --兵种类型图片变灰
        self.soldierTypeGrey.gameObject:SetActive(true);
        for i =1 ,self.soldierTypeGrey.childCount do
            local item = self.soldierTypeGrey:GetChild(i-1);
            if i == dataHeroCard.BaseArmyType then 
                item.gameObject:SetActive(true);
            else
                item.gameObject:SetActive(false); 
            end
        end
        --星星变灰
        self.StarGreyParent.gameObject:SetActive(true);
        for i =1 ,self.yellowStarGreyParent.childCount do
            local item = self.yellowStarGreyParent:GetChild(i-1);
            if i <= dataHeroCard.Star then 
                item.gameObject:SetActive(true);
            else
                item.gameObject:SetActive(false); 
            end
        end
        for i =1 ,self.redStarGreyParent.childCount do
            local item = self.redStarGreyParent:GetChild(i-1);
            if i <= cardInfo.advanceTimes then 
                item.gameObject:SetActive(true);
            else
                item.gameObject:SetActive(false); 
            end
        end
        --Text变灰
        self.costTextBg.color = Color.gray;
        self.CostValue.color = Color.gray;
        self.LevelBg.color = Color.gray;
        self.Level.color = Color.gray;
        self.LeftTroops.color = Color.gray;
    else
        --self.HeroHeadImage.sprite = GameResFactory.Instance():GetResSprite(dataHeroCard.Pic);
        self.HeroHeadImage.material = nil;
        self.campGrey.gameObject:SetActive(false);
        self.soldierTypeGrey.gameObject:SetActive(false);
        self.StarGreyParent.gameObject:SetActive(false);
        self.costTextBg.color = Color.New(230/255,207/255,172/255,1);
        self.CostValue.color = Color.white;
        self.LevelBg.color = Color.New(230/255,207/255,172/255,1);
        self.Level.color = Color.white;
        self.LeftTroops.color = Color.white;
    end
end

return UIBattleReportDetailCard
