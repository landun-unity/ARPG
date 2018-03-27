--[[
	自建要塞，可以驻军
--]]

local PlayerBuilding = require("Game/Build/Subject/PlayerBuilding")

local PlayerFort = class("PlayerFort",PlayerBuilding)

function PlayerFort:ctor()
	PlayerFort.super.ctor(self);

	-- 要塞内部队
	self._allArmyList = {};

	-- 要塞等级
    self._fortGrade = 0;

    -- 要塞红点
    self.FortRed = 0
end

-- 根据索引获取要塞内部队
function PlayerFort:GetArmyInfos(index)
	if nil == index then
		return nil;
	end
	if index < 1 or index > self._fortGrade then
		return nil;
	end
	return self._allArmyList[index]
end

-- 获取要塞内部队数量
function PlayerFort:GetArmyInfoCounts()
	return #self._allArmyList;
end

-- 要塞内插入部队
function PlayerFort:SetArmyInfo(armyinfo,index)
	if self:IsContainArmy(armyinfo) then
		return;
	end
	self._allArmyList[index]=armyinfo;
	--table.insert(self._allArmyList, armyinfo)
end

-- function PlayerFort:AddArmyInfo(armyinfo)
-- 	-- body
-- 	self:SetArmyInfo(armyinfo);
-- end

function PlayerFort:SetFortRed(count)
	self.FortRed = count
end

function PlayerFort:GetFortRed()
	return self.FortRed
end

-- 要塞中是否包含部队
function PlayerFort:IsContainArmy(armyinfo)
	for index = 1, #self._allArmyList do
		local tempArmy = self._allArmyList[index]
		if tempArmy == armyinfo then
			return true
		end
	end
	return false
end

-- 移除要塞内的部队
function PlayerFort:RemoveArmyInfo(armyinfo)
	--print("PlayerFort:RemoveArmyInfo=======================")
	for k,v in pairs(self._allArmyList) do
		if v == armyinfo then
			table.remove(self._allArmyList, k)
		end
	end
end

function PlayerFort:SetFortGrade(count)
	self._fortGrade = count
end

function PlayerFort:GetFortGrade()
	return self._fortGrade;
end

--获取要塞内征兵队伍数量
function PlayerFort:GetFortArmyConscritionCount()
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
function PlayerFort:GetArmyIndex(spawnBuild, spawnSlot)
    for k,v in pairs(self._allArmyList) do
		if v.spawnBuildng == spawnBuild and v.spawnSlotIndex == spawnSlot then
			return k;
		end
	end
    --保底
    return 1;
end



return PlayerFort