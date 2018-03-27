-- 游戏管理的基类
local GameMessage = class("GameMessage")

-- 消息头长度
local headLength = 4 + 4 + 8;

-- 构造函数
function GameMessage:ctor()
    -- body
    self._adapterId = 0;
    self._relationId = 0;
    self._msgId = 0;
    self._byteArray = nil;
end

-- 初始化
function GameMessage:Init(part)
end

-- 心跳
function GameMessage:RegisterAllMessage()
end

function GameMessage:GetAdapterId()
    -- body
    return self._adapterId;
end

function GameMessage:SetAdapterId(adapterId)
    -- body
    self._adapterId = adapterId;
end

function GameMessage:GetRelationId()
    -- body
    return self._relationId;
end

function GameMessage:SetRelationId(relationId)
    -- body
    self._relationId = relationId;
end

function GameMessage:GetMessageId()
    -- body
    return self._msgId;
end

function GameMessage:SetMessageId(msgId)
    -- body
    self._msgId = msgId;
end

-- 消息头长度
function GameMessage:GetHeadLength()
    return headLength;
end

function GameMessage:Serial()
    self._byteArray:Reset();
    local length = 0;
    self._byteArray:WriteInt32(length);
    self._byteArray:WriteInt32(self._msgId);
    self._byteArray:WriteInt64(self._relationId);
    
    self:_OnSerial();
    
    length = self._byteArray:GetWritePos() - 4;
    self._byteArray:SeekAndWrite(0, length);
end

function GameMessage:_OnSerial()
end

function GameMessage:Deserialize()
    self._byteArray:Reset();
    self:ReadInt32();
    self._msgId = self:ReadInt32();
    self._relationId = self:ReadInt64();
    --print("GameMessage:Deserialize()");
    self:_OnDeserialize();
    --print("GameMessage:Deserialize()22222222");
end

function GameMessage:_OnDeserialize()
end

function GameMessage:WriteString(value)
    self._byteArray:WriteString(value);
end

function GameMessage:WriteBytes(value)
    self._byteArray:WriteBytes(value);
end

function GameMessage:WriteBytes(value, offset, length)
    self._byteArray:WriteBytes(value, offset, length);
end

function GameMessage:WriteMemBlock(block)
    self:WriteInt32(block:GetUseSize());
    self:WriteBytes(block:GetBytes(), 0, block:GetUseSize());
end

function GameMessage:WriteBoolean(value)
    self._byteArray:WriteBoolean(value);
end

function GameMessage:WriteInt8(value)
    self._byteArray:WriteInt8(value);
end

function GameMessage:WriteInt16(value)
    self._byteArray:WriteInt16(value);
end

function GameMessage:WriteInt32(value)
    self._byteArray:WriteInt32(value);
end

function GameMessage:WriteInt64(value)
    self._byteArray:WriteInt64(value);
end

function GameMessage:WriteSingle(value)
    self._byteArray:WriteSingle(value);
end

function GameMessage:WriteDouble(value)
    self._byteArray:WriteDouble(value);
end

function GameMessage:ReadBoolean()
    return self._byteArray:ReadBoolean();
end

function GameMessage:ReadInt8()
    return self._byteArray:ReadInt8();
end

function GameMessage:ReadInt16()
    return self._byteArray:ReadInt16();
end

function GameMessage:ReadInt32()
    return self._byteArray:ReadInt32();
end

function GameMessage:ReadInt64()
    return self._byteArray:ReadInt64();
end

function GameMessage:ReadSingle()
    return self._byteArray:ReadSingle();
end

function GameMessage:ReadDouble()
    return self._byteArray:ReadDouble();
end

function GameMessage:ReadString()
    return self._byteArray:ReadString();
end

function GameMessage:ReadBytes()
    return self._byteArray:ReadBytes();
end

function GameMessage:ReadBytes(value, offset, length)
    self._byteArray:ReadBytes(value, offset, length);
end

function GameMessage:ReadMemBlock()
    local length = self:ReadInt32();
    local memBlock = MemBlock.New(length);
    memBlock:SetUseSize(length);
    self:ReadBytes(memBlock:GetBytes(), 0, length);

    return memBlock;
end

function GameMessage:SetByteArray(byteArray)
    self._byteArray = byteArray;
end

return GameMessage;