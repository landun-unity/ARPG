--[[
	producer:ww
	data:16-12-26
]]

local UIBase = require("Game/UI/UIBase");
local UILigeanceAdd = class("UILigeanceAdd",UIBase);
local UIType = require("Game/UI/UIType");
local UIService = require("Game/UI/UIService");
local LigeanceType = require("Game/PersonalPower/LigeanceType");
local MapService = require("Game/Map/MapService");
local CommonService = require("Game/Common/CommonService");
local PlayerService = require("Game/Player/PlayerService");
local DataBuilding = require("Game/Table/model/DataBuilding");

function UILigeanceAdd:ctor()
	UILigeanceAdd.super.ctor(self);
	self._Tiled = nil;
	self._TiledType = nil;
	self._tiledCorrd = {};
	self._Image_Wood = nil;
	self._Image_Stone = nil;
	self._Image_Iron = nil;
	self._Image_Grain = nil;
	self._Text_NoneRes = nil;
	self._Text_Type = nil;
	self._Text_Name = nil;
	self._Text_Durable = nil;
	self._Text_Coord = nil;
	self._Button_Coord = nil;

end

function UILigeanceAdd:SetTiledType(type)
	-- body
	self._TiledType = type;
end

function UILigeanceAdd:GetTiledType()
	-- body
	return self._TiledType;
end


function UILigeanceAdd:DoDataExchange()
	self._Image_Wood = self:RegisterController(UnityEngine.UI.Image,"ResourceObj/TimberImage");
	self._Image_Stone = self:RegisterController(UnityEngine.UI.Image,"ResourceObj/StoneImage");
	self._Image_Iron = self:RegisterController(UnityEngine.UI.Image,"ResourceObj/IronImage");
	self._Image_Grain = self:RegisterController(UnityEngine.UI.Image,"ResourceObj/GrainImage");
	self._Image_Copper = self:RegisterController(UnityEngine.UI.Image,"ResourceObj/MoneyImage");
	self._Text_NoneRes = self:RegisterController(UnityEngine.UI.Text,"ResourceObj/Text");
	self._Text_Type = self:RegisterController(UnityEngine.UI.Text,"Text");
	self._Text_Name = self:RegisterController(UnityEngine.UI.Text,"Image/Text");
	self._Text_Coord = self:RegisterController(UnityEngine.UI.Text,"CoordImage/Text");
	self._Text_Durable = self:RegisterController(UnityEngine.UI.Text,"Text2");
	self._Button_Coord = self:RegisterController(UnityEngine.UI.Button,"CoordImage");
end

function UILigeanceAdd:DoEventAdd()
	self:AddListener(self._Button_Coord,self.CoordButtonOnClick);
end

function UILigeanceAdd:ShowText(tiled)
	-- body	
	if tiled==nil then
		return
	end
	self._Tiled = tiled;
	local building  = BuildingService:Instance():GetBuilding(tiled.buildingId);
	-- if building == nil then 
	-- 	return 
	-- end

	if building ~= nil then
		if building._name ~= nil then
			self._Text_Name.text = building._name;
		end
	elseif tiled.buildingIdForTown ~= 0 or nil then
		local buildingForTown = BuildingService:Instance():GetBuilding(tiled.buildingIdForTown);
		if buildingForTown._name ~= nil then
			self._Text_Name.text = buildingForTown._name;
		else
			self._Text_Name.text = DataBuilding[tiled.buildingTableIdForTown].Name;
		end

	else
		self._Text_Name.text = "领地";
	end	


	if self._TiledType == LigeanceType.MainCity then
		self._Text_Type.text = "主城";
	elseif self._TiledType == LigeanceType.Town then
		self._Text_Type.text ="个人城区";
	elseif self._TiledType == LigeanceType.SubCity then 
		self._Text_Type.text = "分城";
	elseif self._TiledType == LigeanceType.Fort then
		self._Text_Type.text = "要塞";
	elseif self._TiledType == LigeanceType.DefenseTown then
		self._Text_Type.text = "守军城区";
	else
		self._Text_Type.text = "LV"..DataTile[tiled.tiledTableId].TileLv;
	end
	
	self._tiledCorrd.x,self._tiledCorrd.y = MapService:Instance():GetTiledCoordinate(tiled.tiledId);
	self._Text_Coord.text = "("..self._tiledCorrd.x..","..self._tiledCorrd.y..")";
