--
-- 逻辑服务器 --> 客户端
-- 没有盟的回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenNoLeagueBack = class("OpenNoLeagueBack", GameMessage);

--
-- 构造函数
--
function OpenNoLeagueBack:ctor()
    OpenNoLeagueBack.super.ctor(self);
    --
    -- 入盟冷却时间
    --
    self.joinCoolingTime = 0;
end

--@Override
function OpenNoLeagueBack:_OnSerial() 
    self:WriteInt64(self.joinCoolingTime);
end

--@Override
function OpenNoLeagueBack:_OnDeserialize() 
    self.joinCoolingTime = self:ReadInt64();
end

return OpenNoLeagueBack;
