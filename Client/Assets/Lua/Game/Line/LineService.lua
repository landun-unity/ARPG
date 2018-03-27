local GameService = require("FrameWork/Game/GameService")

local LineHandler = require("Game/Line/LineHandler")
local LineManage = require("Game/Line/LineManage");
LineService = class("LineService", GameService)

-- 线的服务
function LineService:ctor( )
    LineService._instance = self;
    LineService.super.ctor(self, LineManage.new(), LineHandler.new());
end

-- 单例
function LineService:Instance()
    return LineService._instance;
end

--清空数据
function LineService:Clear()
    self._logic:ctor()
end

-- 隐藏格子
function LineService:RemoveTiled( tiled )
    self._logic:RemoveTiled(tiled);
end

-- 显示格子
function LineService:OnShowTiled( tiled )
    self._logic:OnShowTiled(tiled);
end

-- 通过line的id获取line
function LineService:GetLine(lineId)
    return self._logic:GetLine(lineId);
end

-- 选中某支部队
function LineService:ChooseArmyLine(isEnemy, index, cityid)
    self._logic:ChooseArmyLine(isEnemy, index, cityid);
end

-- 取消部队的选中
function LineService:CancelArmyChoose()
    self._logic:CancelArmyChoose();
end

-- 获取所有敌方的部队（基于线）
function LineService:GetAllEnemyTipsLine()
    return self._logic:GetAllEnemyTipsLine();
end

-- 获取敌方提示（基于线）
function LineService:GetEnemyTipsLine(lineId)
    return self._logic:GetEnemyTipsLine(lineId);
end

-- 获取所有敌方的部队（基于战平部队）
function LineService:GetAllEnemyTipsBattle()
    return self._logic:GetAllEnemyTipsBattle();
end

-- 获取敌方提示（基于战平部队）
function LineService:GetEnemyTipsBattle(id)
    return self._logic:GetEnemyTipsBattle(id);
end

return LineService;