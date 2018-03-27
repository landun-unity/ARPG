--
-- 逻辑服务器 --> 客户端
-- 个人战报未读消息个数
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local BattleReportUnReadCount = class("BattleReportUnReadCount", GameMessage);

--
-- 构造函数
--
function BattleReportUnReadCount:ctor()
    BattleReportUnReadCount.super.ctor(self);
    --
    -- 未读消息个数
    --
    self.unReadCount = 0;
end

--@Override
function BattleReportUnReadCount:_OnSerial() 
    self:WriteInt32(self.unReadCount);
end

--@Override
function BattleReportUnReadCount:_OnDeserialize() 
    self.unReadCount = self:ReadInt32();
end

return BattleReportUnReadCount;
