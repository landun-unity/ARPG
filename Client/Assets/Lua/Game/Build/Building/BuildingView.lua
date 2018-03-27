-- 建筑物的显示类
local MapLoad = require("Game/Map/MapLoad")
local BuildingView = class("BuildingView")

-- 构造函数
function BuildingView:ctor()
    --格子父物体
    self._buidlingTransform = nil;
    --图片的父物体
    self._tileTransform = {};
    --图片ID
    self._allImageIdMap = {};
    --城墙ID
  --  self._allWallImageIdMap = {};
    --城墙图片
    self._allWallImageMap = {};
    --城市格子图片
    self._allImageMap = {};
    --加载对应文件
    self._buildingConfig = nil;
end

-- 加载城池
function BuildingView:LoadBuilding(config)
    self._buildingConfig = require("Game/Build/Building/FieldBuildingLoad").new();
    self._buildingConfig:InitBuilding(config);
    for x=0,self._buildingConfig:GetWidth()-1 do
        for y=0,self._buildingConfig:GetHeight()-1 do
            local index = self._buildingConfig:ConvertIndex(x,y);
            local id = self._buildingConfig:GetBuilding(index);
           -- print(index..id);
            self:SetBuildingImageId(index,id);
        end
    end
    return self._buildingConfig;
    -- 取出所有的图片IdGetBuilding
end

-- 设置城墙图片
function BuildingView:SetWallImage(index, imageObject)
    if index == nil or imageObject == nil then
        return;
    end
   -- print(index)
    imageObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(200,200);
    local image = imageObject:GetComponent(typeof(UnityEngine.UI.Image));
    self._allWallImageMap[index] = image;
end

-- 获取城墙image
function BuildingView:GetWallImageSprite(index)
    if index == nil then
        return;
    end

     return self._allWallImageMap[index];
end

-- 设置城墙材质
function BuildingView:SetWallSprite(index, sprite)
    if index == nil or sprite == nil then
        return;
    end
    local image = self:GetWallImageSprite(index);
    if image == nil then
        return;
    end

    image.sprite = sprite;
end

-- 设置城市图片Id
function BuildingView:SetBuildingImageId(index, id)
    if index == nil or id == nil then
        return;
    end
   -- print(#self._allImageIdMap)
    self._allImageIdMap[index] = id;
end

-- 根据位置，求坐标
function BuildingView:GetWallPosition(index)
    local convert = { math.floor( index / 3 ),index % 3 };
    local dis = (MapLoad._imageWidth / 4 + 25) / 2;
    local endX = convert[2] * dis - convert[1] * dis;
    local endY = - convert[1] * dis / 2 - (convert[2] + 1) * dis / 2;
    --print(endX .. "    " .. endY);
    
    return Vector3.New(endX, endY + MapLoad._imageWidth / 4 - 10, 0);
end

function BuildingView:ConvertCoordinate(index)
    if index == nil then
        return;
    end

    return self._buildingConfig:ConvertCoordinate(index);
end

function BuildingView:ConvertIndex(x, y)
    if x == nil or y == nil then
        return nil;
    end
    if x < 0 or y < 0 then
        return;
    end
    if y > math.sqrt(self:GetImageCount())-1 or x > math.sqrt(self:GetImageCount())-1 then
        return;
    end

    return self._buildingConfig:ConvertIndex(x ,y);
end

function BuildingView:WallConvertIndex(x, y)
    if x == nil or y == nil then
        return nil;
    end
    if x < 0 or y < 0 then
        return;
    end
    if y > math.sqrt(self:GetImageCount())-1 or x > math.sqrt(self:GetImageCount())-1 then
        return;
    end

    return self._buildingConfig:WallConvertIndex(x ,y);
end

-- 设置图片Id
function BuildingView:GetImageId(index)
    if index == nil then
        return;
    end
    if self._allImageIdMap[index] == 0 then
        return nil;
    end

    return  self._allImageIdMap[index];
end

-- 设置建筑物的GameObject
function BuildingView:SetBuildingTransform(buildingTransform)
    self._buidlingTransform = buildingTransform;
end

-- 设置建筑物的GameObject
function BuildingView:GetBuildingTransform()
    return self._buidlingTransform;
end

-- 设置格子的GameObject
function BuildingView:SetTiledTransform(index, tileTransform)
    self._tileTransform[index] = tileTransform;
end

-- 获取格子的GameObject
function BuildingView:GetTiledTransform(index)
    return self._tileTransform[index];
end

-- 获取格子的GameObject
function BuildingView:GetTiledTransformTable()
    return self._tileTransform;
end

-- 获取城墙图片数量
function BuildingView:GetTiledTransformCount()
    return #self._tileTransform + 1;
end

-- 设置图片
function BuildingView:SetTiledImage(index, imageObject)
    if index == nil or imageObject == nil then
        return;
    end
    --print(imageObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta)
    imageObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(self._buildingConfig._imageWidth, self._buildingConfig._imageWidth + 200);
    local image = imageObject:GetComponent(typeof(UnityEngine.UI.Image));
    self._allImageMap[index] = image;
end

-- 获取图片
function BuildingView:GetImageSprite(index)
    if index == nil then
        return;
    end

     return self._allImageMap[index];
end


-- 设置地表材质
function BuildingView:SetSprite(index, sprite)
    if index == nil or sprite == nil then
        return;
    end
    local image = self:GetImageSprite(index);
    if image == nil then
        return;
    end

    image.sprite = sprite;
end

-- 获取城池图片数量
function BuildingView:GetImageCount()
    return #self._allImageIdMap + 1;
end

-- 根据格子位置，求位置坐标
function BuildingView:GetTiledPosition(x, y, State)
    local endX = (y * self._buildingConfig:GetTiledWidth() / 2) - x * self._buildingConfig:GetTiledWidth() / 2;
    local endY = - x * self._buildingConfig:GetTiledHeight() / 2 - ((y + 1) * self._buildingConfig:GetTiledHeight() / 2);

    --print(endX .. "    " .. endY);
    return Vector3.New(endX, endY + (MapLoad._imageWidth / 2) * State, 0);
end

-- 根据格子位置，求位置坐标
function BuildingView:GetErrorPosition(x, y, State)
    local endX = (y * self._buildingConfig:GetTiledWidth() / 2) - x * self._buildingConfig:GetTiledWidth() / 2;
    local endY = - x * self._buildingConfig:GetTiledHeight() / 2 - ((y + 1) * self._buildingConfig:GetTiledHeight() / 2);

    --print(endX .. "    " .. endY);
    return Vector3.New(endX, endY - (MapLoad._imageWidth / 4) + (MapLoad._imageWidth / 2) * State, 0);
end


-- 清空
function BuildingView:Clear()
    self._allImageMap = {};
    self._buidlingTransform = nil;
    self._tileTransform = {};
    self._allWallImageMap = {};
end

return BuildingView;