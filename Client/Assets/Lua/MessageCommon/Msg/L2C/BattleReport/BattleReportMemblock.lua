--
-- 逻辑服务器 --> 客户端
-- 战报消息结构
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local BattleReportMemblock = class("BattleReportMemblock", GameMessage);

--
-- 构造函数
--
function BattleReportMemblock:ctor()
    BattleReportMemblock.super.ctor(self);
    --
    -- 未读消息个数
    --
    self.reportid = 0;
    
    --
    -- 战报二进制流
    --
    self.memblock = nil;
end

--@Override
function BattleReportMemblock:_OnSerial() 
    self:WriteInt64(self.reportid);
    self:WriteMemBlock(self.memblock);
end

--@Override
function BattleReportMemblock:_OnDeserialize() 
    self.reportid = self:ReadInt64();
    self.memblock = self:ReadMemBlock();
end

return BattleReportMemblock;
