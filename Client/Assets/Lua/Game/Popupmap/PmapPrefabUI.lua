-- region *.lua
-- Date
local UIBase = require("Game/UI/UIBase");
local PmapPrefab = class("PmapPrefab", UIBase)

function PmapPrefab:ctor()

    PmapPrefab.super.ctor(self)

    self.chief = nil;
    self.name = nil;
    self.cityName = nil;
    self.Pic = nil;
    self.picPath = nil;
    self.button = nil;
    self.coordX = nil;
    self.coordy = nil;
    self.tiledID = nil;
    self.bgImage = nil;
end


function PmapPrefab:DoDataExchange()

    self.chief = self:RegisterController(UnityEngine.Transform, "chief")
    self.name = self:RegisterController(UnityEngine.UI.Text, "Image/name")
    self.cityName = self:RegisterController(UnityEngine.UI.Text, "Image/cityname")
    self.Pic = self:RegisterController(UnityEngine.UI.Image, "Image")
    self.button = self:RegisterController(UnityEngine.UI.Button, "button")
    self.bgImage = self:RegisterController(UnityEngine.UI.Image, "bgImage")
end

function PmapPrefab:DoEventAdd()

    self:AddListener(self.button, self.OnClickbuttonBtn)

end


function PmapPrefab:OnShow()
    self.bgImage.gameObject:SetActive(false)
end

function PmapPrefab:SetPmapPrefabMessage(data)

    self.coordx = data.Coordinatex
    self.coordy = data.Coordinatey
    self.tiledID = MapService:Instance():GetTiledIndex(self.coordx, self.coordy)
    self.cityName.text = data.Name .. " LV." .. data.level
    if data.CityType == 4 or data.CityType == 5 or data.CityType == 6 then
        self.Pic.sprite = GameResFactory.Instance():GetResSprite("battlebutton");
        self.gameObject.transform.localScale = Vector3.New(1, 1.1, 0)
    else
        self.Pic.sprite = GameResFactory.Instance():GetResSprite("march1");
        self.gameObject.transform.localScale = Vector3.New(1, 1, 0)
    end
    self.chief.gameObject:SetActive(false)
    self.name.gameObject:SetActive(false)
    local otherWD = BuildingService:Instance():GetBeOwnedWildCityList();
    self.cityName.color = Color.white
    for k, v in pairs(otherWD._list) do
        if v.index == self.tiledID then
            if v.occupyLeagueId == PlayerService:Instance():GetLeagueId() then
                self.cityName.color = Color.blue
            else
                self.cityName.color = Color.red
            end
        end
    end
end

function PmapPrefab:OnClickbuttonBtn()
    self.transform.parent.parent.parent:GetChild(2).gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = self.cityName.text
    self.transform.parent.parent.parent:GetChild(2).gameObject:GetComponent(typeof(UnityEngine.UI.Text)).color = Color.white
    local otherWD = BuildingService:Instance():GetBeOwnedWildCityList();
    self.transform.parent.parent.parent:GetChild(3).gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = ""
    for k, v in pairs(otherWD._list) do
        if v.index == self.tiledID then
            self.transform.parent.parent.parent:GetChild(3).gameObject:GetComponent(typeof(UnityEngine.UI.Text)).text = "占领同盟:" .. v.occupyLeagueName;
            if v.occupyLeagueId == PlayerService:Instance():GetLeagueId() then
                self.cityName.color = Color.blue
                self.transform.parent.parent.parent:GetChild(3).gameObject:GetComponent(typeof(UnityEngine.UI.Text)).color = Color.blue
                self.transform.parent.parent.parent:GetChild(2).gameObject:GetComponent(typeof(UnityEngine.UI.Text)).color = Color.blue
            else
                self.cityName.color = Color.red
                self.transform.parent.parent.parent:GetChild(3).gameObject:GetComponent(typeof(UnityEngine.UI.Text)).color = Color.red
                self.transform.parent.parent.parent:GetChild(2).gameObject:GetComponent(typeof(UnityEngine.UI.Text)).color = Color.red
            end
        end
    end

    local baseClass = UIService:Instance():GetUIClass(UIType.UIPmap);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIPmap);
    if baseClass ~= nil and isopen == true then
        baseClass:ChangeInputField(self.coordx, self.coordy)
        baseClass:MoveToClickCity(self.coordx, self.coordy)
        baseClass:SetPmapCityScrollFalse()
    end
    self.bgImage.gameObject:SetActive(true)  
end

function PmapPrefab:SetBgPicFalse()
    self.bgImage.gameObject:SetActive(false)
end

return PmapPrefab