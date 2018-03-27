
--招募的卡包信息
local RecruitPackageInfo = class("RecruitPackageInfo")


function RecruitPackageInfo:ctor()
    self._recruitPackageId = 0;
    self._isFree = false;
    self._isDiscount = false;
    self._curRecruitTimes = 0;
    self._overTime = 0;
    self._lastFreeTime = 0;
    self._openBatch = false;
    self._cardLevel = 1;
    self._isNew = 0;
    self._tableId = 0;
    self._isMerge = 0;
    self._isOpen = 0;
end

function RecruitPackageInfo:Init(model)
    self._recruitPackageId = model.recruitPackageId
    self._isFree = model.isFree
    self._isDiscount = model.isDiscount
    self._curRecruitTimes = model.curRecruitTimes
    self._overTime = model.overTime
    self._lastFreeTime =  model.lastFreeTime
    self._openBatch =  model.openBatch
    self._cardLevel = model.cardLevel;
    self._isNew = model.isNew;
    self._tableId = model.tableId;
    self._isMerge = model.isMerge;
    self._isOpen = model.isOpen;
end

return RecruitPackageInfo