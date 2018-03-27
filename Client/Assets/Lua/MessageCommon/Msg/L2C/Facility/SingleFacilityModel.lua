--
-- 逻辑服务器 --> 客户端
-- 外观格子
-- @author czx
--
local SingleFacilityModel = class("SingleFacilityModel");

function SingleFacilityModel:ctor()
    --
    -- 格子索引
    --
    self.id = 0;
    
    --
    -- 设施对应tableid
    --
    self.level = 0;
    
    --
    -- 格子等级
    --
    self.tableid = 0;
    
    --
    -- 民居对应枚举
    --
    self.nextUpgradeTime = 0;
end

return SingleFacilityModel;
