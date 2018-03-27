-- 加载常用模块
require("init")
require("Game/Table/InitTable")
local MapLoad = require("Game/Map/MapLoad")
local Client = require("Game/Client")
local UIType = require("Game/UI/UIType")

-- 主入口函数。从这里开始lua逻辑
function Main()
    print("進入lua！！！");
    if GameResFactory.Instance():LoadedLevelName() == 1 then
    end
    if GameResFactory.Instance():LoadedLevelName() == 2 then
        GameResFactory.Instance():LoadLevel("Start");
    end

    if GameResFactory.Instance():LoadedLevelName() == 3 then
    end
end


-- 退出游戏
function ExitGame()

end


-- 加载登录场景
function LoadLoginScene()
end

-- 第二个场景启动
function SecondSceneStart()

end

-- 场景切换通知
function OnLevelWasLoaded(level)
    Time.timeSinceLevelLoad = 0
end

-- 心跳逻辑
function HeartBeatCoroutine()
    while
        (true)
    do
        Main_HeartBeat();
        coroutine.step();
    end
end

-- 主心跳
function Main_HeartBeat()
    Client:Instance():HeartBeat();
end

