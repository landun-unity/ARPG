-- 路径线管理
local GamePart = require("FrameWork/Game/GamePart")
local LineManage = class("LineManage", GamePart)
local Line = require("Game/Line/Line")
local List = require("common/List")
local CommonSliderType = require("Game/Common/CommonSliderType")
local EnemyTipBattle = require("Game/Line/EnemyTipBattle")

-- 构造函数
function LineManage:ctor()
    LineManage.super.ctor(self)
    self.allLineMap = {}
    -- 所有的箭头 TiledIndex --> { lineId --> { arrowId --> arrow } }
    self.allArrowMap = {};
    -- 箭头缓存
    self._cacheArrowQueue = Queue.new();
    -- 普通的终点旗子
    self.commonFlagQueue = Queue.new();
    -- 部队标志上面的类
    self.uiArmyFlagQueue = Queue.new();
    -- 部队倒计时(UICommonSlider)
    self.uiArmySliderQueue = Queue.new();

    -- 所有箭头的父亲
    self.lineParent = nil;
    --所有旗帜的父亲
    self.flagParent = nil;
    --所有倒计时的父亲
    self.sliderParent = nil;

    -- 删除列表
    self.removeList = List.new();
    -- 当前选中的line的id
    self.choosedLineId = 0;

    -- 单个箭头长度
    self._arrowLength = 0.2;

    -- 敌方提示（基于线）列表
    self._enemyTipsLineMap = {};
    -- 敌方提示（基于战平部队）列表
    self._enemyTipsBattleMap = {};
end

-- 初始化
function LineManage:_OnInit()
end

-- 心跳
function LineManage:_OnHeartBeat()
    self:CheckAllLine();
    self:RemoveLineOnHeartBeat();
    self:RefreshAllLineVisiable();
    self:RefreshAllEnemyTipsLineVisiable();
    self:RefreshAllLine();
    self:RefreshAllArmyPosition();
    self:RefreshMapFollowArmy();
end

-- 停止
function LineManage:_OnStop()
end

-- 添加线
function LineManage:AddLine(line)
    if line == nil or line.id == nil or self.allLineMap[line.id] ~= nil then
        return;
    end

    self.allLineMap[line.id] = line;
end

-- 获取线
function LineManage:GetLine(lineId)
    if lineId == nil then
        return nil;
    end

    return self.allLineMap[lineId];
end

-- 移除线
function LineManage:RemoveLine(lineId)
    if lineId == nil then
        return;
    end

    local line = self:GetLine(lineId);
    if line == nil then
        return;
    end

    for k,v in pairs(line.allArrowMap) do
        self:RemoveArrowInTiled(v);
        self:RecoveryArrow(v);
    end

    if line.id == self.choosedLineId then
        self:CancelArmyChoose();
    end
    self:HideEndFlag(line);
    self:HideArmy(line);
    line:Clear();
    self.allLineMap[lineId] = nil;
end

-- 移除线的箭头
--[[function LineManage:RemoveArrow(lineId, arrowId)
    if lineId == nil or arrowId == nil then
        return;
    end

    local line = self:GetLine(lineId);
    if line == nil then
        return;
    end
    local arrow = line:GetArrow(arrowId);
    if arrow == nil then
        return;
    end

    self:RemoveArrowInLine(line, arrow);
    self:RemoveArrowInTiled(arrow);
end--]]

-- 移除箭头
function LineManage:RemoveArrowInLine(line, arrow)
    self:RecoveryArrow(arrow);
    --line:RemoveArrow(arrow.id);
end

-- 隐藏格子时隐藏上面的箭头和终点旗子
function LineManage:RemoveTiled(tiled)
    if tiled == nil or tiled:GetIndex() == nil then
        return;
    end

    local tiledLine = self.allArrowMap[tiled:GetIndex()];
    if tiledLine == nil then
        return;
    end

    for lineId, lineArrow in pairs(tiledLine) do
        local line = self:GetLine(lineId);
        if line ~= nil then
            for arrowId , arrow in pairs(lineArrow) do
                self:RemoveArrowInLine(line, arrow);
            end
        end
    end

    --self.allArrowMap[tiled:GetIndex()] = nil;
    self:OnHideTiled(tiled);
end

