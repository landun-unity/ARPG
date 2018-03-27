--
-- 逻辑服务器 --> 客户端
-- 同盟标记model
-- @author czx
--
local MarkModel = class("MarkModel");

function MarkModel:ctor()
    --
    -- 标记id
    --
    self.id = 0;
    
    --
    -- 标记名字
    --
    self.name = "";
    
    --
    -- 描述
    --
    self.description = "";
    
    --
    -- 发布者id
    --
    self.publisherId = 0;
    
    --
    -- 标记人名字
    --
    self.publistName = "";
    
    --
    -- 官位
    --
    self.title = 0;
    
    --
    -- 标记坐标
    --
    self.coord = 0;
    
    --
    -- 土地等级
    --
    self.tiledLevel = 0;
end

return MarkModel;
