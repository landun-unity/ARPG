--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
local NewerPeriodType = require("Game/NewerPeriod/NewerPeriodType");

local GamePart = require("FrameWork/Game/GamePart");
local NewerPeriodManage = class("NewerPeriodManage", GamePart);

-- 构造函数
function NewerPeriodManage:ctor()
    NewerPeriodManage.super.ctor(self);
    -- 新手期当前阶段
    self._curPeriod = NewerPeriodType.None;
    -- 新手期结束时间
    self._endTime = 0;
end

-- 初始化
function NewerPeriodManage:_OnInit()
	
end

-- 同步新手保护期阶段及结束时间
function NewerPeriodManage:SyncNewerPeriod(curPeriod, endTime)
    self._curPeriod = curPeriod;
    self._endTime = endTime;
end

-- 获取当期新手保护期阶段
function NewerPeriodManage:GetCurPeriod()
    return self._curPeriod;
end

function NewerPeriodManage:GetEndTime()
    return self._endTime;
end

-- 是否处于新手保护期
function NewerPeriodManage:IsInNewerPeriod()
    if self._curPeriod >= NewerPeriodType.StartNewerPeriod and self._curPeriod < NewerPeriodType.NewerPeriodEnd then
        return true;
    else
        return false;
    end
end

-- 是否新手保护期结束
function NewerPeriodManage:IsNewerPeriodEnd()
    if self._curPeriod >= NewerPeriodType.NewerPeriodEnd then
        return true;
    else
        return false;
    end
end

-- 是否可以屯田
function NewerPeriodManage:CanMita()
    if self._curPeriod >= NewerPeriodType.OpenMitaFunc then
        return true;
    else
        return false;
    end
end

-- 是否可以练兵
function NewerPeriodManage:CanTrain()
    if self._curPeriod >= NewerPeriodType.OpenTrainFunc then
        return true;
    else
        return false;
    end
end

-- 是否可以驻守
function NewerPeriodManage:CanGarrison()
    if self._curPeriod >= NewerPeriodType.OpenGarrisonFunc then
        return true;
    else
        return false;
    end
end

-- 请求服务器验证并开启新手保护期某个阶段
function NewerPeriodManage:RequestOpenPeriod(period)
    local msg = require("MessageCommon/Msg/C2L/Player/RequestOpenNewerPeriod").new();
    msg:SetMessageId(C2L_Player.RequestOpenNewerPeriod);
    msg.newerPeriod = period;
    NetService:Instance():SendMessage(msg);
end

return NewerPeriodManage;

--endregion
