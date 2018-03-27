--
-- 逻辑服务器 --> 客户端
-- 移除一条基于线的敌方提示
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RemoveEnemyTipsLine = class("RemoveEnemyTipsLine", GameMessage);

--
-- 构造函数
--
function RemoveEnemyTipsLine:ctor()
    RemoveEnemyTipsLine.super.ctor(self);
    --
    -- 线的唯一Id
    --
    self.lineId = 0;
end

--@Override
function RemoveEnemyTipsLine:_OnSerial() 
    self:WriteInt32(self.lineId);
end

--@Override
function RemoveEnemyTipsLine:_OnDeserialize() 
    self.lineId = self:ReadInt32();
end

return RemoveEnemyTipsLine;
