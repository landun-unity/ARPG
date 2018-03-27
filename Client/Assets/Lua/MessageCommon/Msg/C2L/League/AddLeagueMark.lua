--
-- 客户端 --> 逻辑服务器
-- 增加同盟标记
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local AddLeagueMark = class("AddLeagueMark", GameMessage);

--
-- 构造函数
--
function AddLeagueMark:ctor()
    AddLeagueMark.super.ctor(self);
    --
    -- 标记名字
    --
    self.name = "";
    
    --
    -- 标记坐标
    --
    self.coord = 0;
    
    --
    -- 标记描述
    --
    self.description = "";
end

--@Override
function AddLeagueMark:_OnSerial() 
    self:WriteString(self.name);
    self:WriteInt32(self.coord);
    self:WriteString(self.description);
end

--@Override
function AddLeagueMark:_OnDeserialize() 
    self.name = self:ReadString();
    self.coord = self:ReadInt32();
    self.description = self:ReadString();
end

return AddLeagueMark;
