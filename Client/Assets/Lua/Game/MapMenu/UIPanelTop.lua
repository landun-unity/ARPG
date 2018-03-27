--[[
    地块面板顶端
--]]

local UIBase = require("Game/UI/UIBase");
local BuildingType = require("Game/Build/BuildingType")
local UIPanelTop = class("UIPanelTop", UIBase);

-- 构造函数
function UIPanelTop:ctor()
    UIPanelTop.super.ctor(self);
    
    -- 名称
    self._name = nil

    -- 州郡名
    self._stateRegionName = nil

    -- 坐标
    self._coordinate = nil

    -- 百分数值
    self._percentageText = nil

    -- 百分比条
    self._percentageBar = nil
    
    self.tiled = nil;
    self.marchTimer = nil;
end

-- 注册控件
function UIPanelTop:DoDataExchange()
    self._name = self:RegisterController(UnityEngine.UI.Text,"landGrade/Text")
    self._stateRegionName = self:RegisterController(UnityEngine.UI.Text,"place/roomText")
    self._croodinate = self:RegisterController(UnityEngine.UI.Text,"place/Coord")
    self._percentageText = self:RegisterController(UnityEngine.UI.Text,"durablePer/Text")
    self._percentageBar = self:RegisterController(UnityEngine.UI.Slider,"durablePer")
    --self._tiledImage = self:RegisterController(UnityEngine.UI.Image, "tile/tileimage")
end

-- 注册控件点击事件
function UIPanelTop:DoEventAdd()
    
end

function UIPanelTop:OnHide(param)
	if self.marchTimer ~= nil then
        self.marchTimer:Stop();
        self.marchTimer = nil;  
    end
end

-- 显示
function UIPanelTop:ShowTiled(tiled)
    self.gameObject.transform.localScale = Vector3.New(1.52,1.52,1.52);
    self.tiled = tiled;
    self:SetName(tiled)
    self:SetStateRegionName(tiled)
    self:SetCroodinate(tiled)
    self:SetDurableVal()
    --self:_ShowTiledImage();

    if self.marchTimer == nil then
        self.marchTimer = Timer.New(
        function()
            self:SetDurableVal(self.tiled);
        end , 60, -1, false);
        self.marchTimer:Start();
    end
end

function UIPanelTop:HideTiled()
    --self:HideTiledImage();
end

-- 刷名称
function UIPanelTop:SetName(tiled)
    local tiledInfo = MapService:Instance():GetDataTiled(tiled)
    if tiledInfo ~= nil then        
        local town = tiled:GetTown();
        if town ~= nil then
            local building = town._building
            if building ~= nil then
                local name = building._name
                if building._dataInfo.Type == BuildingType.MainCity or building._dataInfo.Type == BuildingType.SubCity then
                    self._name.text = name .. "-城区";
                else
                    self._name.text = building._dataInfo.Name .. "-城区 <color=#FFE384>Lv.".. tiledInfo.TileLv .."</color>"
                end
            end
            return
        end
        local building = tiled:GetBuilding()
        if building ~= nil then
            if building._owner ~=0 then
                if building._dataInfo.Type == BuildingType.MainCity  then
                    self._name.text = tiled.tiledInfo.ownerName;
                elseif building._dataInfo.Type == BuildingType.SubCity then
                    self._name.text = building._name;
                elseif building._dataInfo.Type == BuildingType.PlayerFort then
                    self._name.text = building._name;
                elseif building._dataInfo.Type == BuildingType.WildFort then
                    self._name.text = "野外要塞";
                else
                    self._name.text = building._dataInfo.Name .. "<color=#FFE384>Lv.".. building._dataInfo.level .."</color>"
                end
            else
                --local name = building._name;
                self._name.text = building._dataInfo.Name .. "<color=#FFE384>Lv.".. building._dataInfo.level .."</color>";
            end
        else
            self._name.text = "土地 <color=#FFE384>Lv.".. tiledInfo.TileLv .."</color>";
        end
    end
end

-- 刷州郡名称
function UIPanelTop:SetStateRegionName(tiled)
    local region = tiled:GetRegion()
    local state = DataState[region.StateID]
    local stateName = state.Name
    local regionName = region.Name
    self._stateRegionName.text = stateName .. "-" .. regionName
end

-- 刷坐标
function UIPanelTop:SetCroodinate(tiled)
    local x = tiled:GetX()
    local y = tiled:GetY()
    self._croodinate.text = x .. "-" .. y
end

--刷土地耐久
function UIPanelTop:SetDurableVal()
    if self.tiled == nil then
        return
    end
    local tableDurableVal = MapService:Instance():GetTiledDurableVal(self.tiled)
    if self.tiled.tiledInfo == nil then
        self._percentageBar.value = 1
        self._percentageText.text = tableDurableVal .. " / " .. tableDurableVal
        return
    end

    local curDurableVal = self.tiled:GetDurable()
    -- print("当前土地耐久 == " .. curDurableVal)
    local maxDurableVal = self.tiled.tiledInfo.maxDurableVal
    if maxDurableVal == 0 then
        self._percentageBar.value = 1
        self._percentageText.text = tableDurableVal .. " / " .. tableDurableVal
        return
    end
    local percentageVal = curDurableVal / maxDurableVal
    
    self._percentageBar.value = percentageVal
    if curDurableVal == maxDurableVal and MapService:Instance():IsFriendTiled(self.tiled) == false and self.tiled.tiledInfo.ownerId ~= 0 then
        self._percentageText.text = "100%"
    else
        self._percentageText.text = curDurableVal .. " / " .. maxDurableVal
    end
end


return UIPanelTop;
