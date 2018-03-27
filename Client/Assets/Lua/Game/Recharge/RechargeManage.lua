
local GamePart = require("FrameWork/Game/GamePart")

local RechargeManage = class("RechargeManage",GamePart)
local DataRecharge = require("Game/Table/model/DataRecharge");

function RechargeManage:ctor()
    
    RechargeManage.super.ctor(self)
    
    self.firstRecharge = {} ;           --每档次充值的首冲状态（true冲过 false未冲） key:下标（没用） Value:RechargeInfoItem
    self.monthCardOpen = false;         --月卡是否开启
end

-- 初始化
function RechargeManage:_OnInit()
end

-- 心跳
function RechargeManage:_OnHeartBeat()
    
end

-- 停止
function RechargeManage:_OnStop()
    
end

--保存玩家的所有充值信息
function RechargeManage:SaveAllRechargeInfo(allInfoTable)
    self.firstRecharge = allInfoTable;
    self:RefreshMonthCardState();
end

--检测月卡是否开启
function RechargeManage:CheckMonthCardOpen()
    return self.monthCardOpen;
end

--获取月卡剩余的时间 （isDayTime == true 单位：天,带小数    isDayTime == false 单位：小时,带小数 ）
function RechargeManage:GetMonthCardleftTime(isDayTime)
    local monthCardInfo = self:GetMonthCardRechargeInfo();
    if monthCardInfo ==nil then 
        return 0;
    end
    local endTime = monthCardInfo.monthCardEndTime;
    local curTimeStamp = PlayerService:Instance():GetLocalTime();
    local leftTime = endTime - curTimeStamp;
    local perTime = 0;
    if isDayTime == true then
        perTime = 24*3600*1000;
    else
        perTime = 3600*1000;
    end
    --print("月卡剩余时间 "..leftTime/perTime);
    return leftTime/perTime;
end

--判断玩家是否可以领取月卡
function RechargeManage:CheckCouldGetMonthCard()
    if self:CheckMonthCardOpen() ==true then
        local monthCardInfo = self:GetMonthCardRechargeInfo();
        if monthCardInfo.monthCardEndTime ~= 0 then
            if monthCardInfo.lastGetTime == 0 then
                return true;
            else
                return false;
            end
        end
    else
        return false;
    end
end

--获取月卡充值信息
function RechargeManage:GetMonthCardRechargeInfo()
    for k,v in pairs(self.firstRecharge) do
        local dataRecharge = DataRecharge[v.rechargeId];
        if dataRecharge.Type == 1 then  
            return v;
        end
    end
    return nil;
end

function RechargeManage:RefreshMonthCardState()
    local monthCardInfo = self:GetMonthCardRechargeInfo();
    if monthCardInfo~= nil then    
        if monthCardInfo.monthCardEndTime ~= 0 then
            self.monthCardOpen = true;
        else
            self.monthCardOpen = false;
        end
    end
end

--更新玩家的充值信息  data：RechargeInfoItem
function RechargeManage:SaveRechargeInfo(data)
    local rechargeItem = self:GetRechargeInfoItem(data.rechargeId);
    if rechargeItem ~= nil then
       rechargeItem.firstRecharge = data.firstRecharge;
       rechargeItem.lastGetTime = data.lastGetTime;
       rechargeItem.monthCardEndTime = data.monthCardEndTime;
    else
       self.firstRecharge[#self.firstRecharge+1] = data;
    end

    --如果是月卡刷新月卡信息
    local dataRecharge = DataRecharge[data.rechargeId];
    if dataRecharge.Type == 1 then 
        self:RefreshMonthCardState();
    end    
end

--更新玩家月卡领取信息
function RechargeManage:SaveGetMonthCardInfo(getTime)
    local monthCardInfo = self:GetMonthCardRechargeInfo();
    if monthCardInfo~= nil then  
        monthCardInfo.lastGetTime = getTime;
    end
end

--获取单条充值信息
function RechargeManage:GetRechargeInfoItem(rechargeId)
    for k,v in pairs(self.firstRecharge) do
        if v.rechargeId == rechargeId then
            return v;
        end
    end
    return nil;
end

--获取某个充值档次是否冲过
function RechargeManage:CheckInfoItemFirstRecharge(rechargeId)
    local rechargeItem = self:GetRechargeInfoItem(rechargeId);
    if rechargeItem~= nil then
        if rechargeItem.firstRecharge == 0 then 
            return false;
        else
            return true;
        end
    end
    return false;
end


return RechargeManage
