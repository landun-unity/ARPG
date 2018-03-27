--
-- 逻辑服务器 --> 客户端
-- 玩家的一页卡牌
-- @author czx
--
local CardMapLightModel = class("CardMapLightModel");

function CardMapLightModel:ctor()
    --
    -- 卡牌tableId
    --
    self.id = 0;
end

return CardMapLightModel;
