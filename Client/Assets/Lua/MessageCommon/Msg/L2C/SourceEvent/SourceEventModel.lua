--
-- 逻辑服务器 --> 客户端
-- 资源地消息
-- @author czx
--
local SourceEventModel = class("SourceEventModel");

function SourceEventModel:ctor()
    --
    -- 资源地事件ID
    --
    self.iD = 0;
    
    --
    -- 资源地类型 武将经验书 和 卡包
    --
    self.eventType = 0;
    
    --
    -- 资源地ID
    --
    self.eventTableID = 0;
    
    --
    -- 资源地地点X坐标
    --
    self.positionX = 0;
    
    --
    -- 资源地地点Y坐标
    --
    self.positionY = 0;
    
    --
    -- 资源地结束时间戳
    --
    self.endTime = 0;
    
    --
    -- 计时器ID
    --
    self.timer = 0;
end

return SourceEventModel;
