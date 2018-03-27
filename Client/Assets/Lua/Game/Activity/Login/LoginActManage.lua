--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--登陆奖励管理

local UIService = require("Game/UI/UIService");
local UIType = require("Game/UI/UIType");
local ActivityType = require("Game/Activity/ActivityType");

local GamePart = require("FrameWork/Game/GamePart")
local LoginActManage = class("LoginActManage", GamePart)

require("Game/Table/model/DataLoginGift")

-- 构造函数
function LoginActManage:ctor()
    LoginActManage.super.ctor(self);
    self._canGet = false;
    self._index = 0;
end

-- 初始化
function LoginActManage:_OnInit()
	
end

-- 同步信息
function LoginActManage:UpdateLoginActData(msg)
    --print("每日奖励当前天对应表id为:" .. msg.giftID .. " 可领取状态为:" .. msg.canReceive .. "  1是可领");

    local canGet = msg.canReceive;
    if canGet == 1 then
        self._canGet = true;
    else
        self._canGet = false;
    end

    self._index = msg.giftID;

    if self._canGet == true then
        UIService:Instance():ShowUI(UIType.UIActivity, ActivityType.LoginAct);
    end
end

-- 获取当前轮次所有表数据
function LoginActManage:GetCurAllDataList()
    local curData = DataLoginGift[self._index];
    if curData == nil then
        return nil;
    end

    local curTurn = curData.round;
    if curTurn == nil then
        return nil;
    end

    local tempList = {};
    for i,v in pairs(DataLoginGift) do
        if v.round == curTurn then
            tempList[v.Day] = v;
        end
    end

    return tempList;
end

-- 获取当前领取到了第几天
function LoginActManage:GetCurDay()
    local curData = DataLoginGift[self._index];
    if curData == nil then
        return nil;
    end

    return curData.Day;
end

-- 获取当前是否可领
function LoginActManage:GetIsCanGet()
    return self._canGet;
end

return LoginActManage;

--endregion
