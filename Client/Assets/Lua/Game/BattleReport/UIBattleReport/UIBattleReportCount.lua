--[[游戏主界面]]

local UIBase= require("Game/UI/UIBase");
local UIService=require("Game/UI/UIService");
local UIBattleReportCount=class("UIBattleReportCount",UIBase);
local UIType=require("Game/UI/UIType");
local UIConfigTable=require("Game/Table/model/DataUIConfig");
local UIBattleReportCountArmy = require("Game/BattleReport/UIBattleReport/UIBattleReportCountArmy");
function UIBattleReportCount:ctor()
    UIBattleReportCount.super.ctor(self)
    self.ArmyPrefab = UIConfigTable[UIType.UIBattleReportCountArmy].ResourcePath;
    self.Parent = nil;
    self.OurPartUI = nil;
    self.EnemyUI = nil;
end

--注册控件
function UIBattleReportCount:DoDataExchange()
    self.backBtn = self:RegisterController(UnityEngine.UI.Button,"backBtn")
    self.Parent = self:RegisterController(UnityEngine.Transform,"ScrollRect/Parent")
end

--注册控件点击事件
function UIBattleReportCount:DoEventAdd()
    self:AddListener(self.backBtn,self.OnClickbackBtn)
end

--点击关闭按钮逻辑
function UIBattleReportCount:OnClickbackBtn()
    UIService:Instance():HideUI(UIType.UIBattleReportCount)
end

--参数  1 攻击方英雄列表 2 攻击方统计 3 攻击方结果 4 防御方英雄列表 5 防御方统计 6 防御方结果
function UIBattleReportCount:OnShow(param)
    if(self.OurPartUI == nil)then
        self.OurPartUI = UIBattleReportCountArmy.new();
        GameResFactory.Instance():GetUIPrefab(self.ArmyPrefab,self.Parent,self.OurPartUI,function (go)
            self.OurPartUI:Init();
            --self.OurPartUI:InitOurPart(true);
            self.OurPartUI:InitArmy(param[1],param[2],param[3],true);
        end);
    else
        self.OurPartUI:InitArmy(param[1],param[2],param[3],true);
    end
    if(self.EnemyUI == nil)then
        self.EnemyUI = UIBattleReportCountArmy.new();
        GameResFactory.Instance():GetUIPrefab(self.ArmyPrefab,self.Parent,self.EnemyUI,function (go)
            self.EnemyUI:Init();
            --self.EnemyUI:InitOurPart(false);
            self.EnemyUI:InitArmy(param[4],param[5],param[6],false);
        end);
    else
        self.EnemyUI:InitArmy(param[4],param[5],param[6],false);
    end
end

return UIBattleReportCount
