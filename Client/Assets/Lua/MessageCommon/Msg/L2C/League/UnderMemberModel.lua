--
-- 逻辑服务器 --> 客户端
-- 下属成员model
-- @author czx
--
local UnderMemberModel = class("UnderMemberModel");

function UnderMemberModel:ctor()
    --
    -- 玩家id
    --
    self.playerId = 0;
    
    --
    -- 玩家名字
    --
    self.name = "";
    
    --
    -- 玩家坐标
    --
    self.coord = 0;
end

return UnderMemberModel;
