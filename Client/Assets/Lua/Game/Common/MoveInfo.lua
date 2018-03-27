
local MoveInfo = class("MoveInfo")

function MoveInfo:ctor()
    self.moveObj = nil;
    self.moveX = false;
    self.moveY = false;
    self.from = 0;
    self.to = 0;
    self.endTime = 0;
    self.moveTime = 0;
    self.endFunction = nil; 
end

function MoveInfo:InitData(moveObj,moveX,moveY,from,to,endTime,moveTime,endFunction)
    self.moveObj = moveObj;
    self.moveX = moveX;
    self.moveY = moveY;
    self.from = from;
    self.to = to;
    self.endTime = endTime;
    self.moveTime = moveTime;
    self.endFunction = endFunction; 
end

function MoveInfo:ResetData()
    if self.moveObj ~= nil then
        self.moveObj = nil;
    end
    self.moveX = false;
    self.moveY = false;
    self.from = 0;
    self.to = 0;
    self.endTime = 0;
    self.moveTime = 0;
    self.endFunction = nil; 
end

function MoveInfo:Move()
    if self.moveObj ~= nil then
        local cdTime = (self.endTime - PlayerService:Instance():GetLocalTime());
        if self.moveTime ~= 0 then
            local posValue = self.from + (1-(self.endTime - PlayerService:Instance():GetLocalTime())/self.moveTime) * (self.to - self.from);
            if  self.moveX == true and self.moveY == false then
                self.moveObj.transform.localPosition = Vector3.New(posValue,self.moveObj.transform.localPosition.y,self.moveObj.transform.localPosition.z);
            elseif self.moveX == false and self.moveY == true then
                self.moveObj.transform.localPosition = Vector3.New(self.moveObj.transform.localPosition.x,posValue,self.moveObj.transform.localPosition.z);
            end
            if PlayerService:Instance():GetLocalTime() >= self.endTime then
                if  self.moveX == true and self.moveY == false then
                    self.moveObj.transform.localPosition = Vector3.New(self.to,self.moveObj.transform.localPosition.y,self.moveObj.transform.localPosition.z);
                elseif self.moveX == false and self.moveY == true then
                    self.moveObj.transform.localPosition = Vector3.New(self.moveObj.transform.localPosition.x,self.to,self.moveObj.transform.localPosition.z);
                end
                if self.moveObj ~= nil then
                    CommonService:Instance():RemoveMoveInfo(self.moveObj);
                    if self.endFunction ~= nil then
                        self.endFunction();
                    end
                end
            end
        end
    end
end

return MoveInfo