--	local tiledDurableInfo = PlayerService:Instance():GetTiledDurableByIndex(tiled.tiledId);
--	local curDurableVal = tiled.curDurableVal;
--	local maxDurableVal = tiled.maxDurableVal;
    local curDurableVal = MapService:Instance():GetMyTiledDura(tiled.tiledId);
    local maxDurableVal = MapService:Instance():GetMyTiledMaxDura(tiled.tiledId);
	self._Text_Durable.text = curDurableVal.."/"..maxDurableVal;
end

function UILigeanceAdd:SetTypeIcon(tiled)
	-- body	
	self._Image_Wood.gameObject:SetActive(false);
	self._Image_Stone.gameObject:SetActive(false);
	self._Image_Iron.gameObject:SetActive(false);
	self._Image_Grain.gameObject:SetActive(false);
	self._Image_Copper.gameObject:SetActive(false);
	if self._TiledType > 7 then 
		if DataTile[tiled.tiledTableId].Wood ~= 0 then
			self._Image_Wood.gameObject:SetActive(true);
		elseif DataTile[tiled.tiledTableId].Stone ~= 0 then
			self._Image_Stone.gameObject:SetActive(true);
		elseif DataTile[tiled.tiledTableId].Iron ~= 0 then
			self._Image_Iron.gameObject:SetActive(true);
		elseif DataTile[tiled.tiledTableId].Food ~= 0 then
			self._Image_Grain.gameObject:SetActive(true);
		end
	elseif self._TiledType == 5 then
		self._Image_Copper.gameObject:SetActive(true);
	else
		self._Text_NoneRes.gameObject:SetActive(true);
	end
end

function UILigeanceAdd:CoordButtonOnClick()
	-- body
	-- CommonService:Instance():ShowOkOrCancle(
	-- 	self,function()  self:CommonOk() end,
	-- 	function() self:CommonCancle() end,
	-- 	"是否跳转到坐标("..self._tiledCorrd.x..","..self._tiledCorrd.y..")",
	-- 	"跳转到当前坐标后,会关闭当前界面回到大地图",
	-- 	"确认",
	-- 	"取消")
	-- local x, y = MapService:Instance():GetTiledCoordinate(self.info._tileIndex)
    self.temp = {};
    self.temp[1] = "是否跳转到坐标<color=#599ba9FF>("..self._tiledCorrd.x..","..self._tiledCorrd.y..")</color>";
    self.temp[2] = self;
    self.temp[3] = self.ConfirmGoto;
    UIService:Instance():ShowUI(UIType.CommonGoToPosition,self.temp)

end
--获取格子耐久

function UILigeanceAdd:ConfirmGoto()
	-- body
	local tiledId =  self._Tiled.tiledId;
	
	MapService:Instance():ScanTiled(tiledId);
	--UIService:Instance():ShowUI(UIType.UIGameMainView);
	UIService:Instance():HideUI(UIType.UIPersonalPower);
	if UIService:Instance():GetOpenedUI(UIType.LeagueMemberUI) then
		UIService:Instance():HideUI(UIType.LeagueMemberUI);
	end
	if UIService:Instance():GetOpenedUI(UIType.LeagueExistUI) then
		UIService:Instance():HideUI(UIType.LeagueExistUI);
	end
	if UIService:Instance():GetOpenedUI(UIType.UIPmap) then
		UIService:Instance():HideUI(UIType.UIPmap)
	end
	if UIService:Instance():GetOpenedUI(UIType.PmapMateInfoUI) then
		UIService:Instance():HideUI(UIType.PmapMateInfoUI)
	end
end


function UILigeanceAdd:CommonCancle()
	-- body	
	UIService:Instance():HideUI(UIType.CommonOkOrCancle);
end

return UILigeanceAdd;