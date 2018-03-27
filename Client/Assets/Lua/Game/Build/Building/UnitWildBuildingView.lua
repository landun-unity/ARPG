-- 建筑物的显示类
local UnitWildBuildingView = class("UnitWildBuildingView")

-- 构造函数
function UnitWildBuildingView:ctor()
    --格子父物体
    self._buidlingTransform = nil;
    --图片ID
    self._allImageIdMap = nil;
    --城市格子图片
    self._allImageMap = nil;
end

-- 加载码头
function UnitWildBuildingView:LoadBoat(building)
    ------print(index..id);
    ------print(building);
    local imageId = building._dataInfo.Orientation;
    ------print(imageId);
    self:SetImageId(imageId);
end

-- 加载关卡
function UnitWildBuildingView:LoadWildFort(building)
   -- ----print(index..id);
    local imageId = building._dataInfo.BorderOrientation;
    ------print(imageId);
    self:SetImageId(imageId);
end
--等级
function UnitWildBuildingView:LoadPlayerFort(building)
   -- ----print(index..id);
    local imageId = 0;
    ------print(building._fortGrade);
    if building._fortGrade == 1 or building._fortGrade == 2 then
        imageId = 1;
    elseif building._fortGrade == 3 or building._fortGrade == 4 then
        imageId = 2;
    elseif building._fortGrade == 5 then
        imageId = 3;
    end
    ------print(imageId);
    self:SetImageId(imageId);
end

-- 设置城市图片Id
function UnitWildBuildingView:SetImageId(imageId)
    if imageId == nil then
        return;
    end
    self._allImageIdMap = imageId;
end

-- 设置图片Id
function UnitWildBuildingView:GetImageId()
    return  self._allImageIdMap;
end

-- 设置建筑物的GameObject
function UnitWildBuildingView:SetBoatTransform(buildingTransform)
    self._buidlingTransform = buildingTransform;
end

-- 设置建筑物的GameObject
function UnitWildBuildingView:GetBoatTransform()
    return self._buidlingTransform;
end


-- 设置地表材质
function UnitWildBuildingView:SetSprite(sprite)
    if sprite == nil then
        return;
    end
    local image = self:GetImageSprite();
    if image == nil then
        return;
    end

    image.sprite = sprite;
end

function UnitWildBuildingView:GetImageSprite()
    return self._allImageMap;
end

function UnitWildBuildingView:SetImageSprite(imageObject)
    if imageObject == nil then
        return;
    end
    --print(index)
    imageObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(400, 400);
    local image = imageObject:GetComponent(typeof(UnityEngine.UI.Image));
    self._allImageMap = image;
end

-- 清空
function UnitWildBuildingView:Clear()
    self._allImageMap = nil;
    self._buidlingTransform = nil;
    self._allImageIdMap = nil;
end

return UnitWildBuildingView;