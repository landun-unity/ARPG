

-- Anchor:Dr
-- Date
-- 登录验证回复

local GameMessage = require("common/Net/GameMessage");

local CreateRoleSuccess = class("CreateRoleSuccess", GameMessage);
   
function CreateRoleSuccess:ctor()
    -- 玩家id
    self.mRoleId = 0;
    CreateRoleSuccess.super.ctor(self);

end




-- @override
function CreateRoleSuccess:_OnSerial()

    self:WriteInt64(self.mRoleId);
end


-- @override
function CreateRoleSuccess:_OnDeserialize()

    self.mRoleId = self:ReadInt64();

end

return CreateRoleSuccess;

-- endregion
