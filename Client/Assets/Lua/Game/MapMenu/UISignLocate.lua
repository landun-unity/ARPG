--[[
    标记定位信息
--]]
local UIBase= require("Game/UI/UIBase");
local UISignLocate=class("UISignLocate",UIBase);        

--构造方法
function UISignLocate:ctor()
    UISignLocate.super.ctor(self);
    self.BuildingImage = nil;
    self.NameText = nil;
    self.CoordText = nil;
    self._removeBtn = nil;
    self._Btn = nil;
    -- self.tiled = nil;
    self.tiledIndex = nil;
    self._clickManage = require("Game/Map/ClickMenu/ClickManage").new();
end

function UISignLocate:DoDataExchange()
	self.BuildingImage = self:RegisterController(UnityEngine.UI.Image,"BuildingImage");
	self.NameText = self:RegisterController(UnityEngine.UI.Text,"NameText");
	self.CoordText = self:RegisterController(UnityEngine.UI.Text,"CoordText");
	self._removeBtn = self:RegisterController(UnityEngine.UI.Button,"removeBtn");
	self._Btn = self:RegisterController(UnityEngine.UI.Button,"SignBtn");
end

function UISignLocate:DoEventAdd()
	self:AddListener(self._removeBtn,self.OnClickremoveBtn);
	self:AddListener(self._Btn,self.OnClickBtn);
end


function UISignLocate:Init(tiledIndex)
	self.tiledIndex = tiledIndex;
	self:SetSignImage();
end

-- 加载标记信息 (主城 分城 野城 要塞 野地 占领的地 城区)
function UISignLocate:SetSignImage()
	local marker = PlayerService:Instance():GetMarkerMap(self.tiledIndex);
	if marker == nil then
		return;
	end
	local x,y = MapService:Instance():GetTiledCoordinate(self.tiledIndex)
	self.BuildingImage.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("sign1");
	self.CoordText.text = x..","..y
	self.NameText.text = marker.name;
	-- local x,y = MapService:Instance():GetTiledCoordinate(self.tiledIndex)
	-- local tiled = MapService:Instance():HandleCreateTiled(x,y)
 --    if tiled ~= nil then
 --    	if tiled._building ~= nil and tiled._building._dataInfo ~= nil then
 --    		if tiled._building._dataInfo.Type == BuildingType.MainCity or tiled._building._dataInfo.Type == BuildingType.SubCity or tiled._building._dataInfo.Type == BuildingType.WildBuilding then
 --    			if tiled._town ~= nil then
 --    				self.BuildingImage.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("MainCity");
	-- 				self.CoordText.text = x..","..y
	-- 				self.NameText.text = tiled._building._name.."-城区Lv.1";
	-- 				self._removeBtn.gameObject:SetActive(true);
	-- 			else
	-- 				self.BuildingImage.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("MainCity");
	-- 				self.CoordText.text = x..","..y
	-- 				self.NameText.text = tiled._building._name;
	-- 				self._removeBtn.gameObject:SetActive(true);
	-- 			end
	-- 		elseif tiled._building._dataInfo.Type == BuildingType.PlayerFort or tiled._building._dataInfo.Type == BuildingType.WildFort or tiled._building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
	-- 			self.BuildingImage.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("fortress1");
	-- 			self.CoordText.text = x..","..y
	-- 			self.NameText.text = tiled._building._name;
	-- 			self._removeBtn.gameObject:SetActive(true);
	-- 		end	
	-- 	elseif tiled._building == nil and tiled:GetTown() == nil then
	-- 		print("tiled is nil ")
	-- 		self.BuildingImage.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("sign1");
	-- 		self.CoordText.text = x..","..y
	-- 		local resource = tiled:GetResource()
	-- 		if resource == nil then
	-- 			local tiledCutId = tiled:GetImageId(LayerType.ResourceFront)
	-- 		    local tiledCut = DataTileCut[tiledCutId]
	-- 		    if tiledCut == nil then
	-- 		        return
	-- 		    end
	-- 		    local tiledId = tiledCut.TileID
	-- 		    local resource = DataTile[tiledId]
	-- 		end
	-- 		if resource ~= nil then
	-- 			self.NameText.text = "土地Lv."..resource.TileLv;
	-- 			self._removeBtn.gameObject:SetActive(true);
	-- 		end
	-- 	end
	-- end
end	

