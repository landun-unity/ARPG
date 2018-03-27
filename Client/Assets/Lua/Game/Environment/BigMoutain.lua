-- 建筑物的显示类
--require("Game/Environment/MapMoveType");
local BigMoutain = class("BigMoutain")

-- 构造函数
function BigMoutain:ctor()
    --自身tansform
    self._moutainTransform = nil;
    --image
    self._moutainImage = nil;

    self._imageId = nil;

    self._moutainType = nil;

    self._offest = 0;
end

function BigMoutain:GetType()
    return self._moutainType;
end

function BigMoutain:Init(imageId, type, offest)
    self._imageId = imageId;
    self._moutainType = type;
    self._offest = offest;
end

function BigMoutain:GetImageId()
    return self._imageId;
end

-- 设置建筑物的GameObject
function BigMoutain:SetMoutainTransform(MoutainTransform)
    self._moutainTransform = MoutainTransform;
end

-- 设置建筑物的GameObject
function BigMoutain:GetMoutainTransform()
    return self._moutainTransform;
end


-- 设置图片
function BigMoutain:SetImageSprite(imageObject)
    if  imageObject == nil then
        return;
    end
    --imageObject:GetComponent(typeof(UnityEngine.RectTransform)).sizeDelta = Vector2.New(800, 800);
    local image = imageObject:GetComponent(typeof(UnityEngine.UI.Image));
    self._moutainImage = image;
end

-- 获取图片
function BigMoutain:GetImageSprite()
    return self._moutainImage;
end


-- 设置地表材质
function BigMoutain:SetSprite(sprite)
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

function BigMoutain:GetMoutainPosition(x, y, core)
    local endX = (y * MapLoad:GetTiledWidth() / 2) - x * MapLoad:GetTiledWidth() / 2;
    local endY = - x * MapLoad:GetTiledHeight() / 2 - ((y + 1) * MapLoad:GetTiledHeight() / 2);
    ------print(core[1] .. "    " .. core[2]);
    return Vector3.New(endX + core[1] * MapLoad._imageWidth / 2, endY + core[2] * MapLoad._imageWidth / 4 - self._offest, 0);--DataMapmove[MapMoveType.Moutain].Parameter
end

-- 清空
function BigMoutain:Clear()
    self._moutainTransform = nil;
end

return BigMoutain;