--
-- 一条线的信息
--
local Arrow = require("Game/Line/Arrow")
local Line = class("Line");

function Line:ctor()
    -- 线的Id
    self.id = 0;
    -- 所有的箭头
    self.allArrowMap = {};
    -- 开始时间
    self.startTime = 0;
    -- 结束时间
    self.endTime = 0;
    -- 开始格子
    self.startTiledId = 0;
    -- 结束格子
    self.endTiledId = 0;
    -- 角度
    self.angle = 0;
    -- 玩家ID
    self.playerId = 0;
    -- 玩家名称
    self.playerName = "";
    -- 同盟Id
    self.leagueId = 0;
    -- 部队的建筑物Id
    self.buildingId = 0;
    -- 部队的槽位索引
    self.armySlotIndex = 0;
    -- 终点旗子
    self.endFlag = nil;
    -- 部队标志上面的类
    self.uiArmyFlag = nil;
    self.commonSlider = nil;
    -- 是否拥有线起点格子的视野
    self.isHaveStartTiledView = false;
    -- 是否拥有线终点格子的视野
    self.isHaveEndTiledView = false;
    -- 是否拥有线起点或终点格子的个人视野（左侧敌方部队提示使用）
    self.isHavePersionalView = false;
    -- 当前线是否可见
    self.isVisible = false;
end

-- 插入一个箭头
function Line:InsertArrow(arrow)
    if arrow == nil or arrow.id == nil or self.allArrowMap[arrow.id] ~= nil then
        return;
    end

    self.allArrowMap[arrow.id] = arrow;
end

-- 移除箭头
function Line:RemoveArrow(arrowId)
    if arrowId == nil then
        return;
    end

    self.allArrowMap[arrowId] = nil;
end

-- 箭头数量
function Line:GetArrowCount()
    return #self.allArrowMap;
end

-- 获取箭头
function Line:GetArrow(arrowId)
    if arrowId == nil then
        return nil;
    end

    return self.allArrowMap[arrowId];
end

-- 创建箭头
function Line:CreateArrow(arrowId, x, y, passTime)
    local arrow = Arrow.new();
    arrow.lineId = self.id;
    arrow.x = x;
    arrow.y = y;
    arrow.id = arrowId;
    arrow.passTime = passTime;
    arrow.tiledIndex = MapService:Instance():GetTiledIndex(math.floor(x), math.floor(y));
    self:InsertArrow(arrow);

    return arrow;
end

-- 清空
function Line:Clear()
    self.allArrowMap = {};
    self.allTiledHasArrowMap = {};
end

function Line:GetPlayerName()
    return self.playerName;
end

function Line:GetStartTiledId()
    return self.startTiledId;
end

function Line:GetEndTiledId()
    return self.endTiledId;
end

-- 判断是否为别人的部队
function Line:IsOtherArmy()
    return self.playerId ~= PlayerService:Instance():GetPlayerId();
end

-- 判断是否为敌方的部队
function Line:IsEnemyArmy()
    if self.playerId == PlayerService:Instance():GetPlayerId() then
        return false;
    else
        if PlayerService:Instance():GetLeagueId() == 0 then
            return true;
        else
            if self.leagueId == PlayerService:Instance():GetLeagueId() then
                return false;
            else
                return true;
            end
        end
    end
end

--刷新线是否可见
function Line:CheckIsVisiable()
    if self:IsEnemyArmy() == false then
        self.isVisible = true;
    else
        if self.isHaveStartTiledView == true then
            self.isVisible = true;
        elseif self.isHaveEndTiledView == true then
            local currentTime = PlayerService:Instance():GetLocalTime();
            if self.endTime - currentTime > 10000 then
                self.isVisible = false;
            else
                self.isVisible = true;
            end
        else
            self.isVisible = false;
        end
    end
end

return Line
