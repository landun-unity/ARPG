--
-- 逻辑服务器 --> 客户端
-- 同步建筑物信息
-- @author czx
--
local PlayerBuilding = class("PlayerBuilding");

function PlayerBuilding:ctor()
    --
    -- 名称
    --
    self.tiledId = 0;
    
    --
    -- 所有者Id
    --
    self.ownerId = 0;
    
    --
    -- 帮派Id
    --
    self.leagueId = 0;
    
    --
    -- 表格Id
    --
    self.tableId = 0;
end

return PlayerBuilding;
