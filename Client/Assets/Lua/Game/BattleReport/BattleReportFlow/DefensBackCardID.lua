
local DefensBackCardID = class("DefensBackCardID");
function DefensBackCardID:ctor()

    -- Õ½±¨»ØºÏÍâ²¿µÄÀàÐÍ -- OutOfBattleReportType
    self.OutType = OutOfBattleReportType.DefensBackCardID
    
    self.CardID = 0;
end

function DefensBackCardID:_OnDeserialize(byteArray)
    self.CardID = byteArray:ReadInt32();
end

return DefensBackCardID