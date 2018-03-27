--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local GameService = require("FrameWork/Game/GameService")
local NewerPeriodManage = require("Game/NewerPeriod/NewerPeriodManage")
local NewerPeriodHandler = require("Game/NewerPeriod/NewerPeriodHandler")

NewerPeriodService = class("NewerPeriodService", GameService)

function NewerPeriodService:ctor()
    NewerPeriodService._instance = self;
    NewerPeriodService.super.ctor(self, NewerPeriodManage.new(), NewerPeriodHandler.new());
end

function NewerPeriodService:Instance()
    return NewerPeriodService._instance;
end

--清空数据
function NewerPeriodService:Clear()
    self._logic:ctor()
end

-- 同步新手保护期阶段及结束时间
function NewerPeriodService:SyncNewerPeriod(curPeriod, endTime)
    self._logic:SyncNewerPeriod(curPeriod, endTime);
end

-- 获取当期新手保护期阶段
function NewerPeriodService:GetCurPeriod()
    return self._logic:GetCurPeriod();
end

function NewerPeriodService:GetEndTime()
    return self._logic:GetEndTime();
end

-- 是否处于新手保护期
function NewerPeriodService:IsInNewerPeriod()
    return self._logic:IsInNewerPeriod();
end

-- 是否新手保护期结束
function NewerPeriodService:IsNewerPeriodEnd()
    return self._logic:IsNewerPeriodEnd();
end

-- 请求服务器验证并开启新手保护期某个阶段
function NewerPeriodService:RequestOpenPeriod(period)
    self._logic:RequestOpenPeriod(period);
end

-- 是否可以屯田
function NewerPeriodService:CanMita()
    return self._logic:CanMita();
end

-- 是否可以练兵
function NewerPeriodService:CanTrain()
    return self._logic:CanTrain();
end

-- 是否可以驻守
function NewerPeriodService:CanGarrison()
    return self._logic:CanGarrison();
end

return NewerPeriodService;

--endregion
