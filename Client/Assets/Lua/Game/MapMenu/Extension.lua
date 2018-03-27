local UIBase = require("Game/UI/UIBase")
--local MapService = require("Game/Map/MapService")
local UIService=require("Game/UI/UIService")
local UIType=require("Game/UI/UIType")
local CityTiled = require("Game/Build/Building/CityTiled")
local MapLoad = require("Game/Map/MapLoad")
local OperatorType = require("Game/Map/Operator/OperatorType")
local MainCityManage = require("Game/Build/Building/MainCityManage")
local Extension = class("Extension",UIBase)

function Extension:ctor()
	Extension._instance = self;
	Extension.super.ctor(self);
	self.exitBtn = nil;
	self.extensionText = nil;
    --城中心的tiled
	self.tiled = nil;

	self.cityTiledTable = {};

    self.building = nil;
end

function Extension:Instance()
	return Extension._instance;
end

function Extension:RegisterAllNotice()
    --扩建消息
    self:RegisterNotice(L2C_Facility.CityExpandRespond, self.ShowExplainBtn);
end

function Extension:DoDataExchange()
	self.exitBtn = self:RegisterController(UnityEngine.UI.Button,"ExitBtn");
	self.extensionText = self:RegisterController(UnityEngine.UI.Text, "Extension/TexExtension/Text")
	--MapService:Instance():EnterOperator(OperatorType.ExtensionClick);
end

--注册控件点击事件
function Extension:DoEventAdd()
	self:AddListener(self.exitBtn,self.OnClickExitBtn);
end

function Extension:OnClickExitBtn()
	MapService:Instance():EnterOperator(OperatorType.ZoomOut);
	UIService:Instance():HideUI(UIType.Extension);
    local param = {};
    param[0] = self.building
	UIService:Instance():ShowUI(UIType.UIMainCity, param);
end

function Extension:OnShow(tiled)
	self.tiled = tiled;

    if self.tiled:GetBuilding() == nil then
        self.building = self.tiled:GetTown()._building;
    else
        self.building = self.tiled:GetBuilding();
    end
	self.extensionText.text = self.building._canExpandTimes;
end

--有剩余次数刷新次数
function Extension:ShowExplainBtn()
    self.extensionText.text = self.building._canExpandTimes;
    self:_RefreshMainCity(self.tiled);
end

--坐标转化(单)
function Extension:ConvertIndex(x, y)
    if x == nil or y == nil then
        return nil;
    end
    if x < 0 or y < 0 then
        return nil;
    end
    if x > 4 or y > 4 then
        return nil;
    end

    return x * 5 + y;
end

-- --判断资源
-- function Extension:ConvertIndex(x, y)
--     if x == nil or y == nil then
--         return nil;
--     end

--     return x * 5 + y;
-- end

--扩建城市块
function Extension:ExtendTiled(extileindex)
    if self.building._canExpandTimes == 0 then
    	return;
    end
    local buildingtiledindex = self.building._tiledId;
    if extileindex == nil and buildingtiledindex == nil then
    	return;
    end
    --print("计算:"..extileindex.."  "..buildingtiledindex);
    local dis = extileindex - buildingtiledindex;
    if dis > MapLoad:GetWidth() + 1 or 
        dis < - (MapLoad:GetWidth() + 1) or
    (1 < dis and dis < MapLoad:GetWidth() -1) or
    (dis < -1 and dis > -(MapLoad:GetWidth() -1)) then
        return;
    end
    --print(dis);
    local x = math.floor(dis / MapLoad:GetWidth());
    local y = dis % MapLoad:GetWidth();
   -- print(x, y)
    if y == (MapLoad:GetWidth() - 1) then
        x = x + 1;
        y = - dis / dis;
    end

    if self.building:GetCityTiledByIndex(self:ConvertIndex(x * 2 + 2, y * 2 + 2)) ~= nil then
        --print(self:ConvertIndex(x * 2 + 2, y * 2 + 2));
		return;
	else
		self:_PlusTiled(x * 2 + 2, y * 2 + 2);
		local param = {};
		param.buildingId = self.building._id;
		param.tiledIndex = extileindex;
		param.canExpandTime = self.building._canExpandTimes;
		--print(#self.cityTiledTable);
		param.cityTiled = self.cityTiledTable;
		UIService:Instance():ShowUI(UIType.UIExtensionConfirm, param);
        self.cityTiledTable = {};
	end
end

--判断周围城市块
function Extension:_PlusTiled(x, y)
	--print(x, y)
	self:_CreatNewTiled(self:ConvertIndex(x, y), tiledIndex);
	local up = self.building:GetCityTiledByIndex(self:ConvertIndex(x, y-2));
    local down = self.building:GetCityTiledByIndex(self:ConvertIndex(x, y+2));
    local left = self.building:GetCityTiledByIndex(self:ConvertIndex(x+2, y));
    local right = self.building:GetCityTiledByIndex(self:ConvertIndex(x-2, y));
    if down ~= nil then
         self:_CreatNewTiled(self:ConvertIndex(x, y + 1));
    end
    if left ~= nil then
         self:_CreatNewTiled(self:ConvertIndex(x + 1, y));
    end
    if up ~= nil then
         self:_CreatNewTiled(self:ConvertIndex(x, y - 1));
    end
    if right ~= nil then
         self:_CreatNewTiled(self:ConvertIndex(x - 1, y));
    end
    --self:_RefreshMainCity(self.tiled);
end

function Extension:_RefreshMainCity(tiled)
	-- MainCityManage:Instance():_HideTiled(tiled);
	-- MainCityManage:Instance():_ShowTiledLayer(tiled);
end

--根据索引添加tiled
function Extension:_CreatNewTiled(index)
	if index == 6 or index == 7 or index == 8 or
		index == 11 or index == 12 or index == 13 or
		 index == 16 or index == 17 or index == 18 then
		 return;
	end
	--print(index);
	local cityTiled = CityTiled.new();
    cityTiled:Init(index, 1, 33, math.random(1, 3));
    self:_SetCityTiled(index, cityTiled);
    --self.building:SetCityTiled(index, cityTiled);
end

function Extension:_SetCityTiled(index, cityTiled)
    self.cityTiledTable[index] = cityTiled;
end

return Extension