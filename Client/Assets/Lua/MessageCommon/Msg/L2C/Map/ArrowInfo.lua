--
-- 逻辑服务器 --> 客户端
-- 箭头信息
-- @author czx
--
local ArrowInfo = class("ArrowInfo");

function ArrowInfo:ctor()
    --
    -- 箭头的唯一Id
    --
    self.id = 0;
    
    --
    -- x轴
    --
    self.x = 0.0;
    
    --
    -- y轴
    --
    self.y = 0.0;
    
    --
    -- 经过时间
    --
    self.pastTime = 0;
end

return ArrowInfo;
