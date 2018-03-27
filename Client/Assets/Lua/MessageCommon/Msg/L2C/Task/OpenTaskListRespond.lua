--
-- 逻辑服务器 --> 客户端
-- 打开可执行任务回复
-- @author czx
--
local List = require("common/List");

local SingleTaskModel = require("MessageCommon/Msg/L2C/Task/SingleTaskModel");

local GameMessage = require("common/Net/GameMessage");
local OpenTaskListRespond = class("OpenTaskListRespond", GameMessage);

--
-- 构造函数
--
function OpenTaskListRespond:ctor()
    OpenTaskListRespond.super.ctor(self);
    --
    -- 任务list
    --
    self.list = List.new();
end

--@Override
function OpenTaskListRespond:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.taskId);
        self:WriteInt32(listValue.taskTableId);
        self:WriteInt32(listValue.taskState);
        
        local listValueparamterlistCount = listValue.paramterlist:Count();
        self:WriteInt32(listValueparamterlistCount);
        for listValueparamterlistIndex = 1, listValueparamterlistCount, 1 do 
            self:WriteInt32(listValue.paramterlist:Get(listValueparamterlistIndex));
        end
    end
end

--@Override
function OpenTaskListRespond:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = SingleTaskModel.new();
        listValue.taskId = self:ReadInt64();
        listValue.taskTableId = self:ReadInt32();
        listValue.taskState = self:ReadInt32();
        
        local listValueparamterlistCount = self:ReadInt32();
        for i = 1, listValueparamterlistCount, 1 do 
            listValue.paramterlist:Push(self:ReadInt32());
        end
        self.list:Push(listValue);
    end
end

return OpenTaskListRespond;