-- 当格子显示的时候显示上面的箭头和终点旗子
function LineManage:OnShowTiled(tiled)
    if tiled == nil or tiled:GetIndex() == nil then
        return;
    end

    local tiledLine = self.allArrowMap[tiled:GetIndex()];
    if tiledLine == nil then
        return;
    end

    for lineId, lineArrow in pairs(tiledLine) do
        local line = self:GetLine(lineId);
        if line ~= nil then
            for arrowId , arrow in pairs(lineArrow) do
                self:ShowLineArrow(line, arrow);
            end
        end
    end
end

-- 移除线的箭头
function LineManage:RemoveArrowInTiled(arrow)
    if arrow == nil or arrow.id == nil or arrow.lineId == nil then
        return;
    end

    local tiledLine = self.allArrowMap[arrow.tiledIndex];
    if tiledLine == nil then
        return;
    end

    local allArrow = tiledLine[arrow.lineId];
    if allArrow == nil then
        return;
    end

    allArrow[arrow.id] = nil;
    --table.remove(allArrow, arrow.id);
    --if #allArrow == 0 then
    if next(allArrow) == nil then
        tiledLine[arrow.lineId] = nil;
        --table.remove(tiledLine, arrow.lineId);
    end

    --if #tiledLine == 0 then
    if next(tiledLine) == nil then
        self.allArrowMap[arrow.tiledIndex] = nil;
        --table.remove(self.allArrowMap, arrow.tiledIndex);
    end
end

-- 360度
function LineManage:Angle_360(from, to)
	local v3 = Vector3.Cross(from, to);

	if v3.z > 0 then
		return Vector3.Angle(from, to);
	else
		return 360 - Vector3.Angle(from, to);
	end
end

-- 求线的角度
function LineManage:GetLineAngle(startTiledId, endTiledId)
    local startPosition = MapService:Instance():GetTiledPositionByIndex(startTiledId);
    local endPosition = MapService:Instance():GetTiledPositionByIndex(endTiledId);

    return self:Angle_360(Vector3.New(1, 0, 0), endPosition - startPosition);
end

-- 同步所有线 不在列表的删掉
function LineManage:HandleSynePlayerAllLine(msg)
    local lineCount = msg.allLineList:Count();
    if lineCount <= 0 then
        for k,v in pairs(self.allLineMap) do
            if v ~= nil and v.playerId ~= PlayerService:Instance():GetPlayerId() then
                self:RemoveLine(v.id);
            end
        end
        return;
    end
    
    local oldLineMap = {};
    for k,v in pairs(self.allLineMap) do
        oldLineMap[v.id] = v;
    end

    for i = 1, lineCount do
        local lineInfo = msg.allLineList:Get(i);
        self:HandleAddLine(lineInfo);
        if oldLineMap[lineInfo.lineId + 1] ~= nil then
            oldLineMap[lineInfo.lineId + 1] = nil;
        end
    end

    for k,v in pairs(oldLineMap) do
        if v ~= nil and v.playerId ~= PlayerService:Instance():GetPlayerId() then
            self:RemoveLine(v.id);
        end
    end
    oldLineMap = {};
end

-- 添加线
function LineManage:HandleAddLine(lineInfo)
    if lineInfo == nil then
        return;
    end

    local x1, y1 = MapService:Instance():GetTiledCoordinate(lineInfo.startTiled);
    local x2, y2 = MapService:Instance():GetTiledCoordinate(lineInfo.endTiled);
    local line = self:GetLine(lineInfo.lineId + 1);
    if line ~= nil then
        return;
    end

    line = self:CreateLine(lineInfo.lineId + 1, lineInfo.startTiled, lineInfo.endTiled, lineInfo.startTime, lineInfo.endTime, 
        lineInfo.playerId, lineInfo.playerName, lineInfo.leagueId, lineInfo.superiorLeagueId, lineInfo.buildingId, lineInfo.armySlotIndex + 1,
        lineInfo.isHaveStartTiledView, lineInfo.isHaveEndTiledView, lineInfo.isHaveStartPersionalView, lineInfo.isHaveEndPersionalView);
    
    self:CalcArrowAndShow(line);
end

