
local GameService = require("FrameWork/Game/GameService")
CommonService = class("CommonService", GameService)
require("Game/Table/model/DataText");
require("Game/Table/model/DataBannedWord");
require("Game/Table/model/DataGameConfig");
local TimeDownInfo = require("Game/Common/TimeDownInfo");
local GameObjectFadeInfo = require("Game/Common/GameObjectFadeInfo");
local MoveInfo = require("Game/Common/MoveInfo");

-- 构造函数
function CommonService:ctor()
    CommonService._instance = self;
    if self.bgmAudio == nil or self.effectAudio == nil then
        self.bgmAudio = UnityEngine.GameObject.Find("GameManager/BgmAudio"):GetComponent(typeof(UnityEngine.AudioSource));
        self.effectAudio = UnityEngine.GameObject.Find("GameManager/EffectAudio"):GetComponent(typeof(UnityEngine.AudioSource));
    end

    -- 所有的倒计时信息 Key：GameObject  Value:TimeDownInfo
    self.AllTimeDownTable = { };

    self.lastClickTiledIndex = nil;
    self.curClickType = nil;
    self.withTypeFadeObj = { };

    -- 缩放+渐变信息
    self.AllFadeObj = { };
    -- 移动信息
    self.allMoveGameObject = { };
end

-- 单例
function CommonService:Instance()
    return CommonService._instance;
end

-- 清空数据
function CommonService:Clear()

end

-- 心跳
function CommonService:HeartBeat()
    for k, v in pairs(self.AllTimeDownTable) do
        v:ShowTime();
    end
    for k, v in pairs(self.AllFadeObj) do
        v:ShowAlpha();
    end
    for k, v in pairs(self.allMoveGameObject) do
        v:Move();
    end
end

function CommonService:RemoveObjFadeInfo(obj)
    if self.AllFadeObj[obj] ~= nil then
        self.AllFadeObj[obj]:ResetData();
        self.AllFadeObj[obj] = nil;
    end
end

-- 清空所有计时器
function CommonService:RemoveAllTimeDownInfo()
    for k, v in pairs(self.AllTimeDownTable) do
        v:ResetData();
    end
    self.AllTimeDownTable = { };
end

-- 清空某个界面下所有计时器
function CommonService:RemoveAllTimeDownInfoInUI(uitype)
    for k, v in pairs(self.AllTimeDownTable) do
        if v.parentUiType == uitype then
            v:ResetData();
        end
    end
end

-- 删除倒计时信息
function CommonService:RemoveTimeDownInfo(obj)
    if obj == nil then
        return;
    end
    if self.AllTimeDownTable[obj] ~= nil then
        if self.AllTimeDownTable[obj].endFunction ~= nil then
            self.AllTimeDownTable[obj].endFunction();
        end
        self.AllTimeDownTable[obj]:ResetData();
        self.AllTimeDownTable[obj] = nil;
    end
end

-- 添加倒计时信息
-- endTime 计时结束时间戳
-- showText：显示时间的Text
-- endFunction 倒计时结束回调
-- showSlider：显示的Slider
-- needTime:总的计时时间（单位毫秒,有Slider才用）
-- image 需要裁切的图片(圆形图片进度显示用)
function CommonService:TimeDown(parentUiType, endTime, showText, endFunction, showSlider, needTime, image)
    if self.AllTimeDownTable[showText.transform.gameObject] == nil then
        local timeDownInfo = TimeDownInfo.new();
        timeDownInfo:InitData(parentUiType, endTime, showText, endFunction, showSlider, needTime, image);
        self.AllTimeDownTable[showText.transform.gameObject] = timeDownInfo;
    else
        self.AllTimeDownTable[showText.transform.gameObject]:InitData(parentUiType, endTime, showText, endFunction, showSlider, needTime, image);
    end
end

function CommonService:DataTimeDown(showTime, timer, endFunction)
    local cdTime = math.floor(showTime / 1000);
    timer = Timer.New( function()
        cdTime = cdTime > 0 and cdTime - 1 or 0;
        if cdTime <= 0 then
            if timer ~= nil then
                timer:Stop();
                timer = nil;
            end
            if endFunction ~= nil then
                endFunction();
            end
            return;
        end
    end , 1, -1, false);
    timer:Start();
    return timer;
end

-- 通用请求某个玩家信息请求（打开个人信息界面）
function CommonService:RequestPlayerInfo(playerId)
    local msg = require("MessageCommon/Msg/C2L/Player/RequestOtherPlayerBaseInfo").new();
    msg:SetMessageId(C2L_Player.RequestOtherPlayerBaseInfo);
    msg.playerId = playerId;
    NetService:Instance():SendMessage(msg);
