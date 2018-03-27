--
-- 逻辑服务器 --> 客户端
-- 进阶卡牌失败
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local AdvanceOneCardError = class("AdvanceOneCardError", GameMessage);

--
-- 构造函数
--
function AdvanceOneCardError:ctor()
    AdvanceOneCardError.super.ctor(self);
    --
    -- 进阶失败类型
    --
    self.advanceErrorType = 0;
end

--@Override
function AdvanceOneCardError:_OnSerial() 
    self:WriteInt32(self.advanceErrorType);
end

--@Override
function AdvanceOneCardError:_OnDeserialize() 
    self.advanceErrorType = self:ReadInt32();
end

return AdvanceOneCardError;
