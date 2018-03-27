
local UIBase = require("Game/UI/UIBase");
local UIMateInfo = class("UIMateInfo", UIBase)
require("Game/Table/model/DataTile")
local LeagueTitleType = require("Game/League/LeagueTitleType")
require("Game/Table/model/DataBuilding")
-- local _tempDic = nil;
function UIMateInfo:ctor()
    UIMateInfo.super.ctor(self);

    self.data = nil;
    self.tiledId = nil
    self.id = nil;
    self.x = nil;
    self.y = nil;
    self.name = nil;
    self.InfoBtn = nil;
    self.ShowBtn = nil;
    self.pos = nil;
    self.bgImage = nil;
    self.canshow = false
    self.id = nil;
    self.publistID = nil;
    self.description = nil;
    self.publistName = nil;
    self.title = nil;
    self.tiledLevel = nil;
end

function UIMateInfo:DoDataExchange()

    self.pos = self:RegisterController(UnityEngine.UI.Text, "Pos");
    self.name = self:RegisterController(UnityEngine.UI.Text, "Name");
    self.ShowBtn = self:RegisterController(UnityEngine.UI.Button, "Button");
    self.InfoBtn = self:RegisterController(UnityEngine.UI.Button, "Image");
    self.mainCity = self:RegisterController(UnityEngine.UI.Image, "MainCityImage");
    self.subCity = self:RegisterController(UnityEngine.UI.Image, "barracksImage");
    self.fortCity = self:RegisterController(UnityEngine.UI.Image, "fortressImage");
    self.tiledImage = self:RegisterController(UnityEngine.UI.Image, "PointsCityImage");
    self.bgImage = self:RegisterController(UnityEngine.UI.Image, "bgImage");
end

function UIMateInfo:OnShow()
    self.bgImage.gameObject:SetActive(false)
end


function UIMateInfo:SetBgPicFalse()
    self.bgImage.gameObject:SetActive(false)
end

function UIMateInfo:SetMateInfo(info, _bool)

    self.data = info
    if info == nil then
        return;
    end
    self.show = _bool

    if self.show then
        self.InfoBtn.gameObject:SetActive(true)
    else
        self.InfoBtn.gameObject:SetActive(false)
    end

    if info._fortGrade == nil then
        local x, y = MapService:Instance():GetTiledCoordinate(info.tiledId)
        self.pos.text = x .. "," .. y
        self.x = x
        self.y = y
        if DataBuilding[info.tableId].Type == BuildingType.MainCity then
            self.name.text = PlayerService:Instance():GetName()
            self.mainCity.gameObject:SetActive(true)
            self.subCity.gameObject:SetActive(false)
            self.fortCity.gameObject:SetActive(false)
            self.tiledImage.gameObject:SetActive(false)
        end
        if DataBuilding[info.tableId].Type == BuildingType.SubCity then
            self.name.text = info.name
            self.mainCity.gameObject:SetActive(false)
            self.subCity.gameObject:SetActive(true)
            self.fortCity.gameObject:SetActive(false)
            self.tiledImage.gameObject:SetActive(false)
        end
    else
        -- if info.buildingType == BuildingType.PlayerFort then
        local x, y = MapService:Instance():GetTiledCoordinate(info._tiledId)
        local buliding = BuildingService:Instance():GetBuildingByTiledId(info._tiledId);
        self.pos.text = x .. "," .. y
        self.x = x
        self.y = y
        self.name.text = buliding._name;
        self.mainCity.gameObject:SetActive(false)
        self.subCity.gameObject:SetActive(false)
        self.fortCity.gameObject:SetActive(true)
        self.tiledImage.gameObject:SetActive(false)
        -- end
    end
end

function UIMateInfo:SetMarkInfo(info, _bool)

    self.data = info
    local x, y = MapService:Instance():GetTiledCoordinate(info.coord)
    self.name.text = info.name
    self.show = _bool
    self.pos.text = x .. "," .. y
    self.tiledId = info.coord
    self.x = x
    self.id = info.id
    self.publistID = info.publisherId
    self.tiledLevel = info.tiledLevel;
    self.title = info.title;
    self.y = y
    self.description = info.description
    self.publistName = info.publistName

    if self.show and PlayerService:Instance():GetPlayerTitle() < LeagueTitleType.Officer then
        if PlayerService:Instance():GetPlayerTitle() == LeagueTitleType.Leader or PlayerService:Instance():GetPlayerId() == info.publisherId then
            self.canshow = true
        else
            self.canshow = false
        end
    else
        self.canshow = false
    end


end
function UIMateInfo:DoEventAdd()

    self:AddListener(self.ShowBtn, self.OnClickShowBtn)
    self:AddListener(self.InfoBtn, self.OnClickInfoBtn)

end

function UIMateInfo:OnClickShowBtn()
    local data = { self.x, self.y };
    local baseClass = UIService:Instance():GetUIClass(UIType.UIPmap);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIPmap);
    if baseClass ~= nil and isopen == true then
        baseClass:ChangeInputField(data[1], data[2])
        baseClass:MoveToClickMateAndMark(data[1], data[2])
        baseClass:SetMateInfoFalse()
        baseClass:SetMarkInfoFalse()
    end
    self.bgImage.gameObject:SetActive(true)
end

function UIMateInfo:OnClickInfoBtn()
    self.data = { self.data, self.canshow, self.x, self.y, self.tiledId, self.id, self.description, self.publistName, self.publistID, self.title, self.tiledLevel }
    UIService:Instance():ShowUI(UIType.PmapMateInfoUI, self.data)
end




return UIMateInfo