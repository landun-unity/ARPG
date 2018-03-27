--[[游戏主界面]]

local UIBase= require("Game/UI/UIBase");
local UIBattleReportCountArmyItem=class("UIBattleReportCountArmyItem",UIBase);
local List = require("common/List");
local HeroData = require("Game/Table/model/DataHero")

function UIBattleReportCountArmyItem:ctor()
    UIBattleReportCountArmyItem.super.ctor(self)
    self.commonKill = nil;
    self.SkillKill = nil;
    --self.unallocated = nil;
    --self.blackBg= nil;

    self.leftIsMyArmyImage = nil;
    self.rightIsMyArmyImage = nil;
    self.Releaseskills = nil;
    self.save = nil;
    self.Loss = nil;
    self.wounded = nil;
    self.Allwounded = nil;

    self.cardParent = nil;
    self.cardObj = nil;
    self.uiBattleReportItemArmy = nil;
    self.isGray = false;
end

--注册控件
function UIBattleReportCountArmyItem:DoDataExchange()
    --self.unallocated = self:RegisterController(UnityEngine.Transform,"General/unallocated")
    --self.blackBg = self:RegisterController(UnityEngine.Transform,"General/BlackBg")
    self.leftIsMyArmyImage = self:RegisterController(UnityEngine.UI.Image,"HeroNegative/LeftIsMyArmy");
    self.rightIsMyArmyImage = self:RegisterController(UnityEngine.UI.Image,"HeroNegative/RightIsMyArmy");
    self.commonKill = self:RegisterController(UnityEngine.UI.Text,"commonKill")
    self.SkillKill = self:RegisterController(UnityEngine.UI.Text,"SkillKill")
    self.Releaseskills = self:RegisterController(UnityEngine.UI.Text,"Releaseskills")
    self.save = self:RegisterController(UnityEngine.UI.Text,"save")
    self.Loss = self:RegisterController(UnityEngine.UI.Text,"Loss")
    self.wounded = self:RegisterController(UnityEngine.UI.Text,"wounded")  
    self.Allwounded = self:RegisterController(UnityEngine.UI.Text,"Allwounded")
    self.cardParent = self:RegisterController(UnityEngine.Transform,"General/CardParent");
end

function UIBattleReportCountArmyItem:DoEventAdd()

end

--初始化
function UIBattleReportCountArmyItem:InitArmy(heroinfo,coutinfo,ourpart)
    if self.cardObj == nil then
            local mdata = DataUIConfig[UIType.UIBattleReportItemArmy];
            local uiBase = require(mdata.ClassName).new();
            GameResFactory.Instance():GetUIPrefab(mdata.ResourcePath, self.cardParent, uiBase, function(go)
                uiBase:Init();
                if uiBase.gameObject then
                    if  heroinfo~= nil then
                        uiBase:SetInfo(heroinfo.heroid,heroinfo.cardLevel,0,heroinfo.advanceTimes);
                    end
                    uiBase:HideCardSoldiers(false);
                    self.cardObj = uiBase.gameObject;
                    self.uiBattleReportItemArmy = uiBase;
                    uiBase.gameObject:SetActive(false);
                end
            end );
    else
        if  heroinfo~= nil then
            self.uiBattleReportItemArmy:SetInfo(heroinfo.heroid,heroinfo.cardLevel,0,heroinfo.advanceTimes);
            self.uiBattleReportItemArmy:HideCardSoldiers(true);
        end
    end

    if heroinfo ~= nil then  --是否有派兵 test
        --self.unallocated.gameObject:SetActive(false);
        self.cardObj.gameObject:SetActive(true);    
    else
        --self.unallocated.gameObject:SetActive(true);
        self.cardObj.gameObject:SetActive(false);
    end

    local spriteName = "";
    if ourpart == true then
        spriteName = "March11";
    else
        spriteName = "March9";
    end
    self.leftIsMyArmyImage.sprite = GameResFactory.Instance():GetResSprite(spriteName);
    self.rightIsMyArmyImage.sprite = GameResFactory.Instance():GetResSprite(spriteName);

    if coutinfo ~= nil then        --是否有派兵 test
        self.commonKill.text = coutinfo.normalDamage
        self.SkillKill.text = coutinfo.SkillDamage
        self.Releaseskills.text = coutinfo.DoSkillTimes
        if(coutinfo.helpNum>=0) then
            self.save.text = coutinfo.helpNum
        else
             self.save.text = tostring(-coutinfo.helpNum)
        end
        self.Loss.text = coutinfo.losseNum
        self.wounded.text = coutinfo.theWoundNum
        self.Allwounded.text = coutinfo.woundNumSum
    else
        self.commonKill.text = ""
        self.SkillKill.text = ""
        self.Releaseskills.text = ""
        self.save.text = ""
        self.Loss.text = ""
        self.wounded.text = ""
        self.Allwounded.text = ""
    end
end

return UIBattleReportCountArmyItem
