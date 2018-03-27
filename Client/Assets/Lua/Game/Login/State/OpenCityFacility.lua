-- 请求部队信息
local BaseState = require("Game/State/BaseState")

local OpenCityFacility = class("OpenCityFacility", BaseState)

-- 构造函数
function OpenCityFacility:ctor(...)
    OpenCityFacility.super.ctor(self, ...);
end

-- 进入操作
function OpenCityFacility:OnEnterState() 	 	 
    local msg = require("MessageCommon/Msg/C2L/Facility/OpenCityFacility").new();
    msg:SetMessageId(C2L_Facility.OpenCityFacility);
    local mainCityTitled=PlayerService:Instance():GetMainCityTiledId();
    print(BuildingService:Instance():GetBuildingByTiledId(mainCityTitled))
    local buildingId=BuildingService:Instance():GetBuildingByTiledId(mainCityTitled)._id;
    msg.playerid = PlayerService:Instance():GetPlayerId();
    msg.buildingId = buildingId;
    NetService:Instance():SendMessage(msg);

    --请求建造队列
    local msg2 = require("MessageCommon/Msg/C2L/Facility/RequestConstructionQueue").new();
    msg2:SetMessageId(C2L_Facility.RequestConstructionQueue);
    NetService:Instance():SendMessage(msg2);
end


function OpenCityFacility:CanEnterState(stateType)
    if stateType == LoginStateType.RequestRechargeInfo then
        return true;
    end
    return false;
end

-- 离开操作
function OpenCityFacility:OnLeaveState(...)
end

return OpenCityFacility;
