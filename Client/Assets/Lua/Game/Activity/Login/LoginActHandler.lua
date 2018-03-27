--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local IOHandler = require("FrameWork/Game/IOHandler")
local LoginActHandler = class("LoginActHandler", IOHandler)

-- 构造函数
function LoginActHandler:ctor()
    -- body
    LoginActHandler.super.ctor(self);
end

-- 注册所有消息
function LoginActHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Player.LoginGift, self.UpdateLoginActData, require("MessageCommon/Msg/L2C/Player/LoginGift"));
end

function LoginActHandler:UpdateLoginActData(msg)
    self._logicManage:UpdateLoginActData(msg);
end

return LoginActHandler;

--endregion