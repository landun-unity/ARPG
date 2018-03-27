--
-- 客户端 --> 逻辑服务器
-- 外观格子
-- @author czx
--
local C2LCityTitleModel = class("C2LCityTitleModel");

function C2LCityTitleModel:ctor()
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

return C2LCityTitleModel;
