--
-- 一个箭头信息
--
local Arrow = class("Arrow");

-- 箭头
function Arrow:ctor()
    -- 箭头的Id
    self.id = 0;
    -- 线的Id
    self.lineId = 0;
    -- 坐标
    self.x = 0;
    self.y = 0;
    -- 图片
    self.imageObject = nil;
    -- 图片类
    self.image = nil;
    -- 时间
    self.passTime = 0;
    -- 格子上
    self.tiledIndex = 0;
    -- 上一次结果
    self.lastResult = nil;
end

-- 设置图片
function Arrow:SetSprite(sprite)
    if self.imageObject == nil then
        return;
    end
    if self.image == nil then
        self.image = self.imageObject:GetComponent(typeof(UnityEngine.UI.Image))
    end

    self.image.sprite = GameResFactory.Instance():GetResSprite(sprite);
end

return Arrow;