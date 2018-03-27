-- region *.lua
-- Date
-- 增加同盟经验

local GameMessage = require("common/Net/GameMessage");
local AddLeagueExpience = class("AddLeagueExpience", GameMessage);

function AddLeagueExpience:ctor()
    -- 验证码
    self._playId = 0;
    self._exp = 0;
    AddLeagueExpience.super.ctor(self);
end

-- @override
function AddLeagueExpience:_OnSerial()
    self:WriteInt64(self._playId);
    self:WriteInt32(self._exp);
end

-- @override
function AddLeagueExpience:_OnDeserialize()
    self._playId = self:ReadInt64();
    self._exp = self:ReadInt32();
end

return AddLeagueExpience;

-- endregion


-- endregion
