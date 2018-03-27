--
-- 逻辑服务器 --> 客户端
-- 同步一张卡牌
-- @author czx
--
local List = require("common/List");

local SingleFacilityModel = require("MessageCommon/Msg/L2C/Facility/SingleFacilityModel");

local CityFacilityModel = class("CityFacilityModel");

function CityFacilityModel:ctor()
    --
    -- 建筑物id
    --
    self.buildId = 0;
    
    --
    -- 格子list
    --
    self.list = List.new();
end

return CityFacilityModel;
