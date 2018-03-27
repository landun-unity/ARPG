local GameService = require("FrameWork/Game/GameService")
local BattleReportManage =  require("Game/BattleReport/BattleReportManage");
local BattleReportHandler = require("Game/BattleReport/BattleReportHandler")
local List = require("common/List");
local BattleResultType = require("Game/BattleReport/BattleResultType");
BattleReportService = class("BattleReportService", GameService)

local BattleReportType = require("Game/BattleReport/BattleReportType");

function BattleReportService:ctor( )
    BattleReportService._instance = self;
    BattleReportService.super.ctor(self, BattleReportManage.new(), BattleReportHandler.new());
end


function BattleReportService:Instance()
	return BattleReportService._instance
end

--清空数据
function BattleReportService:Clear()
    self._logic:ctor()
end

function BattleReportService:GetReportListCountByType(reportType)
    return self._logic:GetReportListCountByType(reportType);
end

function BattleReportService:ReadOneReport(id,continueIndex)
    return self._logic:ReadOneReport(id,continueIndex);
end

function BattleReportService:GetAllReportListByType(reportType,openInfo)
	 return self._logic:GetAllReportListByType(reportType,openInfo)
end

function BattleReportService:GetConReprotUnreadCount(reportType,id)
	 return self._logic:GetConReprotUnreadCount(reportType,id)
end

function BattleReportService:GetReportInfo(reportType, index)
	 return self._logic:GetReportInfo(reportType, index)
end

function BattleReportService:ClearAllReport()
     return self._logic:ClearAllReport()
end

function BattleReportService:SetAllBattleReportRead()
    self._logic:SetAllBattleReportRead()
end

function BattleReportService:SetOneBattleReportRead(byteArryID)
    self._logic:SetOneBattleReportRead(byteArryID)
end

function BattleReportService:SetLastClickID(LastID)
    self._logic:SetLastClickID(LastID)
end

function BattleReportService:GetLastClickID()
    return self._logic:GetLastClickID()
end

function BattleReportService:SetLastClickIndex(LastIndex)
    self._logic:SetLastClickIndex(LastIndex)
end

function BattleReportService:GetLastClickIndex()
    return self._logic:GetLastClickIndex()
end

function BattleReportService:GetBattleReportInfoById(id,index)
    return self._logic:GetBattleReportInfoById(id,index)
end

--直接保存 不用转化结构
function BattleReportService:TransModelToStruct(reportmodel)
    self._logic:SetBattleReportDetail(reportmodel);
end

function BattleReportService:GetUnReadCount()
    return self._logic:GetUnReadCount()
end

function BattleReportService:GetUnReadCount()
    return self._logic:GetUnReadCount()
end

function BattleReportService:GetResultSprite(reslult)
    local temp = "";
    if(BattleResultType.Win == reslult) then
        temp = "WinFlag"
    end
    if(BattleResultType.Lose == reslult) then
         temp = "LossFlag"
    end
    if(BattleResultType.Draw == reslult) then
         temp = "draw"
    end
    if(BattleResultType.NoBattle == reslult) then
         temp = "NotFight"
    end
    if(BattleResultType.DieTogether == reslult) then
         temp = "DieTogether"
    end
    return temp
end

function BattleReportService:GetResultText(battletype,reslult,drawtimes)
    local temp = "";
    if(battletype == BattleReportType.Defence) then
        if(BattleResultType.Win == reslult) then
            temp = "【我方战败】"
        end
        if(BattleResultType.Lose == reslult) then
             temp = "【我方胜利】"
        end
        if(BattleResultType.Draw == reslult) then
             temp = "【未分胜负，敌军继续战斗】"
        end
        if(BattleResultType.DieTogether == reslult) then
             temp = "【两败俱伤，罢兵回城】"
        end
    else
        if(BattleResultType.Win == reslult) then
            temp = "【我方胜利】"
        end
        if(BattleResultType.Lose == reslult) then
             temp = "【我方战败】"
        end
        if(BattleResultType.Draw == reslult) then
             temp = "【未分胜负，继续战斗】   (剩余战斗次数"..drawtimes..")"
        end
        if(BattleResultType.DieTogether == reslult) then
             temp = "【两败俱伤，罢兵回城】"
        end
    end
    return temp
end

function BattleReportService:GetResultSpriteFlag(reslult)
    local temp = "";
    if(BattleResultType.Win == reslult) then
        temp = "BigWin"
    end
    if(BattleResultType.Lose == reslult) then
         temp = "BigLoss"
    end
    if(BattleResultType.Draw == reslult) then
         temp = "BigDraw"
    end
    if(BattleResultType.NoBattle == reslult) then
        temp = "NotFight";
    end
    if(BattleResultType.DieTogether == reslult) then
         temp = "DieTogether"
    end
    return temp
end

function BattleReportService:SetCurrentDetailInfo(info)
     self._logic:SetCurrentDetailInfo(info)
end

function BattleReportService:GetCurrentDetailInfo()
     return self._logic:GetCurrentDetailInfo()
end

function BattleReportService:isOurPart(AttackPart,battletype)
     if((AttackPart and battletype ~= BattleReportType.Defence)or(AttackPart == false and battletype == BattleReportType.Defence)) then
            return true;
     end
     return false;
end

function BattleReportService:getAttackerOrDefenderSprite(isAttaker,IsOurPart)
    if(isAttaker) then
        if(IsOurPart) then
            return "SighAttaker" --我方攻击者
        else
            return "SighAttaker_Red"--敌方攻击者
        end
    else
        if(IsOurPart) then
            return "SighDefender_Green"--我方防御者
        else
            return "SighDefender"--敌方防御者
        end
    end
    return ""
end


--判断某个战报里某个英雄是不是攻击者
function BattleReportService:IsAttacker(herotableID)
    local detailinfo = self:GetCurrentDetailInfo()
    if(detailinfo~=nil) then
        for index = 1,detailinfo.AttackHero:Count() do
            local heroinfo = detailinfo.AttackHero:Get(index)
            if(heroinfo~=nil)then
                if(heroinfo.heroid == herotableID)then
                    return true;
                end
            end
        end
    end
    return false
end

function BattleReportService:SetGroup(group)
    self._logic:SetGroup(group)
end

function BattleReportService:GetGroup()
    return self._logic:GetGroup()
end

function BattleReportService:GetTiledName(tiledid, type, buildingID, name)
    return self._logic:GetTiledName(tiledid, type, buildingID, name)
end

return BattleReportService

