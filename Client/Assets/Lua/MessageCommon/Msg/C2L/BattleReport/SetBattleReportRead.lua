--
-- 客户端 --> 逻辑服务器
-- 把此类型所有的战报设为已读
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SetBattleReportRead = class("SetBattleReportRead", GameMessage);

--
-- 构造函数
--
function SetBattleReportRead:ctor()
    SetBattleReportRead.super.ctor(self);
    --
    -- 战报分组 1个人 3.演武
    --
    self.battleReportGroup = 0;
end

--@Override
function SetBattleReportRead:_OnSerial() 
    self:WriteInt32(self.battleReportGroup);
end

--@Override
function SetBattleReportRead:_OnDeserialize() 
    self.battleReportGroup = self:ReadInt32();
end

return SetBattleReportRead;