end

-- 参数分别是 本身 点击确认的方法 取消的方法 标题 小提示 确认按钮文本 取消按钮文本 更多的提示 
function CommonService:ShowOkOrCancle(objbase, OKFunc, CacleFunc, title, tips, okLabel, CancleLabel, MoreTips)
    self.temp = { };
    self.temp[1] = objbase;
    self.temp[2] = OKFunc;
    self.temp[3] = CacleFunc;
    self.temp[4] = title;
    self.temp[5] = tips;
    self.temp[6] = okLabel;
    self.temp[7] = CancleLabel;
    self.temp[8] = MoreTips;
    UIService:Instance():ShowUI(UIType.CommonOKOrCancle, self.temp);
end

function CommonService:ShowString(stringType)
    return DataText[stringType].TextContent
end

-- 通用时间转字符串 单位：秒  转换格式：  02:20:34
function CommonService:GetDateString(costTime)
    local timeString = nil;
    local t1, t2 = math.modf(costTime / 3600);
    local hour = t1;
    local t3, t4 = math.modf((costTime - t1 * 3600) / 60);
    local minute = t3;
    local second = costTime % 60;
    if hour < 10 then
        hour = "0" .. hour;
    end
    if minute < 10 then
        minute = "0" .. minute;
    end
    if second < 10 then
        second = "0" .. second;
    end
    timeString = hour .. ":" .. minute .. ":" .. second;
    return timeString;
end

