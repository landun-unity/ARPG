--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local IOHandler = require("FrameWork/Game/IOHandler")
local NewerPeriodHandler = class("NewerPeriodHandler", IOHandler)

-- 构造函数
function NewerPeriodHandler:ctor()
    NewerPeriodHandler.super.ctor(self);
end

-- 注册所有消息
function NewerPeriodHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Player.SyncNewerPeriod, self.SyncNewerPeriod, require("MessageCommon/Msg/L2C/Player/SyncNewerPeriod"));
end

-- 同步新手引导进度
function NewerPeriodHandler:SyncNewerPeriod(msg)
    self._logicManage:SyncNewerPeriod(msg.curNewerPeriod, msg.newerPeriodEndTime);
end

return NewerPeriodHandler;

--endregion
