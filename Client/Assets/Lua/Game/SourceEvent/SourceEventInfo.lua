--
-- 逻辑服务器 --> 客户端
-- 资源地消息
-- @author czx
--
local SourceEventInfo = class("SourceEventInfo");

function SourceEventInfo:ctor()
    --
    -- 资源地ID
    --
    self._iD = 0;
    
    --
    -- 资源地类型 武将经验书 和 卡包
    --
    self._eventType = 0;
    
    --
    -- 资源地ID
    --
    self._eventTableID = 0;
    
    --
    -- 资源地地点X坐标
    --
    self._positionX = 0;
    
    --
    -- 资源地地点Y坐标
    --
    self._positionY = 0;
    
    --
    -- 资源地结束时间戳
    --
    self._endTime = 0;
end

function SourceEventInfo:TransModel(model)
    self._iD = model.iD;
    self._eventType = model.eventType;
    self._eventTableID = model.eventTableID;
    self._positionX = model.positionX;
    self._positionY = model.positionY;
    self._endTime = model.endTime;
end

return SourceEventInfo;