-- 创建线
function LineManage:CreateLine(lineId, startTiledId, endTiledId, startTime, endTime, playerId, playerName, leagueId, superiorLeagueId, buildingId, armySlotIndex, isHaveStartTiledView, isHaveEndTiledView, isHaveStartPersionalView, isHaveEndPersionalView)
    local line = Line.new();
    line.id = lineId;
    line.startTime = startTime;
    line.endTime = endTime;
    line.startTiledId = startTiledId;
    line.endTiledId = endTiledId;
    line.playerId = playerId;
    line.playerName = playerName;
    line.leagueId = leagueId;
    line.superiorLeagueId = superiorLeagueId;
    line.buildingId = buildingId;
    line.armySlotIndex = armySlotIndex;
    line.angle = self:GetLineAngle(startTiledId, endTiledId);
    line.isHaveStartTiledView = isHaveStartTiledView;
    line.isHaveEndTiledView = isHaveEndTiledView;
    if isHaveStartPersionalView == true or isHaveEndPersionalView == true then
        line.isHavePersionalView = true;
    end
    line:CheckIsVisiable();
    self:AddLine(line);

    return line;
end

-- 根据line计算所有arrow并显示
function LineManage:CalcArrowAndShow(line)
    local startX, startY = MapService:Instance():GetTiledCoordinate(line:GetStartTiledId());
    local endX, endY = MapService:Instance():GetTiledCoordinate(line:GetEndTiledId());
    local xDis = endX - startX;
    local yDis = endY - startY;
    local lineLength = math.sqrt(math.abs(xDis) * math.abs(xDis) + math.abs(yDis) * math.abs(yDis));
    local arrowCount = math.floor(lineLength / self._arrowLength);
    local xOffset = xDis / arrowCount;
    local yOffset = yDis / arrowCount;
    local timeOffset = 0;
    if arrowCount > 0 then
        timeOffset = (line.endTime - line.startTime) / arrowCount;
    end
    for index = 1, arrowCount do
        local x = startX + xOffset * (index - 1) + 0.5;
        local y = startY + yOffset * (index - 1) + 0.5;
        local arrow = line:GetArrow(index);
        if arrow == nil then
            local passTime = line.startTime + timeOffset * (index - 1 + 0.5);
            arrow = self:CreateArrow(line, index, x, y, passTime);
        end

        self:ShowLineArrow(line, arrow);
    end
end

-- 创建箭头
function LineManage:CreateArrow(line, arrowId, x, y, passTime)
    local arrow = line:CreateArrow(arrowId, x, y, passTime);
    self:InsertArrowToTiled(line, arrow);

    return arrow;
end

-- 插入一个箭头到Tiled上
function LineManage:InsertArrowToTiled(line, arrow)
    --if line == nil or arrow == nil or arrow.id == nil or self.allArrowMap[arrow.id] ~= nil then
    if line == nil or arrow == nil or arrow.id == nil then
        return;
    end

    local tiledLine = self.allArrowMap[arrow.tiledIndex];
    if tiledLine == nil then
        tiledLine = {};
        self.allArrowMap[arrow.tiledIndex] = tiledLine;
    end

    local allArrow = tiledLine[line.id];
    if allArrow == nil then
        allArrow = {};
        tiledLine[line.id] = allArrow;
    end

    allArrow[arrow.id] = arrow;
end

-- 显示箭头信息
function LineManage:ShowLineArrow(line, arrow)
    if line == nil or arrow == nil or line.isVisible == false then
        return;
    end

    local tiled = MapService:Instance():GetTiledByIndex(arrow.tiledIndex);
    if tiled == nil then
        return;
    end

    self:LoadArrow(function( arrowImage )
        self:ShowArrow(line, arrow, arrowImage)
    end);
end

-- 显示箭头
function LineManage:ShowArrow(line, arrow, arrowImage)
    if line == nil or arrow == nil or arrowImage == nil then
        return;
    end

    if arrow.imageObject == nil then
        arrowImage:SetActive(true);
        
        local postion = MapService:Instance():GetTiledPosition(arrow.x, arrow.y);
        arrowImage.transform.localPosition = Vector3.New(postion.x ,postion.y+25 ,0);

        arrowImage.transform.localRotation = Quaternion.New(0, 0, 0, 1);
        arrowImage.transform:Rotate(Vector3.New(0, 0, line.angle));
        arrow.imageObject = arrowImage;
        self:RefreshArrowImage(line, arrow);
        self:OnShowArrow(line, arrow);
    else
        arrowImage:SetActive(false);
        self._cacheArrowQueue:Push(arrowImage);
    end
    
end

