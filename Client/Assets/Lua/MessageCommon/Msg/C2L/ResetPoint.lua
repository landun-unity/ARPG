--region *.lua
--Date

local GameMessage = require("common/Net/GameMessage");
local ResetPoint = class("ResetPoint", GameMessage);


function ResetPoint:ctor()
    -- 玩家id

    self.cardID = 0;
 
    ResetPoint.super.ctor(self);
end


-- @override
function ResetPoint:_OnSerial()

    self:WriteInt64(self.cardID);


end


-- @override
function ResetPoint:_OnDeserialize()

    self.cardID = self:ReadInt64();

end

return ResetPoint;

--endregion
