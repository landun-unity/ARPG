--
-- 逻辑服务器 --> 客户端
-- 外观格子
-- @author czx
--
local CityTitledModel = class("CityTitledModel");

function CityTitledModel:ctor()
    --
    -- 格子索引
    --
    self.index = 0;
    
    --
    -- 设施对应tableid
    --
    self.tableid = 0;
    
    --
    -- 格子等级
    --
    self.level = 0;
    
    --
    -- 民居对应枚举
    --
    self.folkType = 0;
end

return CityTitledModel;
