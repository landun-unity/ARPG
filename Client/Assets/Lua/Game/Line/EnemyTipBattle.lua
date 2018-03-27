--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local EnemyTipBattle = class("EnemyTipBattle");

function EnemyTipBattle:ctor()
    self.id = 0;
    self.playerId = 0;
    self.tiledId = 0;
    self.playerName = "";
    self.buildingId = 0;
    self.armySlotIndex = 0;
end

function EnemyTipBattle:GetId()
    return self.id;
end

function EnemyTipBattle:SetId(id)
    self.id = id;
end

return EnemyTipBattle;

--endregion