-- 加载箭头
function LineManage:LoadArrow(loadComplete)
    if self._cacheArrowQueue:Count() ~= 0 then
        local arrowImage = self._cacheArrowQueue:Pop();
        loadComplete(arrowImage);
        return ;
    end

    local lineParent = self:GetLineParent();
    GameResFactory.Instance():GetResourcesPrefab("Map/ArrowImage", lineParent, 
        function (arrowImage) 
            loadComplete(arrowImage);
        end 
    );
end

-- 回收箭头
function LineManage:RecoveryArrow(arrow)
    if arrow == nil or arrow.imageObject == nil then
        return;
    end

    arrow.imageObject:SetActive(false);
    self._cacheArrowQueue:Push(arrow.imageObject);
    arrow.imageObject = nil;
    arrow.image = nil;
    arrow.lastResult = nil;
end

-- 获取箭头的父亲
function LineManage:GetLineParent()
    if self.lineParent == nil then
        self.lineParent = MapService:Instance():GetLayerParent(LayerType.Line);
    end
    return self.lineParent;
end

function LineManage:GetSliderParent()
    if self.sliderParent == nil then
        self.sliderParent = MapService:Instance():GetLayerParent(LayerType.ArmyWalkSlider);
    end
    return self.sliderParent;
end

function LineManage:GetFlagParent()
    if self.flagParent == nil then
        self.flagParent = MapService:Instance():GetLayerParent(LayerType.Flag);
    end
    return self.flagParent;
end

-- 检查箭头的时间是否已经过了
function LineManage:CheckArrow(arrow)
    if arrow == nil then
        return false;
    end

    return PlayerService:Instance():GetLocalTime() >= (arrow.passTime);
end

-- 获取当前箭头的图片
function LineManage:GetArrowImage(line, arrow)
    if line == nil or arrow == nil then
        return "my_common", false;
    end

    local checkResult = self:CheckArrow(arrow);
    local myId = PlayerService:Instance():GetPlayerId();
    local myLeagueId = PlayerService:Instance():GetLeagueId();
    local mySuperiorLeagueId = PlayerService:Instance():GetsuperiorLeagueId();
    --if LeagueService:Instance():GetLeagueInfo() == nil or LeagueService:Instance():GetLeagueInfo().leagueId == nil or line.leagueId == LeagueService:Instance():GetLeagueInfo().leagueId then
    --print("line.superiorLeagueId"..line.superiorLeagueId); 
    if (line.playerId == myId) then
        if checkResult then
            return "Green_passtime", checkResult;
        else
            return "Green_common", checkResult;
        end
    elseif (line.playerId ~= myId and myLeagueId ~= 0 and myLeagueId == line.leagueId and line.superiorLeagueId == 0) 
        or (line.playerId ~= myId and mySuperiorLeagueId ~= 0 and mySuperiorLeagueId == line.leagueId) 
        or (line.playerId ~= myId and myLeagueId ~= 0 and myLeagueId == line.superiorLeagueId)
    then
        if checkResult then
            return "my_passtime", checkResult;
        else
            return "my_common", checkResult;
        end
    else
        if checkResult then
            return "enemy_passtime", checkResult;
        else
            return "enemy_common", checkResult;
        end
    end

    return "my_common", checkResult;
end

-- 刷新箭头图片
function LineManage:RefreshArrowImage(line, arrow)
    if arrow.lastResult == nil then
        self:SetArrowSprite(line, arrow);
        return;
    end

    if arrow.lastResult then
        return;
    end

    local result = self:CheckArrow(arrow);
    if result then
        self:SetArrowSprite(line, arrow);
    end
end

-- 刷新箭头图片
function LineManage:SetArrowSprite(line, arrow)
    local sprite, result = self:GetArrowImage(line, arrow);
    arrow:SetSprite(sprite);
    arrow.lastResult = result;
end

-- 刷新所有线是否可见，如果之前不可见但是现在可见则显示线
function LineManage:RefreshAllLineVisiable()
    for k,v in pairs(self.allLineMap) do
        if v.isVisible == false then
            v:CheckIsVisiable();
            if v.isVisible == true then
                for k1,v1 in pairs(v.allArrowMap) do
                    self:ShowLineArrow(v, v1);
                end
            end
        end
    end
end

-- 刷新所有敌方提示线是否可见，如果之前不可见但是现在可见则显示
function LineManage:RefreshAllEnemyTipsLineVisiable()
    local haveChange = false;
    for k,v in pairs(self._enemyTipsLineMap) do
        if v.isVisible == false then
            v:CheckIsVisiable();
            if v.isVisible == true then
                haveChange = true;
            end
        end
    end
    if haveChange == true then
        if UIService:Instance():GetOpenedUI(UIType.UIGameMainView) == true then
            local uiMainView = UIService:Instance():GetUIClass(UIType.UIGameMainView);
            uiMainView:CreateEnemyArmyTip();
        end
    end
