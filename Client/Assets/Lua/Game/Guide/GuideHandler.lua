--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local IOHandler = require("FrameWork/Game/IOHandler")
local GuideHandler = class("GuideHandler", IOHandler)

-- 构造函数
function GuideHandler:ctor()
    GuideHandler.super.ctor(self);
end

-- 注册所有消息
function GuideHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Player.SyncGuide, self.SyncGuide, require("MessageCommon/Msg/L2C/Player/SyncGuide"));
end

-- 同步新手引导进度
function GuideHandler:SyncGuide(msg)
    self._logicManage:SyncGuide(msg);
end

return GuideHandler;

--endregion
