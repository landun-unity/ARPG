--[[
	技能信息
--]]

local Skill = class("Skill")

function Skill:ctor()
	--战法唯一ID
	self._id          = nil

	--战法tableID
	self._tableId     = nil

	--战法研究进度
	self._progress    = nil

	--战法学习英雄列表
	self._learnHeroID = nil
end



return Skill