end

-- 刷新所有的线
function LineManage:RefreshAllLine(line)
    for k,v in pairs(self.allLineMap) do
        if v.isVisible == true then
            self:RefreshAllArrow(v);
        end
    end
end

-- 刷新所有的箭头
function LineManage:RefreshAllArrow(line)
    for k,v in pairs(line.allArrowMap) do
        if v.imageObject ~= nil and v.image ~= nil and v.lastResult ~= nil then
            self:RefreshArrowImage(line, v);
        end
    end
end

-- 加载终点旗帜
function LineManage:LoadCommonFlag(loadComplete)
    if self.commonFlagQueue:Count() ~= 0 then
        local commonFlag = self.commonFlagQueue:Pop();
        loadComplete(commonFlag);
        return ;
    end

    local lineParent = self:GetFlagParent();
    GameResFactory.Instance():GetResourcesPrefab("Map/BattleFlag", lineParent, 
        function (commonFlag) 
            loadComplete(commonFlag);
        end 
    );
end

-- 当显示箭头的时候
function LineManage:OnShowArrow(line, arrow)
    if line == nil or arrow == nil or line.endTiledId ~= arrow.tiledIndex or line.endFlag ~= nil then
        return;
    end

    self:LoadCommonFlag(function (flag) self:ShowEndFlag(line, arrow, flag)  end);
end

--加载倒计时Slider
function LineManage:LoadCommonSlider(loadComplete)
    if self.uiArmySliderQueue:Count() ~= 0 then
        local commonSlider = self.uiArmySliderQueue:Pop();
        loadComplete(commonSlider);
        return ;
    end

    local sliderParent = self:GetSliderParent();
    local uiCommonSlider = require("Game/Common/UICommonSlider").new();
    GameResFactory.Instance():GetUIPrefab("UIPrefab/UICommonSlider", sliderParent,uiCommonSlider,
        function (commonSlider)
            uiCommonSlider:Init(); 
            loadComplete(uiCommonSlider);
        end 
    );
end

--显示倒计时
function LineManage:ShowCommonSlider(line, arrow, uiCommonSlider)
    if line.commonSlider == nil then
        uiCommonSlider.gameObject:SetActive(true);
        uiCommonSlider:ShowTimes(CommonSliderType.ArmyWalking,line.startTime,line.endTime);
        uiCommonSlider.gameObject.transform.rotation = UnityEngine.Quaternion.New(0, 0, 0, 1);
        line.commonSlider = uiCommonSlider;
        self:UpdateArmyPosition(line, x, y);
    else
        uiCommonSlider.gameObject:SetActive(false);
        self.uiArmySliderQueue:Push(uiCommonSlider);
    end
end

-- 显示终点
function LineManage:ShowEndFlag(line, arrow, flag)
    flag:SetActive(true);
    local position = MapService:Instance():GetTiledPosition(math.floor(arrow.x), math.floor(arrow.y));
    flag.transform.localPosition = Vector3.New(position.x,position.y+20,position.z);
    flag.transform.rotation = UnityEngine.Quaternion.New(0, 0, 0, 1);
    if line.endFlag ~= nil then
        flag:SetActive(false);
        self.commonFlagQueue:Push(flag);
    else
        line.endFlag = flag;
    end
end

-- 当隐藏格子的时候如果终点旗子在格子上则隐藏
function LineManage:OnHideTiled(tiled)
    if tiled == nil or tiled:GetIndex() == nil then
        return;
    end

    local tiledLine = self.allArrowMap[tiled:GetIndex()];
    if tiledLine == nil then
        return;
    end

    for lineId, lineArrow in pairs(tiledLine) do
        local line = self:GetLine(lineId);
        if line ~= nil and line.endTiledId == tiled:GetIndex() then
            self:HideEndFlag(line);
        end
    end
end

-- 隐藏终点
function LineManage:HideEndFlag(line)
    if line == nil or line.endFlag == nil then
        return;
    end

    line.endFlag:SetActive(false);
    self.commonFlagQueue:Push(line.endFlag);
    line.endFlag = nil;
end

