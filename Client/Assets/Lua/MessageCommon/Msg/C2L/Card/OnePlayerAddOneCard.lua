--
-- 客户端 --> 逻辑服务器
-- 添加一张卡牌
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OnePlayerAddOneCard = class("OnePlayerAddOneCard", GameMessage);

--
-- 构造函数
--
function OnePlayerAddOneCard:ctor()
    OnePlayerAddOneCard.super.ctor(self);
    --
    -- 玩家Id
    --
    self.playerID = 0;
    
    --
    -- 表Id
    --
    self.tableID = 0;
end

--@Override
function OnePlayerAddOneCard:_OnSerial() 
    self:WriteInt64(self.playerID);
    self:WriteInt32(self.tableID);
end

--@Override
function OnePlayerAddOneCard:_OnDeserialize() 
    self.playerID = self:ReadInt64();
    self.tableID = self:ReadInt32();
end

return OnePlayerAddOneCard;
