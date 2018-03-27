--[[
    筑城界面
--]]

local UIBase = require("Game/UI/UIBase");
local UIBuild = class("UIBuild",UIBase);
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
local MapLoad = require("Game/Map/MapLoad")

--构造函数
function UIBuild:ctor()
    UIBuild.super.ctor(self);
    self.curTiledIndex = nil;
    self.fortBtn = nil;
    self.fortificationBtn = nil;
    self.returnBtn = nil;
    self.fortificationButton = nil;
    self.CitySubImage1 = nil ;
    self.CitySubImage = nil;
    self.isHaveGivingUpLand = false;    --点击的周围地块中是否有正在放弃中的
    self.FortressImage1 = nil;
end

--注册控件
function UIBuild:DoDataExchange()
  self.fortBtn = self:RegisterController(UnityEngine.UI.Button,"Fortification/fortificationFortressButton");
  self.fortificationBtn = self:RegisterController(UnityEngine.UI.Button,"Fortification/fortificationPartCityButton");
  self.returnBtn = self:RegisterController(UnityEngine.UI.Button,"")
  self.fortificationButton = self:RegisterController(UnityEngine.UI.Button,"Fortification/fortificationButton")
  self.CitySubImage1 = self:RegisterController(UnityEngine.UI.Image,"Fortification/fortificationPartCityButton/CitySubImage1");
  self.CitySubImage = self:RegisterController(UnityEngine.UI.Image,"Fortification/fortificationPartCityButton/CitySubImage")
  self.FortressImage1 = self:RegisterController(UnityEngine.UI.Image,"Fortification/fortificationFortressButton/FortressImage1");
end

--注册点击事件
function UIBuild:DoEventAdd()
  self:AddListener(self.fortBtn,self.OnClickFortBtn);
  self:AddListener(self.fortificationBtn,self.OnClickFortificationBtn);
  self:AddListener(self.returnBtn,self.OnClickReturnBtn);
  self:AddListener(self.fortificationButton,self.OnClickFortificationButton)
end

function UIBuild:OnShow(curTiledIndex)
    self.isHaveGivingUpLand = false;
    self.curTiledIndex = curTiledIndex;
    self:JudgeCityCondition();
    self:SetBuildPosition()
    self:IsHideFortIcon();
end

function UIBuild:OnClickFortificationButton()
    UIService:Instance():ShowUI(UIType.UIFortificationExplain);
end

function UIBuild:OnClickReturnBtn()
    UIService:Instance():HideUI(UIType.UIBuild);
end

--建要塞点击事件
function UIBuild:OnClickFortBtn()
    if PlayerService:Instance():CanCreateFortBaseFameValue() == false and PlayerService:Instance():GetFortCount()  < 30 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 153);
        return
    end

    if PlayerService:Instance():GetFortCount() > 30 then 
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 154);
        self.fortBtn.interactable = false
        return
    else
        self.fortBtn.interactable = true
    end


    if self:CheckTiledIsForCity() == true then
        UIService:Instance():HideUI(UIType.UIBuild);
        UIService:Instance():ShowUI(UIType.UIFortOkBox,self.curTiledIndex)
        return;
    end

    UIService:Instance():HideUI(UIType.UIBuild);
    UIService:Instance():ShowUI(UIType.UIFort, self.curTiledIndex);
end

function UIBuild:IsHideFortIcon()
    if PlayerService:Instance():CanCreateFortBaseFameValue() == false or PlayerService:Instance():GetFortCount()  > 30 then
        self.FortressImage1.gameObject:SetActive(true);
    else
        self.FortressImage1.gameObject:SetActive(false);
    end
end


--建分城点击事件
function UIBuild:OnClickFortificationBtn()
    if PlayerService:Instance():CanCreateSubCityBaseFameValue() == false and PlayerService:Instance():GetAllSubCityCount() < 9 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 151);
        return;
    end

    if self:CheckTiledIsForCity() == false then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 150);
        return;
    end

    if PlayerService:Instance():GetAllSubCityCount() >= 9 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 152);
        return;
    end

    if self.isHaveGivingUpLand == true then 
        UIService:Instance():ShowUI(UIType.UICueMessageBox,1550);
        return;
    end

    UIService:Instance():HideUI(UIType.UIBuild);
    UIService:Instance():ShowUI(UIType.UIPointsCityPanel, self.curTiledIndex);
end

function UIBuild:SetBuildPosition()
     if self:CheckTiledIsForCity() == true then
        self.fortificationBtn.gameObject.transform.localPosition = Vector3.New(0.249, 60, 0);
        self.fortBtn.gameObject.transform.localPosition = Vector3.New(-2.58, -105.6, 0);
    else
        self.fortBtn.gameObject.transform.localPosition = Vector3.New(0.249, 60, 0);
        self.fortificationBtn.gameObject.transform.localPosition = Vector3.New(-2.58, -105.6, 0);
    end
end

-- 判断是否可以建分城
function UIBuild:JudgeCityCondition()
    -- 声望限制（前提未达到最大分城数）
    -- 地块限制
    -- 分城数量限制（不影响置灰）
    local isGray = false;

    if PlayerService:Instance():CanCreateSubCityBaseFameValue() == false and PlayerService:Instance():GetAllSubCityCount() < 9 then
        isGray =true;
    end

    if self:CheckTiledIsForCity() == false then
        isGray = true;
    end

    if isGray == false then
        --self.fortificationBtn.interactable = true
        if self.isHaveGivingUpLand == false then
            self.CitySubImage.gameObject:SetActive(true);
            self.CitySubImage1.gameObject:SetActive(false);
        else
            self.CitySubImage1.gameObject:SetActive(true);
            self.CitySubImage.gameObject:SetActive(false);
        end
    else
        --self.fortificationBtn.interactable = false;
        self.CitySubImage1.gameObject:SetActive(true);
        self.CitySubImage.gameObject:SetActive(false);
    end
end

-- 判断是否拥有3*3资源地 地上不能有建筑物
function UIBuild:CheckTiledIsForCity()
    local x, y = MapService:Instance():GetTiledCoordinate(self.curTiledIndex);
    for i = x - 1, x + 1 do
        for j = y - 1, y + 1 do
            if x < 0 or y < 0 or x >= MapLoad:GetWidth() or y >= MapLoad:GetHeight() then
                return false;
            end
            local tempIndex = MapService:Instance():GetTiledIndex(i, j);
            local tiled = MapService:Instance():GetTiledByIndex(tempIndex);
            if tiled == nil then
                return false;
            end
            if tiled.tiledInfo ~= nil then
                if PlayerService:Instance():GetLocalTime() < tiled.tiledInfo.giveUpLandTime then
                    self.isHaveGivingUpLand = true;
                end
            end
            local myPlayerId = PlayerService:Instance():GetPlayerId();
            if tiled.tiledInfo == nil or tiled.tiledInfo.ownerId ~= myPlayerId then
                return false;
            end
            if tiled:GetBuilding() ~= nil or tiled:GetTown() ~= nil then
                return false
            end
        end
    end
    return true
end

return UIBuild;