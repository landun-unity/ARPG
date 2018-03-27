--
-- 逻辑服务器 --> 客户端
-- 打开拥有野外建筑回复
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local OpenOwnWildBuildRespond = class("OpenOwnWildBuildRespond", GameMessage);

--
-- 构造函数
--
function OpenOwnWildBuildRespond:ctor()
    OpenOwnWildBuildRespond.super.ctor(self);
    --
    -- 野外建筑list
    --
    self.list = List.new();
end

--@Override
function OpenOwnWildBuildRespond:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        self:WriteInt64(self.list:Get(listIndex));
    end
end

--@Override
function OpenOwnWildBuildRespond:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        self.list:Push(self:ReadInt64());
    end
end

return OpenOwnWildBuildRespond;
