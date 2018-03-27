--
-- 逻辑服务器 --> 客户端
-- 一个已占领的野城的信息
-- @author czx
--
local OccupyWildCityModel = class("OccupyWildCityModel");

function OccupyWildCityModel:ctor()
    --
    -- 建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 建筑物所在格子索引
    --
    self.index = 0;
    
    --
    -- 占领盟id
    --
    self.occupyLeagueId = 0;
    
    --
    -- 占领盟名称
    --
    self.occupyLeagueName = "";
end

return OccupyWildCityModel;
