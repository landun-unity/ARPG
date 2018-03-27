-- region *.lua
-- Date 16/9/14
-- 同盟信息类
local LeagueMark = class("LeagueMark");

function LeagueMark:ctor()

    self.id = 0;

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

    self.title = nil;

    self.publisherid =nil;

    self.publishname = nil;

    self.tiledLv = nil;
end

function LeagueMark:GetName()
    return self.name;
end

function LeagueMark:GetDescription()
    return self.description
end



return LeagueMark;
