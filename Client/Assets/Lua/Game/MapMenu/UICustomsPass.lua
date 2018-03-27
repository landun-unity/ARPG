--[[
    关卡
--]]
local UIBase= require("Game/UI/UIBase");
local UICustomsPass=class("UICustomsPass",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");

--构造函数
function UICustomsPass:ctor()
    UICustomsPass.super.ctor(self);
    self.position = nil;
    self.stateText = nil;
    self.nameText = nil;
    self.woodNum = nil;
    self.stoneNum = nil;
    self.ironNum = nil;
    self.foodNum = nil;
    self.destroy = nil;
    self.siege = nil;
    self.grideNum = nil;
end

--初始化
function UICustomsPass:DoDataExchange()
    self.position = self:RegisterController(UnityEngine.UI.Text,"FortName/place/Coord");
    self.stateText = self:RegisterController(UnityEngine.UI.Text,"FortName/place/roomText");
    self.nameText = self:RegisterController(UnityEngine.UI.Text,"FortName/place/roomText1");
    self.woodNum = self:RegisterController(UnityEngine.UI.Text,"BottomImg/resourceWoodImg/numText");
    self.stoneNum = self:RegisterController(UnityEngine.UI.Text,"BottomImg/resourceIronImg/numText");
    self.ironNum = self:RegisterController(UnityEngine.UI.Text,"BottomImg/resourceStoneImg/numText");
    self.foodNum = self:RegisterController(UnityEngine.UI.Text,"BottomImg/resourceFoodImg/numText");
    self.destroy = self:RegisterController(UnityEngine.UI.Text,"BottomImg/FirstImg/moneyNum");
    self.siege = self:RegisterController(UnityEngine.UI.Text,"BottomImg/SendImg/moneyNum");
    self.grideNum = self:RegisterController(UnityEngine.UI.Text,"FortName/landGrade/Num");
end

--加载资源
function UICustomsPass:ShowTiled(tiled)
    local resource = tiled:GetResource();
    local positionx = tiled:GetX();
    local positiony = tiled:GetY();
--    local region = tiled:GetRegion();
--    local state = region.State;
--    local name = region.Name;
    local thewoodNum = resource.FirstSeizedWood;
    local thestoneNum = resource.FirstSeizedStone;
    local theironNum = resource.FirstSeizedIronOre;
    local thefoodNum = resource.FirstSeizedFood;
    local thedestroy = resource.AnnihilationRankGold;
    local thesiege = resource.DemolitionRankGold;
    self.woodNum.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text= thewoodNum;
    self.stoneNum.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text= thestoneNum;
    self.ironNum.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text= theironNum;
    self.foodNum.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text= thefoodNum;
    self.destroy.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text= thedestroy;
    self.siege.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text= thesiege;
--    self.stateText.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text=state;
--    self.nameText.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text=name;
    self.position.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text= positionx .. " , " .. positiony;
    --刷土地等级
    local gride = resource.TileLv;
    self.grideNum.gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text="Lv."..gride; 
end

return UICustomsPass;
