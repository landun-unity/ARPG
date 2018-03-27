--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local GameService = require("FrameWork/Game/GameService")
local LoginActManage = require("Game/Activity/Login/LoginActManage")
local LoginActHandler = require("Game/Activity/Login/LoginActHandler")

LoginActService = class("LoginActService", GameService)

function LoginActService:ctor()
    LoginActService._instance = self;
    LoginActService.super.ctor(self, LoginActManage.new(), LoginActHandler.new());
end

function LoginActService:Instance()
    return LoginActService._instance
end

--清空数据
function LoginActService:Clear()
    self._logic:ctor()
end


-- 获取当前轮次所有表数据
function LoginActService:GetCurAllDataList()
    return self._logic:GetCurAllDataList();
end

-- 获取当前领取到了第几天
function LoginActService:GetCurDay()
    return self._logic:GetCurDay();
end

-- 获取当前是否可领
function LoginActService:GetIsCanGet()
    return self._logic:GetIsCanGet();
end

-- 登陆游戏以及零点初始化请求
function LoginActService:InitRequest()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestLoginGiftInfo").new();
    msg:SetMessageId(C2L_Player.RequestLoginGiftInfo);
    NetService:Instance():SendMessage(msg);
end

-- 领取请求
function LoginActService:GetLoginGiftRequest()
    local msg = require("MessageCommon/Msg/C2L/Player/RequestLoginGift").new();
    msg:SetMessageId(C2L_Player.RequestLoginGift);
    NetService:Instance():SendMessage(msg);
end

return LoginActService

--endregion
