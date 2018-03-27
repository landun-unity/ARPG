--
-- 客户端 --> 逻辑服务器
-- 设置同盟关系
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ConfigRelationRequest = class("ConfigRelationRequest", GameMessage);

--
-- 构造函数
--
function ConfigRelationRequest:ctor()
    ConfigRelationRequest.super.ctor(self);
    --
    -- 关系盟
    --
    self.leagueId = 0;
    
    --
    -- 关系参数
    --
    self.diplomacyType = 0;
end

--@Override
function ConfigRelationRequest:_OnSerial() 
    self:WriteInt64(self.leagueId);
    self:WriteInt32(self.diplomacyType);
end

--@Override
function ConfigRelationRequest:_OnDeserialize() 
    self.leagueId = self:ReadInt64();
    self.diplomacyType = self:ReadInt32();
end

return ConfigRelationRequest;
