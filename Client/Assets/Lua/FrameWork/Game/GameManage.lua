-- 游戏管理的基类
local IGameManage = require("FrameWork/Game/IGameManage")

require("Game/Hero/HeroService");
local VersionConfig = require("Game/Config/VersionConfig")
-- 定义类
local GameManage = class("GameManage", IGameManage)

-- 构造函数
function GameManage:ctor()
    -- body
    --print("GameManage:ctor");
    GameManage.super.ctor(self);
    self._allGameServiceList = {};
    self.start = false
    self._version = ""
end

-- 启动游戏
function GameManage:StartGame()
    -- body
    self:SetStart(true)
    self:LoadVersion()
    self:_RegisterCommonService();
    self:_RegisterAllService();
    self:_OnInit();
end

function GameManage:GetStart()
    return self.start
end

function GameManage:SetStart(args)
    self.start = args
end

function GameManage:LoadVersion()
    self._version = VersionConfig.Version
    print("客户端游戏版本 == " .. self._version)
end

-- 注册通用服务
function GameManage:_RegisterCommonService()
    -- body
    local MessageService = require("FrameWork/Message/MessageService");
    self:_RegisterService(MessageService.new());
end

-- 注册服务
function GameManage:_RegisterService(service)
    -- body
    if service == nil then
        return;
    end

    local count = table.getn(self._allGameServiceList) + 1;
    -- 添加到列表中
    table.insert( self._allGameServiceList, count, service);
end

-- 初始化
function GameManage:_OnInit()
    -- body
    --print("GameManage:_OnInit");
    for i,v in ipairs(self._allGameServiceList) do
        if v ~= nil then
            --todo
            v:Init();
        end
    end 
end

-- 心跳
function GameManage:HeartBeat()
    -- body
    for i,v in ipairs(self._allGameServiceList) do
        if v ~= nil then
            --todo
            v:HeartBeat();
        end
    end 
end

-- 停止游戏
function GameManage:_StopGame()
    -- body
    for i,v in ipairs(self._allGameServiceList) do
        if v ~= nil then
            --todo
            v:Stop();
        end
    end 
end

-- 清空游戏
function GameManage:Clear()
    for i,v in ipairs(self._allGameServiceList) do
        if v ~= nil then
            --todo
            v:Clear();
        end
    end 
end


function GameManage:ClearData()
 for i,v in ipairs(self._allGameServiceList) do
        if v ~= nil then
            --todo
            v.Instance():Clear();
        end
    end 
end

return GameManage;