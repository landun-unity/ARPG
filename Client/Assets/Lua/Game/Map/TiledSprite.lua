-- 地图的贴图，主要是策划编辑的层
TiledSprite = class("TiledSprite")

-- 构造函数
function TiledSprite:ctor()
    -- 材质索引
    self._textureId = 0;
    -- 图片
    self._image = "";
    -- 宽
    self._width = 0;
    -- 高
    self._height = 0;
    -- 精灵
    self._sprite = nil;
end

-- 初始化
function TiledSprite:Init(textureId, image, width, height)
    self._textureId = textureId;
    self._image = image;
    self._width = width;
    self._height = height;
    self._sprite = GameResFactory.Instance():GetResSprite(image);
end

-- 获取精灵
function TiledSprite:GetSprite()
    -- body
    return self._sprite;
end

return TiledSprite;