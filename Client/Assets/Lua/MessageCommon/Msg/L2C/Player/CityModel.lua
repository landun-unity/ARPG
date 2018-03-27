--
-- 逻辑服务器 --> 客户端
-- 同步玩家城池
-- @author czx
--
local List = require("common/List");

local CityModel = class("CityModel");

function CityModel:ctor()
    --
    -- 建筑物唯一Id
    --
    self.id = 0;
    
    --
    -- 名称
    --
    self.name = "";
    
    --
    -- 表Id
    --
    self.tableId = 0;
    
    --
    -- 格子位置
    --
    self.tiledId = 0;
    
    --
    -- 在建设施ID列表
    --
    self.onBuildingFacilityIdList = List.new();
end

return CityModel;
