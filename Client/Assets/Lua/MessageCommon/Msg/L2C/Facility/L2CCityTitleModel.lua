--
-- 逻辑服务器 --> 客户端
-- 外观格子
-- @author czx
--
local L2CCityTitleModel = class("L2CCityTitleModel");

function L2CCityTitleModel:ctor()
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

return L2CCityTitleModel;
