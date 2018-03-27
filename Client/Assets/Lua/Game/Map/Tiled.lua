-- 地图块
Tiled = class("Tiled")
local VariationCalc = require("Game/Util/VariationCalc")
-- 构造函数
function Tiled:ctor()
    -- 索引
    self._x = 0;
    self._y = 0;
    self._index = 0;
    self._layerImageIdMap = { };
    self._layerImageMap = { };
    self._building = nil;
    self._town = nil;
    -- 子码头
    self._childBoat = nil;
    self._isVisible = false;
    self._resource = nil;
    self._region = { };
    self._wildBarracks = nil;
    self._fort = nil;
    self.tiledInfo = nil;
 
    self.allLineMap = {};
    self._isMark = false;
    --同盟标记
    self._leagueMark =nil;
    -- 创建要塞状态(地块显示用)
    self._fortState = false;

    -- 地块耐久变化量
    self.durableVar = VariationCalc.new()

    -- 地块迷雾边缘值
    self.viewEdge = 11111111;
    self.oldViewImageName = "";
end

-- 初始化
function Tiled:Init(x, y, index)
    self._x = x;
    self._y = y;
    self._index = index;
end

-- Y轴坐标
function Tiled:GetIndex()
    return self._index;
end


-- X轴坐标
function Tiled:GetX()
    return self._x;
end

-- Y轴坐标
function Tiled:GetY()
    return self._y;
end

-- 设置土地资源
function Tiled:SetResource(dataTiled)
    self._resource = dataTiled;
end

-- 获取土地资源
function Tiled:GetResource()
    return self._resource;
end

-- 设置州郡信息
function Tiled:SetRegion(dataRegion)
    self._region = dataRegion;
end

-- 获取州郡信息
function Tiled:GetRegion()
    return self._region
end

-- 获取是否显示
function Tiled:GetIsVisible()
    return self._isVisible;
end

-- 设置隐藏显示
function Tiled:SetVisible(visible)
    self._isVisible = visible;
end

-- 设置地表层图片Id
function Tiled:SetImageId(layerType, landImageId)
    if layerType == nil or landImageId == nil then
        return;
    end
    
    self._layerImageIdMap[layerType] = landImageId;
end

-- 获取地表层图片Id
function Tiled:GetImageId(layerType)
    if layerType == nil then
        return 0;
    end
    
    return self._layerImageIdMap[layerType];
end

-- 设置格子的物件
function Tiled:SetTiledImage(layerType, imageObject)
    if layerType == nil or imageObject == nil then
        return;
    end

    local image = imageObject:GetComponent(typeof(UnityEngine.UI.Image));
    self._layerImageMap[layerType] = image;
end

function Tiled:ClearTiledImage(layerType)
    if layerType == nil then
        return;
    end
    
    self._layerImageMap[layerType] = nil;
end


-- 清空物件
function Tiled:ClearTiledObject()
    self._layerImageMap = { };
end

-- 获取地表层图片Id
function Tiled:GetImage(layerType)
    if layerType == nil then
        return nil;
    end
    return self._layerImageMap[layerType];
end

-- 获取地表层图片Id
function Tiled:GetImageTransform(layerType)
    local image = self:GetImage(layerType);
    if image == nil then
        return nil;
    end
    return image.gameObject.transform;
end

-- 设置地表材质
function Tiled:SetSprite(layerType, sprite)
    if layerType == nil or sprite == nil then
        return;
    end

    local image = self:GetImage(layerType);
    
    if image == nil then
        return;
    end
    
    image.sprite = sprite;
end

function Tiled:ClearTransform(layerType)
    if layerType == nil then
        return;
    end
    self._layerImageMap[layerType] = nil
end

-- 设置城类
function Tiled:SetBuilding(Building)
    if Building == nil then
        return;
    end

    self._building = Building;
end

-- 设置城区
function Tiled:SetTown(town)
    if town == nil then
        return;
    end
    -- print("设置格子个城区");
    self._town = town;
end

-- 设置军营
function Tiled:SetWildBarracks(barracks)
    if Barracks == nil then
        return;
    end

    self._wildBarracks = Barracks;
end
-- 设置要塞
function Tiled:SetFort(fort)
    if fort == nil then
        return;
    end 

    self._fort = fort;
end

-- 获取军营
function Tiled:GetWildBarracks()

    return self._wildBarracks;
end
-- 获取要塞
function Tiled:GetFort()

    return self._fort;
end

-- 获取城类
function Tiled:GetBuilding()

    return self._building;
end

-- 删城类
function Tiled:RemoveBuilding()

    self._building = nil;
end

function Tiled:DeleteFort()
     self._fort = nil;
end

-- 获取城区
function Tiled:GetTown()

    return self._town;
end

-- 删除城区
function Tiled:RemoveTown()

    self._town = nil;
end

function Tiled:RemoveChildBoat()
    self._childBoat = nil;
end

-- 获取buildingid
function Tiled:GetId()
    if self._building ~= nil then
        return self._building._id;
    end
end

function Tiled:GetLeagueMark()

    return self._leagueMark;

end


function Tiled:GetLeagueMarkId()

    return self._leagueMark.id;

end

function Tiled:SetLeagueMark(LeagueMark)

    self._leagueMark = LeagueMark

end



function Tiled:SetIsMark(bool)
    self._isMark = bool
end

-- 获取土地是否被标记
function Tiled:IsMark()
    return self._isMark
end

function Tiled:SetFortState(bool)
    self._fortState = bool;
end

function Tiled:GetFortStete()
    return self._fortState;
end

-- 初始化地块耐久信息
function Tiled:SetDurableVar(curValue,maxValue,time)
    self.durableVar:Init(curValue,PlayerService:Instance():GetLocalTime(),false)
    self.durableVar:SetVariationVal(maxValue*0.02)
    self.durableVar:SetMaxValue(maxValue)
    self.durableVar:SetVariationSpace(time)
    self:GetDurable()
end

-- 获取地块耐久
function Tiled:GetDurable()
    return self.durableVar:GetValue()
end

-- 更改地块迷雾边缘值（index为1-8）
function Tiled:SetViewEdgeValue(index, value)
    local tempInt1 = math.floor(self.viewEdge / math.pow(10, (8 - index)));
    local tempInt2 = math.floor(self.viewEdge / math.pow(10, (8 - index + 1))) * 10;
    local oldInt = tempInt1 - tempInt2;
    if oldInt == value then
        return;
    end
    self.viewEdge = self.viewEdge - (oldInt - value) * math.pow(10, (8 - index));
end

function Tiled:GetViewEdgeValue()
    return self.viewEdge;
end

function Tiled:SetOldViewImageName(name)
    self.oldViewImageName = name;
end

function Tiled:GetOldViewImageName()
    return self.oldViewImageName;
end

return Tiled;