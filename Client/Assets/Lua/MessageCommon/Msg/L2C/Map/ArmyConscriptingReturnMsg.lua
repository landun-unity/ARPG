--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--征兵消息返回
local GameMessage = require("common/Net/GameMessage");
local ArmyConscriptingReturnMsg = class("ArmyConscriptingReturnMsg", GameMessage);

function ArmyConscriptingReturnMsg:ctor()
    ArmyConscriptingReturnMsg.super.ctor(self);
    self.playerId = 0;                  --玩家id
    self.cityBuliding = 0;              --哪个城市
    self.armyIndex = 0;                 --哪个部队
    self.backNum = 0;                   --大营征兵数量
    self.middleNum = 0;                 --中军征兵数量
    self.frontNum = 0;                  --前锋征兵数量
end

function ArmyConscriptingReturnMsg:_OnSerial()
    self:WriteInt64(self.playerId);
    self:WriteInt64(self.cityBuliding);
    self:WriteInt32(self.armyIndex);
    self:WriteInt32(self.backNum);
    self:WriteInt32(self.middleNum);
    self:WriteInt32(self.frontNum);
end

function ArmyConscriptingReturnMsg:_OnDeserialize()
    self.playerId = self:ReadInt64();
    self.cityBuliding = self:ReadInt64();
    self.armyIndex = self:ReadInt32();
    self.backNum = self:ReadInt32();
    self.middleNum = self:ReadInt32();
    self.frontNum = self:ReadInt32();
end

return ArmyConscriptingReturnMsg;

--endregion
