-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
local WorldTask = class("WorldTask");
local DataEpicEvent = require("Game/Table/model/DataEpicEvent");
local List = require("common/list");

function WorldTask:ctor()

    --
    -- 表ID
    --
    self.tableId = 0;


    self.endTime = 0;
    --
    -- 进度值
    --
    self.paramValueOne = 0;

    --
    -- 达成者的信息List
    --
    self.paramValueTwo = List.new();

    --
    -- 是否达成
    --
    self.isDone = 0;
    --
    -- 是否打开
    --
    self.isOpen = 0;
    --
    -- 达成时间
    --
    self.doneTime = 0;

    --
    -- 是否可以领奖
    --
    self.couldGetAward = 0;

    --
    -- 是否领奖
    --
    self.isGetAward = 0;

    -- 表数据

    self.Data = nil;
end

function WorldTask:GetData()

    return self.Data;

end

function WorldTask:GetTableId()

    return self.tableId

end

function WorldTask:SetAward(boo)

    self.isGetAward = boo

end



return WorldTask

-- endregion