-- 刷新部队位置
function LineManage:RefreshAllArmyPosition()
    for k,v in pairs(self.allLineMap) do
        if v.isVisible == true then
            self:RefreshArmyPosition(v);
        end
    end
end

-- 刷新部队位置
function LineManage:RefreshArmyPosition(line)
    local startX, startY = MapService:Instance():GetTiledCoordinate(line.startTiledId);
    local endX, endY = MapService:Instance():GetTiledCoordinate(line.endTiledId);
    local scale = (PlayerService:Instance():GetLocalTime() - line.startTime) / (line.endTime - line.startTime);
    local x =  startX + 0.5 + (endX - startX) * scale;
    local y =  startY + 0.5 + (endY - startY) * scale;
    local tiledIndex = MapService:Instance():GetTiledIndex(math.floor(x), math.floor(y));
    local tiled = MapService:Instance():GetTiledByIndex(tiledIndex);
    if tiled == nil then
        self:HideArmy(line, x, y);
        return;
    end

    self:HandleShowArmy(line, x, y);
    self:UpdateArmyPosition(line, x, y);
end

-- 显示部队
function LineManage:HandleShowArmy(line, x, y)
    if line == nil or line.uiArmyFlag ~= nil then
        return;
    end
    self:LoadCommonSlider(function (uiCommonSlider) self:ShowCommonSlider(line, arrow, uiCommonSlider)  end);
    self:LoadArmy(function ( uiArmyFlag )
        self:ShowArmy(line, x, y, uiArmyFlag);
    end);
    
end

-- 加载部队
function LineManage:LoadArmy(loadComplete)
    if self.uiArmyFlagQueue:Count() ~= 0 then
        local uiArmyFlag = self.uiArmyFlagQueue:Pop();
        loadComplete(uiArmyFlag);
        return ;
    end

    local flagParent = self:GetFlagParent();
    local uiArmyFlag = require("Game/Line/UIArmyFlag").new();
    GameResFactory.Instance():GetUIPrefab("Map/BattleRole", flagParent, uiArmyFlag,
        function (go) 
            uiArmyFlag:Init();
            loadComplete(uiArmyFlag);
            UIService:Instance():AddUI(UIType.UIArmyFlag,uiArmyFlag);
        end 
    );
end

-- 显示部队
function LineManage:ShowArmy(line, x, y, uiArmyFlag)
    if uiArmyFlag == nil or uiArmyFlag.gameObject == nil then
        return;
    end

    if line.uiArmyFlag == nil then
        uiArmyFlag:InitValue(line.id);
        uiArmyFlag.gameObject:SetActive(true);
        uiArmyFlag.gameObject.transform.rotation = UnityEngine.Quaternion.New(0, 0, 0, 1);
        line.uiArmyFlag = uiArmyFlag;
        self:UpdateArmyPosition(line, x, y);
    else
        uiArmyFlag.gameObject:SetActive(false);
        self.uiArmyFlagQueue:Push(uiArmyFlag);
    end
end

-- 更新部队位置
function LineManage:UpdateArmyPosition(line, x, y)
    if line == nil or line.uiArmyFlag == nil or line.uiArmyFlag.gameObject == nil then
        return;
    end
    local position = MapService:Instance():GetTiledPosition(x, y);
    line.uiArmyFlag.transform.localPosition = Vector3.New(position.x,position.y+20,position.z);
    if line.commonSlider ~= nil then
        line.commonSlider.transform.localPosition = Vector3.New(position.x,position.y+300,position.z);
    end
end

-- 隐藏部队
function LineManage:HideArmy( line )
    if line == nil or line.uiArmyFlag == nil or line.uiArmyFlag.gameObject == nil then
        return;
    end

    line.uiArmyFlag.gameObject:SetActive(false);
    if line.commonSlider ~= nil then
        line.commonSlider.gameObject:SetActive(false);
    end
    self.uiArmyFlagQueue:Push(line.uiArmyFlag);
    self.uiArmySliderQueue:Push(line.commonSlider);
    line.uiArmyFlag = nil;
    line.commonSlider = nil;
end

-- 检查线是否结束
function LineManage:CheckAllLine()
    for k,v in pairs(self.allLineMap) do
        if v ~= nil and PlayerService:Instance():GetLocalTime() >= v.endTime then
            self.removeList:Push(v.id);
        end
    end
end

