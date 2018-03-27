-- 请求部队信息
local BaseState = require("Game/State/BaseState")

local CreateMap = class("CreateMap", BaseState)

-- 构造函数
function CreateMap:ctor(...)
    CreateMap.super.ctor(self, ...);
end

-- 进入操作
function CreateMap:OnEnterState(...)
    MapService:Instance():CreateMap();
end
-- 创建地图之后必须进请求资源
function CreateMap:CanEnterState(stateType)
    if stateType == LoginStateType.RequestResourceInfo then
        return true;
    end
    return false;
end

-- 离开操作
function CreateMap:OnLeaveState(...)
end



return CreateMap;
