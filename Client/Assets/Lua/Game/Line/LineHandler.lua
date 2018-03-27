-- 货币资源相关信息管理
local IOHandler = require("FrameWork/Game/IOHandler")
local LineHandler = class("LineHandler", IOHandler)

-- 构造函数
function LineHandler:ctor( )
    -- body
    LineHandler.super.ctor(self);
end

-- 注册所有消息
function LineHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Map.AddLine, self.HandleAddLine, require("MessageCommon/Msg/L2C/Map/AddLine"));
    self:RegisterMessage(L2C_Map.SynePlayerAllLine, self.HandleSynePlayerAllLine, require("MessageCommon/Msg/L2C/Map/SynePlayerAllLine"));
    self:RegisterMessage(L2C_Map.RemoveLine, self.HandleRemoveLine, require("MessageCommon/Msg/L2C/Map/RemoveLine"));

    self:RegisterMessage(L2C_Map.AddEnemyTipLine, self.HandleAddEnemyTipLine, require("MessageCommon/Msg/L2C/Map/AddEnemyTipLine"));
    self:RegisterMessage(L2C_Map.RemoveEnemyTipsLine, self.HandleRemoveEnemyTipsLine, require("MessageCommon/Msg/L2C/Map/RemoveEnemyTipsLine"));
    self:RegisterMessage(L2C_Map.AddEnemyTipBattle, self.HandleAddEnemyTipBattle, require("MessageCommon/Msg/L2C/Map/AddEnemyTipBattle"));
    self:RegisterMessage(L2C_Map.RemoveEnemyTipsBattle, self.HandleRemoveEnemyTipsBattle, require("MessageCommon/Msg/L2C/Map/RemoveEnemyTipsBattle"));
end

-- 添加线
function LineHandler:HandleAddLine(msg)
    self._logicManage:HandleAddLine(msg.lineInfo);
end

-- 同步所有线 不在列表的删掉
function LineHandler:HandleSynePlayerAllLine(msg)
    self._logicManage:HandleSynePlayerAllLine(msg);
end

-- 删除线
function LineHandler:HandleRemoveLine(msg)
    self._logicManage:RemoveLine(msg.lineId + 1);
end

-- 增加敌方提示（基于线）
function LineHandler:HandleAddEnemyTipLine(msg)
    self._logicManage:HandleAddEnemyTipLine(msg);
end

-- 移除敌方提示（基于线）
function LineHandler:HandleRemoveEnemyTipsLine(msg)
    self._logicManage:HandleRemoveEnemyTipsLine(msg);
end

-- 增加敌方提示（基于战平部队）
function LineHandler:HandleAddEnemyTipBattle(msg)
    self._logicManage:HandleAddEnemyTipBattle(msg);
end

-- 移除敌方提示（基于战平部队）
function LineHandler:HandleRemoveEnemyTipsBattle(msg)
    self._logicManage:HandleRemoveEnemyTipsBattle(msg);
end

return LineHandler;
