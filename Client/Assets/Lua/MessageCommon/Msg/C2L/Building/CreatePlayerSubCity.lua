--
-- 客户端 --> 逻辑服务器
-- 创建分城
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CreatePlayerSubCity = class("CreatePlayerSubCity", GameMessage);

--
-- 构造函数
--
function CreatePlayerSubCity:ctor()
    CreatePlayerSubCity.super.ctor(self);
    --
    -- 玩家Id
    --
    self.playerId = 0;
    
    --
    -- 格子索引
    --
    self.tiledIndex = 0;
    
    --
    -- 分城名字
    --
    self.name = "";
    
    --
    -- 要塞编号
    --
    self.nameNum = 0;
end

--@Override
function CreatePlayerSubCity:_OnSerial() 
    self:WriteInt64(self.playerId);
    self:WriteInt32(self.tiledIndex);
    self:WriteString(self.name);
    self:WriteInt32(self.nameNum);
end

--@Override
function CreatePlayerSubCity:_OnDeserialize() 
    self.playerId = self:ReadInt64();
    self.tiledIndex = self:ReadInt32();
    self.name = self:ReadString();
    self.nameNum = self:ReadInt32();
end

return CreatePlayerSubCity;
