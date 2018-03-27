

-- Anchor:Dr
-- Date
-- 真正处理禅让

local GameMessage = require("common/Net/GameMessage");

local RealHandlerDemise = class("RealHandlerDemise", GameMessage);
   
function RealHandlerDemise:ctor()
    -- 玩家id
    self.oldId = 0;
    self.newId=0;
    RealHandlerDemise.super.ctor(self);

end

-- @override
function RealHandlerDemise:_OnSerial()
    self:WriteInt64(self.oldId);
    self:WriteInt64(self.newId);
end


-- @override
function RealHandlerDemise:_OnDeserialize()
    self.oldId = self:ReadInt64();
    self.newId = self:ReadInt64();

end

return RealHandlerDemise;

-- endregion

