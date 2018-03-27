-- 登录消息处理
local IOHandler = require("FrameWork/Game/IOHandler")
local MapHandler = class("MapHandler", IOHandler)

-- 构造函数
function MapHandler:ctor()
    -- body
    MapHandler.super.ctor(self);
end

-- 注册所有消息
function MapHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Map.SyncRegionTiled, self.HandleRegionTiled, require("MessageCommon/Msg/L2C/Map/SyncRegionTiled"));
    self:RegisterMessage(L2C_Map.SyncTiled, self.HandleTiled, require("MessageCommon/Msg/L2C/Map/SyncTiled"));
    self:RegisterMessage(L2C_Player.ScreenCenterReply, self.HandleScreenCenterReply, require("MessageCommon/Msg/L2C/Player/ScreenCenterReply"));
    -- self:RegisterMessage(L2C_Map.SyncLine, self.HandleRegionLine, require("MessageCommon/Msg/L2C/Map/SyncLine"));
     self:RegisterMessage(L2C_Player.ResponseOtherPlayerBaseInfo, self.HandleOtherPlayerBaseInfo, require("MessageCommon/Msg/L2C/Player/ResponseOtherPlayerBaseInfo"));
end

-- 处理区域格子
function MapHandler:HandleRegionTiled(msg)
    self._logicManage:HandleRegionTiled(msg);
end

-- 处理单个格子
function MapHandler:HandleTiled(msg)
    self._logicManage:HandleSingleTiled(msg);
end

-- 回复消息了
function MapHandler:HandleScreenCenterReply()
end

-- 处理区域中线信息
function MapHandler:HandleRegionLine(msg)
    local count = msg.allLineList:Count();
    for i = 1, count do
        local lineInfo = msg.allLineList:Get(i)
        if lineInfo ~= nil then

        end
    end
end

-- 360度
function MapHandler:Angle_360(from, to)
    local v3 = Vector3.Cross(from, to);

    if v3.z > 0 then
        return Vector3.Angle(from, to);
    else
        return 360 - Vector3.Angle(from, to);
    end
end

-- 其它玩家信息回复
function MapHandler:HandleOtherPlayerBaseInfo(msg)
    UIService:Instance():ShowUI(UIType.PlayerInformationUI, msg);
end

return MapHandler;