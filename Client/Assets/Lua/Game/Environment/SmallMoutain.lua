-- 建筑物的显示类
local SmallMoutain = class("SmallMoutain")

-- 构造函数
function SmallMoutain:ctor()
    --自身tansform
    self._moutainTransform = nil;
    --image
    self._moutainImage = nil;

    self._imageId = nil;

    self._moutainType = nil;

    self._offest = 0;
end

function SmallMoutain:GetType()
    return self._moutainType;
end

function SmallMoutain:Init(imageId, type, offest)
    self._imageId = imageId;
    self._moutainType = type;
    self._offest = offest;
end

function SmallMoutain:GetImageId()
    return self._imageId;
end

-- 设置建筑物的GameObject
function SmallMoutain:SetMoutainTransform(MoutainTransform)
    self._moutainTransform = MoutainTransform;
end

-- 设置建筑物的GameObject
function SmallMoutain:GetMoutainTransform()
    return self._moutainTransform;
end


-- 设置图片
function SmallMoutain:SetImageSprite(imageObject)
    if  imageObject == nil then
        return;
    end
    --imageObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(400, 400);
    local image = imageObject:GetComponent(typeof(UnityEngine.UI.Image));
    self._moutainImage = image;
end

-- 获取图片
function SmallMoutain:GetImageSprite()
    return self._moutainImage;
end


-- 设置地表材质
function SmallMoutain:SetSprite(sprite)
    if sprite == nil then
        return;
    end
    local image = self:GetImageSprite();
    if image == nil then
        return;
    end

    image.sprite = sprite;
    image:SetNativeSize();
end

function SmallMoutain:GetMoutainPosition(x, y)
    local endX = (y * MapLoad:GetTiledWidth() / 2) - x * MapLoad:GetTiledWidth() / 2;
    local endY = - x * MapLoad:GetTiledHeight() / 2 - ((y + 1) * MapLoad:GetTiledHeight() / 2);
    ------print(endX .. "    " .. endY);
    return Vector3.New(endX, endY - self._offest, 0);--- DataMapmove[MapMoveType.Moutain].Parameter
end

-- 清空
function SmallMoutain:Clear()
    self._moutainTransform = nil;
end

return SmallMoutain;