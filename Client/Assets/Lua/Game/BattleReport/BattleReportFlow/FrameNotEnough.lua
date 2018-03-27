-- Õ½±¨¿¨ÅÆ

local FrameNotEnough = class("FrameNotEnough");
function FrameNotEnough:ctor()

    -- Õ½±¨»ØºÏÍâ²¿µÄÀàÐÍ -- OutOfBattleReportType
    self.OutType = OutOfBattleReportType.FrameNotEnough
    -- self.NullReportReasonType = 0;
end

function FrameNotEnough:_OnDeserialize(byteArray)
    -- self.NullReportReasonType = byteArray:ReadInt32();
end

return FrameNotEnough