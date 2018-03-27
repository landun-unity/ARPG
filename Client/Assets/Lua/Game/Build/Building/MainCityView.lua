-- 主城的显示类
local DataConstruction = require("Game/Table/model/DataConstruction")
local DataBuilding = require("Game/Table/model/DataBuilding")
local MapLoad = require("Game/Map/MapLoad")
local MainCityView = class("MainCityView")

-- 构造函数
function MainCityView:ctor()
    --格子父物体
    self._buidlingTransform = nil;
    --图片的父物体
    self._tileTransform = nil;
    --图片ID
    self._allImageIdMap = nil;
    --城墙ID
  --  self._allWallImageIdMap = {};   
    --城墙图片
    --self._allWallImageMap = {};
    --城市格子图片
    self._allImageMap = nil;
end

-- 加载起始城池
function MainCityView:LoadBuilding(building)
    if building == nil then
        return;
    end

    
    local mainHome = DataBuilding[building._tableId].UpgradeToBuilding;
    local cityLevel = building:GetCityLevel();
    for i,v in ipairs(DataConstruction[mainHome].ConstructionLv) do
        if cityLevel <= v then
            ImageId = DataConstruction[mainHome].Camp[1]..DataConstruction[mainHome].ExtensionPicture[i];
            break;
        end
    end

    self:SetBuildingImageId(ImageId);
end

-- 设置城墙图片
-- function MainCityView:SetWallImage(index, imageObject)
--     if index == nil or imageObject == nil then
--         return;
--     end
--    -- print(index)
--     imageObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(MapLoad._imageWidth / 2,MapLoad._imageWidth / 2);
--     local image = imageObject:GetComponent(typeof(UnityEngine.UI.Image));
--     self._allWallImageMap[index] = image;
-- end

-- 获取城墙image
-- function MainCityView:GetWallImageSprite(index)
--     if index == nil then
--         return;
--     end

--      return self._allWallImageMap[index];
-- end

-- 设置城墙材质
-- function MainCityView:SetWallSprite(index, sprite)
--     if index == nil or sprite == nil then
--         return;
--     end
--     local image = self:GetWallImageSprite(index);
--     if image == nil then
--         return;
--     end

--     image.sprite = sprite;
-- end

-- 设置城市图片Id
-- function MainCityView:SetBuildingImageId(index, id)
--     if index == nil or id == nil then
--         return;
--     end
--    -- print(#self._allImageIdMap)
--     self._allImageIdMap[index] = id;
-- end

function MainCityView:SetBuildingImageId(id)
    if id == nil then
        return;
    end
   -- print(#self._allImageIdMap)
    self._allImageIdMap = id;
end

-- 根据位置，求坐标
-- function MainCityView:GetWallPosition(index)
--     local convert = { math.floor( index / 3 ),index % 3 };
--     local dis = (MapLoad._imageWidth / 4 + 25) / 2;
--     local endX = convert[2] * dis - convert[1] * dis;
--     local endY = - convert[1] * dis / 2 - (convert[2] + 1) * dis / 2;
--     --print(endX .. "    " .. endY);
    
--     return Vector3.New(endX, endY + MapLoad._imageWidth / 4 - 10, 0);
-- end

-- function MainCityView:ConvertCoordinate(index)
--     if index == nil then
--         return;
--     end
--    -- local convert ={ math.floor(index / 5), index % 5};
--     --print(math.ceil(index/self:GetWidth()),index%self:GetWidth())
--     return math.floor(index / 5), index % 5;
-- end

-- function MainCityView:ConvertIndex(x, y)
--     if x == nil or y == nil then
--         return nil;
--     end
--     if x < 0 or y < 0 then
--         return nil;
--     end
--     if x > 4 or y > 4 then
--         return nil;
--     end

--     return x * 5 + y;
-- end

-- function MainCityView:WallConvertIndex(x, y)
--     if x == nil or y == nil then
--         return nil;
--     end
--     if x < 0 or y < 0 then
--         return;
--     end
--     -- if y > math.sqrt(self:GetImageCount())-1 or x > math.sqrt(self:GetImageCount())-1 then
--     --     return;
--     -- end

--     return (x * 5 + y) * 17;
-- end

-- 设置图片Id
-- function MainCityView:GetImageId(index)
--     if index == nil then
--         return;
--     end

--     return  self._allImageIdMap[index]
-- end

function MainCityView:GetImageId()

    return  self._allImageIdMap;
end

-- 设置建筑物的GameObject
function MainCityView:SetBuildingTransform(buildingTransform)
    self._buidlingTransform = buildingTransform;
end

-- 设置建筑物的GameObject
function MainCityView:GetBuildingTransform()
    return self._buidlingTransform;
end

-- 设置格子的GameObject
-- function MainCityView:SetTiledTransform(index, tileTransform)
--     self._tileTransform[index] = tileTransform;
-- end

-- function MainCityView:SetTiledTransform(tileTransform)
--     self._tileTransform = tileTransform;
-- end

-- -- 获取格子的GameObject
-- function MainCityView:GetTiledTransform(index)
--     return self._tileTransform[index];
-- end

-- function MainCityView:GetTiledTransform()
--     return self._tileTransform;
-- end

--获取城墙图片
-- function MainCityView:GetTiledTransformTable()
--     return self._tileTransform;
-- end

-- 设置图片
-- function MainCityView:SetTiledImage(index, imageObject)
--     if index == nil or imageObject == nil then
--         return;
--     end
--     --print(imageObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta)
--     imageObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(MapLoad._imageWidth / 2, MapLoad._imageWidth / 2 + 200);
--     local image = imageObject:GetComponent(typeof(UnityEngine.UI.Image));
--     self._allImageMap[index] = image;
-- end

function MainCityView:SetTiledImage(imageObject)
    if imageObject == nil then
        return;
    end
    --print(imageObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta)
    imageObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(MapLoad._imageWidth * 3, MapLoad._imageWidth * 3);
    local image = imageObject:GetComponent(typeof(UnityEngine.UI.Image));
    self._allImageMap = image;
end

-- 获取图片
-- function MainCityView:GetImageSprite(index)
--     if index == nil then
--         return;
--     end

--      return self._allImageMap[index];
-- end

function MainCityView:GetImageSprite()
     return self._allImageMap;
end


-- 设置地表材质
-- function MainCityView:SetSprite(index, sprite)
--     if index == nil or sprite == nil then
--         return;
--     end
--     local image = self:GetImageSprite(index);
--     --print(image)
--     if image == nil then
--         return;
--     end

--     image.sprite = sprite;
-- end

function MainCityView:SetSprite(sprite)
    if sprite == nil then
        return;
    end
    local image = self:GetImageSprite();
    --print(image)
    if image == nil then
        return;
    end

    image.sprite = sprite;
end

-- 获取城池图片数量
-- function MainCityView:GetImageCount()
--     return #self._allImageIdMap;
-- end

-- 根据格子位置，求位置坐标
function MainCityView:GetTiledPosition(x, y)
    local endX = (y * (MapLoad._imageWidth / 2) / 2) - x * (MapLoad._imageWidth / 2) / 2;
    local endY = (- x * (MapLoad._imageWidth / 4) / 2 - ((y + 1) * (MapLoad._imageWidth / 4) / 2));

    --城门
    return Vector3.New(endX, endY + (MapLoad._imageWidth / 2), 0);
end

-- 清空
function MainCityView:Clear()
    self._allImageMap = nil;
    self._allImageIdMap = nil;
    --self._buidlingTransform = nil;
    self._tileTransform = nil;
    --self._allWallImageMap = {};
end


return MainCityView;