-- 删除线
function LineManage:RemoveLineOnHeartBeat()
    local count = self.removeList:Count();
    for i=1, count, 1 do
        self:RemoveLine(self.removeList:Get(i));
    end

    self.removeList:Clear();
end

-- 选中某支部队 自己部队传进来的是cityid和槽位
-- 敌方队伍若是基于线传进来的是line的id和0 若是基于战平部队传进来的是EnemyTipBattle的id和1
function LineManage:ChooseArmyLine(isEnemy, index, cityId)
    MapService:Instance():HideTiled()
    if isEnemy == true then
        if cityId == 0 then
            self:ChooseArmyLineByLineId(index);
        elseif cityId == 1 then
            self:CancelArmyChoose();
            local tip = self:GetEnemyTipsBattle(index);
            if tip ~= nil then
                MapService:Instance():ScanTiledMark(tip.tiledId);
            end
        end
    else
        self:ChooseArmyLineBySlotIndex(cityId, index);
    end
end

-- 通过line的id选中别人部队
function LineManage:ChooseArmyLineByLineId(index)
    if index == 0 or index == self.choosedLineId then
        return;
    end

    if self.choosedLineId ~= 0 then
        for k, v in pairs(self.allLineMap) do
            if v.id == self.choosedLineId and v.uiArmyFlag ~= nil and v.uiArmyFlag.gameObject ~= nil then
                v.uiArmyFlag:HideChoosePanel();
            end
        end
        self.choosedLineId = 0;
    end

    local line = self:GetLine(index);
    if line == nil then
        line = self:GetEnemyTipsLine(index);
        if line == nil then
            return;
        end
    end

    self.choosedLineId = index;
    local startPosition = MapService:Instance():GetTiledPositionByIndex(line:GetStartTiledId());
    local endPosition = MapService:Instance():GetTiledPositionByIndex(line:GetEndTiledId());
    local scale = (PlayerService:Instance():GetLocalTime() - line.startTime) / (line.endTime - line.startTime);
    local x =  startPosition.x + (endPosition.x - startPosition.x) * scale;
    local y =  startPosition.y + (endPosition.y - startPosition.y) * scale;
    local tiledX, tiledY = MapService:Instance():UIToTiledPosition(x, y);
    local tiledIndex = MapService:Instance():GetTiledIndex(tiledX, tiledY);
    MapService:Instance():ScanTiledMark(tiledIndex);
end

-- 通过cityid和槽位索引选中我方部队
function LineManage:ChooseArmyLineBySlotIndex(cityid, index)
    local armyInfo = ArmyService:Instance():GetArmyInCity(cityid, index);
    if armyInfo == nil then
        self:CancelArmyChoose();
        return;
    end

    if armyInfo:GetArmyState() ~= ArmyState.BattleRoad and
    armyInfo:GetArmyState() ~= ArmyState.SweepRoad and
    armyInfo:GetArmyState() ~= ArmyState.GarrisonRoad and
    armyInfo:GetArmyState() ~= ArmyState.MitaRoad and
    armyInfo:GetArmyState() ~= ArmyState.TrainingRoad and
    armyInfo:GetArmyState() ~= ArmyState.RescueRoad and
    armyInfo:GetArmyState() ~= ArmyState.TransformRoad and
    armyInfo:GetArmyState() ~= ArmyState.Back then
        self:CancelArmyChoose();
        if armyInfo:GetArmyState() ~= ArmyState.None then
            MapService:Instance():ScanTiledMark(armyInfo.tiledId);
        end
        return;
    end

    local line = self:GetMyLineByIndex(cityid, index);
    if line == nil then
        self:CancelArmyChoose();
        return;
    end

    self:ChooseArmyLineByLineId(line.id);
end

-- 刷新大地图的部队跟随
function LineManage:RefreshMapFollowArmy()
    if self.choosedLineId == 0 then
        return;
    end

    local line = self:GetLine(self.choosedLineId);
    if line == nil or line.uiArmyFlag == nil or line.uiArmyFlag.gameObject == nil then
        return;
    end

    line.uiArmyFlag:ShowChoosePanel();
    local x = line.uiArmyFlag.transform.localPosition.x;
    local y = line.uiArmyFlag.transform.localPosition.y;
    MapService:Instance():ScanTiledByUGUIPositionDelay(x, y);
end

-- 通过槽位获取我方自己的部队Line
function LineManage:GetMyLineByIndex(cityid, index)
    for k,v in pairs(self.allLineMap) do
        if v:IsOtherArmy() == false and v.buildingId == cityid and v.armySlotIndex == index then
            return v;
        end
    end

    return nil;
