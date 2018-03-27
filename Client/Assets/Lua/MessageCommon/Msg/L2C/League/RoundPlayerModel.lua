--
-- 逻辑服务器 --> 客户端
-- 打开周围玩家回复
-- @author czx
--
local RoundPlayerModel = class("RoundPlayerModel");

function RoundPlayerModel:ctor()
    --
    -- 玩家id
    --
    self.playerId = 0;
    
    --
    -- 名字
    --
    self.name = "";
    
    --
    -- 势力
    --
    self.influence = 0;
    
    --
    -- 省份
    --
    self.province = 0;
    
    --
    -- 坐标
    --
    self.coord = 0;
    
    --
    -- 是否已被邀请
    --
    self.isInvented = false;
end

return RoundPlayerModel;