-- 加载玩家拥有的建筑物
function UISignLocate:SetBuildSign(tiledIndex)
	self.tiledIndex = tiledIndex;
	local x,y = MapService:Instance():GetTiledCoordinate(self.tiledIndex)
	local building = BuildingService:Instance():GetBuildingByTiledId(self.tiledIndex);
    -- MapService:Instance():HandleCreateTiled(x,y)
    -- local tiled = MapService:Instance():GetTiledByIndex(self.tiledIndex);
   --  if tiled ~= nil then
   --  	if tiled._building ~= nil and tiled._building._dataInfo ~= nil and tiled:GetTown() == nil then
   --  		if tiled._building._dataInfo.Type == BuildingType.MainCity or tiled._building._dataInfo.Type == BuildingType.SubCity or tiled._building._dataInfo.Type == BuildingType.WildBuilding then
			--  	self.BuildingImage.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("MainCity");
			-- 	self.CoordText.text = x..","..y
			-- 	print(tiled._building)
			-- 	self.NameText.text = tiled._building._name;
			-- 	self._removeBtn.gameObject:SetActive(false);
			-- elseif tiled._building._dataInfo.Type == BuildingType.PlayerFort or tiled._building._dataInfo.Type == BuildingType.WildFort or tiled._building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
			--  	self.BuildingImage.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("fortress1");
			-- 	self.CoordText.text = x..","..y
			-- 	self.NameText.text = tiled._building._name;
			-- 	self._removeBtn.gameObject:SetActive(false);				
   --  		end
   --  	end
   --  end
   if building ~= nil then
	   if building ~= nil and building._dataInfo ~= nil then
	   		if building._dataInfo.Type == BuildingType.MainCity or building._dataInfo.Type == BuildingType.SubCity or building._dataInfo.Type == BuildingType.WildBuilding then
	   			self.BuildingImage.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("MainCity");
				self.CoordText.text = x..","..y
				self.NameText.text = building._name;
				self._removeBtn.gameObject:SetActive(false);
			elseif building._dataInfo.Type == BuildingType.PlayerFort or building._dataInfo.Type == BuildingType.WildFort or building._dataInfo.Type == BuildingType.WildGarrisonBuilding then
				self.BuildingImage.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite("fortress1");
				self.CoordText.text = x..","..y
				self.NameText.text = building._name;
				self._removeBtn.gameObject:SetActive(false);
	   		end
	   end	
	end

end
--
function UISignLocate:OnClickBtn()
	local building = BuildingService:Instance():GetBuildingByTiledId(self.tiledIndex)
	--print(building)
	if building ~= nil  then
		if building._dataInfo.Type == BuildingType.PlayerFort then
			local count = building:GetArmyInfoCounts();
			if count > 0 then
				MapService:Instance():MoveToTargetAndCallBack(self.tiledIndex,nil);
			else
				MapService:Instance():ScanTiledMark(self.tiledIndex);
			end
		elseif building._dataInfo.Type == BuildingType.WildFort then
			local count = building:GetWildFortArmyInfoCounts()
			if count > 0 then
				MapService:Instance():MoveToTargetAndCallBack(self.tiledIndex,nil);
			else
				MapService:Instance():ScanTiledMark(self.tiledIndex);
			end
		else
			MapService:Instance():ScanTiledMark(self.tiledIndex);
		end	
	else
		MapService:Instance():ScanTiledMark(self.tiledIndex);
	end
	--MapService:Instance():MoveToTargetAndCallBack(self.tiledIndex,nil);

	local baseClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
    local isopen = UIService:Instance():GetOpenedUI(UIType.UIGameMainView);
    if baseClass ~= nil and isopen == true then
        baseClass:HidePanel();
    end
	local tiled = MapService:Instance():GetTiledByIndex(self.tiledIndex);
	if tiled == nil then
	local timer = Timer.New(
	    function()
	        local tiled = MapService:Instance():GetTiledByIndex(self.tiledIndex)
	        if tiled ~= nil then
	            MapService:Instance():ShowTiled(tiled,MapService:Instance():GetTiledPositionByIndex(self.tiledIndex))
	        end
	    end , 1, 1, false);
	    timer:Start();
	else
		MapService:Instance():ShowTiled(tiled,MapService:Instance():GetTiledPositionByIndex(self.tiledIndex))
	end
end

function UISignLocate:OnClickremoveBtn()
	local msg = require("MessageCommon/Msg/C2L/Player/RequestUndoMarker").new();
    msg:SetMessageId(C2L_Player.RequestUndoMarker);
    msg.tiledIndex = self.tiledIndex;
    NetService:Instance():SendMessage(msg);
end



return UISignLocate


 