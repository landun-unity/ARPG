--[[
    标记定位信息
--]]
local UIBase= require("Game/UI/UIBase");
local UISignMainLocate=class("UISignMainLocate",UIBase);        

--构造方法
function UISignMainLocate:ctor()
    UISignMainLocate.super.ctor(self);
    self.BuildingImage = nil;
    self.NameText = nil;
    self.CoordText = nil;
    self._removeBtn = nil;
    self._Btn = nil;
    -- self.tiled = nil;
    self.tiledIndex = nil;
end

function UISignMainLocate:DoDataExchange()
	self.BuildingImage = self:RegisterController(UnityEngine.UI.Image,"BuildingImage");
	self.NameText = self:RegisterController(UnityEngine.UI.Text,"NameText");
	self.CoordText = self:RegisterController(UnityEngine.UI.Text,"CoordText");
	self._removeBtn = self:RegisterController(UnityEngine.UI.Button,"removeBtn");
	self._Btn = self:RegisterController(UnityEngine.UI.Button,"SignBtn");
end

function UISignMainLocate:DoEventAdd()
	self:AddListener(self._removeBtn,self.OnClickremoveBtn);
	self:AddListener(self._Btn,self.OnClickBtn);
end

function UISignMainLocate:SetMainCitySitn(tiled)
    local mainCityTitled = PlayerService:Instance():GetMainCityTiledId();
    local buildingId = BuildingService:Instance():GetBuildingByTiledId(mainCityTitled)._id;
    local building = BuildingService.Instance():GetBuilding(buildingId);
    local buildName = building._name;
    self.tiledIndex = tiled:GetIndex();
    local X = tiled:GetX();
    local Y = tiled:GetY();
    self.CoordText.text = X..","..Y
    self.NameText.text = buildName.."城区Lv.1";
    self.BuildingImage.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("MainCity");
end


function UISignMainLocate:OnClickremoveBtn()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestUndoMainCitySign").new();
    msg:SetMessageId(C2L_Player.RequestUndoMainCitySign);
    msg.tiledIndex = self.tiledIndex;
    NetService:Instance():SendMessage(msg);
    print("取消标记点击事件")
end

function UISignMainLocate:OnClickBtn()
    MapService:Instance():ScanTiled(self.tiledIndex);
end

return UISignMainLocate