end

-- 取消部队的选中
function LineManage:CancelArmyChoose()
    if self.choosedLineId == 0 then
        return;
    end

    for k,v in pairs(self.allLineMap) do
        if v.id == self.choosedLineId and v.uiArmyFlag ~= nil and v.uiArmyFlag.gameObject ~= nil then
            v.uiArmyFlag:HideChoosePanel();
        end
    end

    self.choosedLineId = 0;
end

-- 获取所有敌方的部队（左侧敌方部队提示使用 基于线）
function LineManage:GetAllEnemyTipsLine()
    local list = List.new();
    for k, v in pairs(self._enemyTipsLineMap) do
        if v:IsEnemyArmy() == true and v.isVisible == true and v.isHavePersionalView == true then
            list:Push(v);
        end
    end
    return list;
end

-- 处理添加敌方提示（基于线）
function LineManage:HandleAddEnemyTipLine(msg)
    local lineInfo = msg.lineInfo;
    if lineInfo == nil then
        return;
    end

    local line = Line.new();
    line.id = lineInfo.lineId + 1;
    line.startTime = lineInfo.startTime;
    line.endTime = lineInfo.endTime;
    line.startTiledId = lineInfo.startTiled;
    line.endTiledId = lineInfo.endTiled;
    line.playerId = lineInfo.playerId;
    line.playerName = lineInfo.playerName;
    line.leagueId = lineInfo.leagueId;
    line.superiorLeagueId = lineInfo.superiorLeagueId;
    line.buildingId = lineInfo.buildingId;
    line.armySlotIndex = lineInfo.armySlotIndex + 1;
    line.isHaveStartTiledView = lineInfo.isHaveStartTiledView;
    line.isHaveEndTiledView = lineInfo.isHaveEndTiledView;
    if lineInfo.isHaveStartPersionalView == true or lineInfo.isHaveEndPersionalView == true then
        line.isHavePersionalView = true;
    end
    line:CheckIsVisiable();
    self:AddEnemyTipsLine(line);
end

-- 处理移除敌方提示（基于线）
function LineManage:HandleRemoveEnemyTipsLine(msg)
    local lineId = msg.lineId + 1;
    if lineId == nil then
        return;
    end

    local line = self:GetEnemyTipsLine(lineId);
    if line == nil then
        return;
    end

    if line.id == self.choosedLineId then
        self:CancelArmyChoose();
    end
    
    self._enemyTipsLineMap[lineId] = nil;
end

function LineManage:AddEnemyTipsLine(line)
    if line == nil or line.id == nil or self._enemyTipsLineMap[line.id] ~= nil then
        return;
    end

    self._enemyTipsLineMap[line.id] = line;
end

-- 获取敌方提示（基于线）
function LineManage:GetEnemyTipsLine(lineId)
    if lineId == nil then
        return nil;
    end

    return self._enemyTipsLineMap[lineId];
end

-- 获取所有敌方的部队（左侧敌方部队提示使用 基于战平部队）
function LineManage:GetAllEnemyTipsBattle()
    local list = List.new();
    for k, v in pairs(self._enemyTipsBattleMap) do
        list:Push(v);
    end
    return list;
end

-- 处理增加敌方提示（基于战平部队）
function LineManage:HandleAddEnemyTipBattle(msg)
    local id = msg.buildingId .. (msg.armySlotIndex + 1);
    local tip = EnemyTipBattle.new();
    tip:SetId(id);
    tip.playerId = msg.playerId;
    tip.tiledId = msg.curTiled;
    tip.playerName = msg.playerName;
    tip.buildingId = msg.buildingId;
    tip.armySlotIndex = msg.armySlotIndex + 1;
    self._enemyTipsBattleMap[id] = tip;
end

-- 处理移除敌方提示（基于战平部队）
function LineManage:HandleRemoveEnemyTipsBattle(msg)
    local id = msg.buildingId .. (msg.armySlotIndex + 1);
    local tip = self:GetEnemyTipsBattle(id);
    if tip == nil then
        return;
    end

    self._enemyTipsBattleMap[id] = nil;
end

-- 获取敌方提示（基于战平部队）
function LineManage:GetEnemyTipsBattle(id)
    if id == nil then
        return nil;
    end

    return self._enemyTipsBattleMap[id];
end

return LineManage
