--
-- 逻辑服务器 --> 客户端
-- 同步线信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyOperationTipsMsg = class("ArmyOperationTipsMsg", GameMessage);

--
-- 构造函数
--
function ArmyOperationTipsMsg:ctor()
    ArmyOperationTipsMsg.super.ctor(self);
    --
    -- 提示消息类型
    --
    self.mType = 0;
end

--@Override
function ArmyOperationTipsMsg:_OnSerial() 
    self:WriteInt32(self.mType);
end

--@Override
function ArmyOperationTipsMsg:_OnDeserialize() 
    self.mType = self:ReadInt32();
end

return ArmyOperationTipsMsg;
