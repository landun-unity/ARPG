--[[游戏主界面]]

local UIBase= require("Game/UI/UIBase");
local UIBattleReportCountArmy=class("UIBattleReportCountArmy",UIBase);
local UIType=require("Game/UI/UIType");
local UIConfigTable=require("Game/Table/model/DataUIConfig");
local UIBattleReportCountArmyItem = require("Game/BattleReport/UIBattleReport/UIBattleReportCountArmyItem");
function UIBattleReportCountArmy:ctor()
    UIBattleReportCountArmy.super.ctor(self)
    self.camp = nil;
    self.middleTroops = nil;
    self.vanguard = nil;
    self.campParent = nil;
    self.middleTroopsParent = nil;
    self.vanguardParent = nil;
    self.Result = nil;
    --self.Armpart = nil;
    self.ArmyItemPrefab = UIConfigTable[UIType.UIBattleReportCountArmyItem].ResourcePath;
end

--注册控件
function UIBattleReportCountArmy:DoDataExchange()
    self.campParent = self:RegisterController(UnityEngine.Transform,"All/Army/Camp")
    self.middleTroopsParent = self:RegisterController(UnityEngine.Transform,"All/Army/MiddleTroop")
    self.vanguardParent = self:RegisterController(UnityEngine.Transform,"All/Army/vanguard")
    self.Result = self:RegisterController(UnityEngine.UI.Image,"All/Result")
    --self.Armpart = self:RegisterController(UnityEngine.UI.Image,"All/Army/OnOurPartImage/Image")
end

function UIBattleReportCountArmy:DoEventAdd()
    
end

--显示我方还是敌方
function UIBattleReportCountArmy:InitOurPart(isourpart)
    if(isourpart) then
        self.Armpart.sprite = GameResFactory.Instance():GetResSprite("OnOurPart");
    else
        self.Armpart.sprite = GameResFactory.Instance():GetResSprite("OnOtherPart");
    end
end

--初始化
function UIBattleReportCountArmy:InitArmy(herolist,CountList,battleresult,ourpart)
    local count1 = nil;
    local count2 = nil;
    local count3 = nil;
    
    local hero1 = nil;
    local hero2 = nil;
    local hero3 = nil;
    if(ourpart) then
        local countOur = CountList:Count()
        count1 = CountList:Get(countOur);
        count2 = CountList:Get(countOur-1);
        count3 = CountList:Get(countOur-2);
    
        countOur = herolist:Count()
        hero1 = herolist:Get(countOur);
        hero2 = herolist:Get(countOur-1);
        hero3 = herolist:Get(countOur-2);
    else
        local countOur = CountList:Count()
        count1 = CountList:Get(countOur);
        count2 = CountList:Get(countOur-1);
        count3 = CountList:Get(countOur-2);
    
        countOur = herolist:Count()
        hero1 = herolist:Get(countOur);
        hero2 = herolist:Get(countOur-1);
        hero3 = herolist:Get(countOur-2);
    end
    

    if(self.camp == nil)then
        self.camp = UIBattleReportCountArmyItem.new();
        GameResFactory.Instance():GetUIPrefab(self.ArmyItemPrefab, self.campParent, self.camp, function(go)
            self.camp:Init();
            self.camp:InitArmy(hero1,count1,ourpart);
        end );
    else
        self.camp:InitArmy(hero1,count1,ourpart);
    end
    if(self.middleTroops == nil)then
        self.middleTroops = UIBattleReportCountArmyItem.new();
         GameResFactory.Instance():GetUIPrefab(self.ArmyItemPrefab, self.middleTroopsParent, self.middleTroops, function(go)
            self.middleTroops:Init();
            self.middleTroops:InitArmy(hero2,count2,ourpart);
        end );
    else
        self.middleTroops:InitArmy(hero2,count2,ourpart);
    end
    if(self.vanguard == nil)then
        self.vanguard = UIBattleReportCountArmyItem.new();
        GameResFactory.Instance():GetUIPrefab(self.ArmyItemPrefab, self.vanguardParent, self.vanguard, function(go)
            self.vanguard:Init();
            self.vanguard:InitArmy(hero3,count3,ourpart);
        end );
    else
        self.vanguard:InitArmy(hero3,count3,ourpart);
    end    
    self:SetResult(battleresult);
end

--设置是否胜利
function UIBattleReportCountArmy:SetResult(result)
    self.Result.sprite = GameResFactory.Instance():GetResSprite(BattleReportService:Instance():GetResultSpriteFlag(result));
end

return UIBattleReportCountArmy
