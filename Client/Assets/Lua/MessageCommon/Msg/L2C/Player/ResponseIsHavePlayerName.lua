--
-- 逻辑服务器 --> 客户端
-- 返回其它玩家的个人信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ResponseIsHavePlayerName = class("ResponseIsHavePlayerName", GameMessage);

--
-- 构造函数
--
function ResponseIsHavePlayerName:ctor()
    ResponseIsHavePlayerName.super.ctor(self);
    --
    -- 是否包含该名称(如果否返回一个小于0的数)
    --
    self.isHaveName = 0;
end

--@Override
function ResponseIsHavePlayerName:_OnSerial() 
    self:WriteInt32(self.isHaveName);
end

--@Override
function ResponseIsHavePlayerName:_OnDeserialize() 
    self.isHaveName = self:ReadInt32();
end

return ResponseIsHavePlayerName;
