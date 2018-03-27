--[[
	军营
--]]

local WildBuilding = require("Game/Build/Subject/WildBuilding")

local WildGarrisonBuilding = class("WildGarrisonBuilding",WildBuilding)

function WildGarrisonBuilding:ctor()
    WildGarrisonBuilding.super.ctor(self);
	self._fortGrade = 5;
    self._allArmyList = {};
    self.FortRed = 0
end

-- 根据索引获取要塞内部队
function WildGarrisonBuilding:GetWildFortArmyInfos(index)
	if nil == index then
		return nil;
	end
	if index < 1 or index > self._fortGrade then
		return nil;
	end
	return self._allArmyList[index]
end

-- 获取要塞内部队数量
function WildGarrisonBuilding:GetWildFortArmyInfoCounts()
	return #self._allArmyList;
end

-- 要塞内插入部队
function WildGarrisonBuilding:SetWildFortArmyInfo(armyinfo,index)
	if self:IsWildFortContainArmy(armyinfo) then
		return;
	end
	self._allArmyList[index]=armyinfo;
	--table.insert(self._allArmyList, armyinfo)
end

function WildGarrisonBuilding:SetFortRed(count)
	self.FortRed = count
end

function WildGarrisonBuilding:GetFortRed()
	return self.FortRed
end

-- 要塞中是否包含部队
function WildGarrisonBuilding:IsWildFortContainArmy(armyinfo)
	for index = 1, #self._allArmyList do
		local tempArmy = self._allArmyList[index]
		if tempArmy == armyinfo then
			return true
		end
	end
	return false
end

-- 移除要塞内的部队
function WildGarrisonBuilding:RemoveWildFortArmyInfo(armyinfo)
	for k,v in pairs(self._allArmyList) do
		if v == armyinfo then
			table.remove(self._allArmyList, k)
		end
	end
end

-- 移除要塞内的部队
function WildGarrisonBuilding:RemoveArmyInfo(armyinfo)
	--print("WildFort:RemoveArmyInfo");
	self:RemoveWildFortArmyInfo(armyinfo);
end


--获取要塞内征兵队伍数量
function WildGarrisonBuilding:GetWildFortArmyConscritionCount()
    local count =0;
    if self._allArmyList ~= nil then 
        for i=1,#self._allArmyList do
            if self._allArmyList[i]~= nil then 
                if self._allArmyList[i]:IsArmyInConscription() == true then 
                    count = count+1;
                end
            end
        end
    end
    return count;
end

-- 获取部队在要塞中的index索引
function WildGarrisonBuilding:GetWildFortArmyIndex(spawnBuild, spawnSlot)
    for k,v in pairs(self._allArmyList) do
		if v.spawnBuildng == spawnBuild and v.spawnSlotIndex == spawnSlot then
			return k;
		end
	end
    --保底
    return 1;
end


function WildGarrisonBuilding:SetArmyInfo(armyinfo,index)
	-- body
	self:SetWildFortArmyInfo(armyinfo,index);
end


return WildGarrisonBuilding