

-- Anchor:Dr
-- Date
-- 登录验证回复

local GameMessage = require("common/Net/GameMessage");

local VerifySuccess = class("VerifySuccess", GameMessage);
   
function VerifySuccess:ctor()
    -- 玩家id
    self.mRoleId = 0;
    VerifySuccess.super.ctor(self);

end




-- @override
function VerifySuccess:_OnSerial()

    self:WriteInt64(self.mRoleId);
end


-- @override
function VerifySuccess:_OnDeserialize()

    self.mRoleId = self:ReadInt64();

end

return VerifySuccess;

-- endregion