-- 通用字符串分割 szFullString：被分割的字符串  szSeparator：分割的字符
function CommonService:StringSplit(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = { }
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

-- 通用显示时间间隔（例：2天前）
function CommonService:GetShowBrforeTimeString(allSenondTime)
    local endString = "";
    if allSenondTime <= 10 then
        endString = endString .. "刚刚";
    elseif allSenondTime > 10 and allSenondTime < 60 then
        endString = math.floor(allSenondTime) .. "秒前";
    elseif allSenondTime >= 60 and self:FormatToMinutes(allSenondTime) < 60 then
        endString = self:FormatToMinutes(allSenondTime) .. "分钟前";
    elseif self:FormatToMinutes(allSenondTime) >= 60 and self:FormatToHours(allSenondTime) < 24 then
        endString = self:FormatToHours(allSenondTime) .. "小时前";
    elseif self:FormatToHours(allSenondTime) > 24 then
        endString = self:FormatToDays(allSenondTime) .. "天前";
    end
    return endString;
end

function CommonService:FormatToDays(allSenondTime)
    local day = math.floor(allSenondTime /(24 * 3600));
    return day;
end

function CommonService:FormatToHours(allSenondTime)
    local hour = math.floor(allSenondTime / 3600);
    return hour;
end

function CommonService:FormatToMinutes(allSenondTime)
    local minute = math.floor(allSenondTime / 60);
    return minute;
end

-- isInFort: 是否是不在要塞中
function CommonService:FormatArmyState(armyState, isNotInFort)
    local stateStrig = nil;
    if armyState == ArmyState.None then
        stateStrig = "<color=#00FF00>待命</color>";
    elseif armyState == ArmyState.BattleRoad or armyState == ArmyState.BattleIng then
        stateStrig = "<color=#00FF00>出征</color>";
    elseif armyState == ArmyState.SweepRoad or armyState == ArmyState.SweepIng then
        stateStrig = "<color=#00FF00>扫荡</color>";
    elseif armyState == ArmyState.GarrisonRoad or armyState == ArmyState.GarrisonIng then
        stateStrig = "<color=#00FF00>驻守</color>";
    elseif armyState == ArmyState.MitaRoad or armyState == ArmyState.MitaIng then
        stateStrig = "<color=#00FF00>屯田</color>";
    elseif armyState == ArmyState.TrainingRoad or armyState == ArmyState.Training then
        stateStrig = "<color=#00FF00>练兵</color>";
    elseif armyState == ArmyState.RescueRoad or armyState == ArmyState.RescueIng then
        stateStrig = "<color=#00FF00>解救</color>";
    elseif armyState == ArmyState.TransformRoad or armyState == ArmyState.TransformArrive then
        if isInFort ~= nil and isInFort == true then
            stateStrig = "<color=#808A87>调动</color>";
        else
            stateStrig = "<color=#00FF00>待命</color>";
        end
    elseif armyState == ArmyState.Back then
        stateStrig = "<color=#4169E1>返回</color>";
    end
    return stateStrig;
end

function CommonService:GetLeaguePositionName(position)
    if position == LeagueTitleType.Leader then
        return "盟主";
    elseif position == LeagueTitleType.ViceLeader then
        return "副盟主";
    elseif position == LeagueTitleType.Command then
        return "指挥官";
    elseif position == LeagueTitleType.Officer then
        return "官员";
    elseif position == LeagueTitleType.Nomal then
        return "盟员";
    end
end

-- 按钮防止连续点击
function CommonService:WaitClickButton(button)
    button.interactable = false;
    local waitTime = 0.3;
    local _coroutine = StartCoroutine( function()
        WaitForSeconds(waitTime, function() end)
        _coroutine = nil;
        button.interactable = true;
    end );
end

-- 资源、产量统一处理显示（超过10W按千(K)为单位）
function CommonService:GetResourceCount(count)
    local stringValue = "";
    if count >= 100000 then
        local thousandCount, hundredCount = math.modf(count / 1000);
        --        local hundredValue = math.floor(hundredCount * 10);
        --        stringValue = stringValue .. thousandCount .. "." .. hundredValue .. "K";
        stringValue = stringValue .. thousandCount .. "K";
    else
        stringValue = stringValue .. count;
    end
    return stringValue;
end

-- 通用背景音乐播放
function CommonService:PlayBG(path, num)
    if num ~= nil then
        self.bgmAudio.volume = num
    end
    GameResFactory.Instance():LoadAudioClip(self.bgmAudio, path, nil)
end 

function CommonService:Play(path, num)
    if num ~= nil then
        self.effectAudio.volume = num
    end
    GameResFactory.Instance():LoadAudioClip(self.effectAudio, path, nil)
end

-- true包含违禁字符
-- 违禁字符
function CommonService:LimitText(chatText)
    if chatText == nil then
        return;
    end
    local count = DataGameConfig[1001].OfficialData;
    for i = 1, count do
        if string.find(chatText, DataBannedWord[i].ShieldingWords) ~= nil then
            UIService:Instance():ShowUI(UIType.UICueMessageBox, 504);
            return true;
        end
    end
    return false;
end

function CommonService:JudeStringGetTrueCount(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat
        lastCount = self:SubStringGetByteCount(str, i);
        i = i + lastCount;
        curIndex = curIndex + 1;
    until (i > index);
    return curIndex;
end

function CommonService:SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte >= 192 and curByte <= 223 then
        byteCount = 2
    elseif curByte >= 224 and curByte <= 239 then
        byteCount = 3
    elseif curByte >= 240 and curByte <= 247 then
        byteCount = 4
    end
    return byteCount;
end

function CommonService:ClearLastClickTileUI()
    for k, v in pairs(self.withTypeFadeObj) do
        for i, j in pairs(v) do
            if self.AllFadeObj[j] ~= nil then
                self.AllFadeObj[j]:ResetData(true);
            end
        end
        self.lastClickTiledIndex = nil;
    end
end

-- 物体、界面的淡入淡出效果 和 缩放效果
function CommonService:SetTweenAlphaGameObject(gameObject, isOpen, clickTiledIndex, isUI, from, to, time, callBack, isTweenScal, startScal, endScal, scalFadeTime)
    if clickTiledIndex ~= nil then
        if isUI == nil or(isUI ~= nil and isUI == false) then
            if clickTiledIndex ~= nil then
                if self.withTypeFadeObj[clickTiledIndex] == nil then
                    self.withTypeFadeObj[clickTiledIndex] = { };
                    if self.withTypeFadeObj[clickTiledIndex][gameObject] == nil then
                        self.withTypeFadeObj[clickTiledIndex][gameObject] = gameObject;
                    end
                    self.lastClickTiledIndex = clickTiledIndex;
                else
                    if self.withTypeFadeObj[clickTiledIndex][gameObject] == nil then
                        self.withTypeFadeObj[clickTiledIndex][gameObject] = gameObject;
                    end
                end
            end
        end
    end

    local group = gameObject:GetComponent(typeof(UnityEngine.CanvasGroup));
    if time ~= 0 then
        if group == nil then
            group = gameObject:AddComponent(typeof(UnityEngine.CanvasGroup));
        end
    end
    gameObject:SetActive(true);
    local fadeTime = 0;
    local startAlpha = 0;
    local endAlpha = 1;
    if isUI ~= nil and isUI == true then
        fadeTime = time * 1000;
        startAlpha = from;
        endAlpha = to;
        if scalFadeTime ~= nil then
            scalFadeTime = scalFadeTime * 1000;
        end
        self:ShowAnamation(isUI, gameObject, group, isOpen, startAlpha, endAlpha, fadeTime, callBack, isTweenScal, startScal, endScal, scalFadeTime);
    else
        fadeTime = 0.2 * 1000;
        if isOpen == true then
            startAlpha = 0;
            endAlpha = 1;
        else
            startAlpha = 1;
            endAlpha = 0;
        end
        if group == nil then
            group = gameObject:AddComponent(typeof(UnityEngine.CanvasGroup));
        end
        if scalFadeTime ~= nil then
            scalFadeTime = scalFadeTime * 1000;
        end
        self:ShowAnamation(isUI, gameObject, group, isOpen, startAlpha, endAlpha, fadeTime, function() self.withTypeFadeObj = { } end, isTweenScal, startScal, endScal, scalFadeTime);
    end
end

function CommonService:ShowAnamation(isUI, gameObject, group, isOpen, startAlpha, endAlpha, fadeTime, callBack, isTweenScal, startScal, endScal, scalFadeTime)
    if group ~= nil and fadeTime ~= 0 then
        group.alpha = startAlpha;
    end
    -- local endTime = PlayerService:Instance():GetLocalTime() + fadeTime;
    local endTime = Time.frameCount;
    local endScalTime = 0;
    if isTweenScal ~= nil and isTweenScal == true then
        gameObject.transform.localScale = Vector3.New(startScal, startScal, startScal);
        -- endScalTime = PlayerService:Instance():GetLocalTime() + scalFadeTime;
        -- endScalTime = Time.time;
        endScalTime = Time.frameCount;
    end
    if self.AllFadeObj[gameObject] == nil then
        local gameObjectFadeInfo = GameObjectFadeInfo.new();
        gameObjectFadeInfo:InitData(gameObject, group, isOpen, startAlpha, endAlpha, endTime, fadeTime, callBack, isTweenScal, startScal, endScal, endScalTime, scalFadeTime);
        self.AllFadeObj[gameObject] = gameObjectFadeInfo;
    else
        if isUI == nil then
            self.AllFadeObj[gameObject]:InitData(gameObject, group, isOpen, startAlpha, endAlpha, endTime, fadeTime, callBack);
        else
            if self.AllFadeObj[gameObject].isOpen == isOpen then
                return;
            end
            self.AllFadeObj[gameObject]:InitData(gameObject, group, isOpen, startAlpha, endAlpha, endTime, fadeTime, callBack, isTweenScal, startScal, endScal, endScalTime, scalFadeTime);
        end
    end
end

function CommonService:MoveX(obj, from, to, time, endFunction)
    local endTime = PlayerService:Instance():GetLocalTime() + time * 1000;
    if self.allMoveGameObject[obj] == nil then
        local MoveInfo = MoveInfo.new();
        MoveInfo:InitData(obj, true, false, from, to, endTime, time * 1000, endFunction);
        self.allMoveGameObject[obj] = MoveInfo;
    else
        self.allMoveGameObject[obj]:InitData(obj, true, false, from, to, endTime, time * 1000, endFunction);
    end
end

function CommonService:MoveY(obj, from, to, time, endFunction)
    local endTime = PlayerService:Instance():GetLocalTime() + time * 1000;
    if self.allMoveGameObject[obj] == nil then
        local MoveInfo = MoveInfo.new();
        MoveInfo:InitData(obj, false, true, from, to, endTime, time * 1000, endFunction);
        self.allMoveGameObject[obj] = MoveInfo;
    else
        self.allMoveGameObject[obj]:InitData(obj, false, true, from, to, endTime, time * 1000, endFunction);
    end
end

function CommonService:RemoveMoveInfo(obj)
    if self.allMoveGameObject[obj] ~= nil then
        self.allMoveGameObject[obj]:ResetData();
        self.allMoveGameObject[obj] = nil;
    end
end

function CommonService:RemoveElementByKey(tbl, key)
    -- 新建一个临时的table
    local tmp = { }
    for i in pairs(tbl) do
        table.insert(tmp, i)
    end

    local newTbl = { }
    -- 使用while循环剔除不需要的元素
    local i = 1
    while i <= #tmp do
        local val = tmp[i]
        if val == key then
            -- 如果是需要剔除则remove
            table.remove(tmp, i)
        else
            -- 如果不是剔除，放入新的tabl中
            newTbl[val] = tbl[val]
            i = i + 1
        end
    end
    return newTbl
end  


function CommonService:GetChildCount(args)
    local count = 0
    for i = 1, args.childCount do
        if args:GetChild(i - 1).gameObject.activeSelf then
            count = count + 1
        end
    end
    return count
end


return CommonService;