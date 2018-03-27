--[[城池]]--
local UIBase= require("Game/UI/UIBase");
local CityObj=class("CityObj",UIBase);        
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");


--构造函数
function CityObj:ctor()
    CityObj.super.ctor(self);
    self.returnBtn = nil;
    self.grid = nil;
    self._uiCityTroopsList = {};
end

-- 当界面显示的时候调用
function CityObj:OnShow(param)
	self:RefreshGrid();
    local parentX = self.grid.localPosition.x;
    self.grid.localPosition = Vector3.New(parentX, 0, 0);
end

function CityObj:DoDataExchange()
    self.returnBtn = self:RegisterController(UnityEngine.UI.Button,"OneBottomImage/CloseButtonNormalImage");
    self.grid = self:RegisterController(UnityEngine.Transform,"OneBottomImage/LeagueBackgroundImage/Grid");
end

function CityObj:DoEventAdd()
    self:AddListener(self.returnBtn,self.OnClickReturnBtn)
end

function CityObj:OnClickReturnBtn()
    UIService:Instance():ShowUI(UIType.UIGameMainView);
	UIService:Instance():HideUI(UIType.CityObj);
end

function CityObj:RefreshGrid()
    if self.transform.gameObject.activeSelf == false then
        return;
    end

    local allBuilding = PlayerService:Instance():GetAllCity();
    local buildingCount = #allBuilding;
    local uiCount = #self._uiCityTroopsList;
    if uiCount > buildingCount then
        for index = buildingCount + 1, uiCount do
            if self._uiCityTroopsList[index].gameObject ~= nil and self._uiCityTroopsList[index].gameObject.activeSelf == true then
                self._uiCityTroopsList[index].gameObject:SetActive(false);
            end
        end
    end

    for index = 1, buildingCount do
        local uiCityTroops = self._uiCityTroopsList[index];
        if uiCityTroops == nil then
            self:CreateUICityTroops(index, allBuilding[index]);
        else
            if uiCityTroops.gameObject.activeSelf == false then
                uiCityTroops.gameObject:SetActive(true);
            end
            uiCityTroops:OnRefreshUIData(self, allBuilding[index]);
        end
    end
end

function CityObj:CreateUICityTroops(index, building)
    local uiCityTroops = require("Game/MapMenu/UICityTroops").new();
	GameResFactory.Instance():GetUIPrefab("UIPrefab/CityTroopsImage", self.grid, uiCityTroops, function(go)
		uiCityTroops:Init();
        uiCityTroops:OnRefreshUIData(self, building);
        self._uiCityTroopsList[index] = uiCityTroops;
	end);
end

function CityObj:MoveToPositionAndCallBack(buildingId, callBack)
    if callBack == nil then
        return;
    end

    for k, v in pairs(self._uiCityTroopsList) do
        if v.gameObject.activeSelf == true and v._building._id == buildingId then
            self:MoveAndCallBack(k, callBack);
            return;
        end
    end
end

function CityObj:MoveAndCallBack(index, callBack)
    if self._uiCityTroopsList[index] == nil or callBack == nil then
        return;
    end

    local newPos = Vector3.New(0, (index - 1) * 260, 0);
    local lt =  self.grid:DOLocalMove( newPos, 0.5)
    lt:OnComplete(self,callBack);
end

return CityObj