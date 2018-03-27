
local UIBase= require("Game/UI/UIBase");
local UIService=require("Game/UI/UIService");
local UIType=require("Game/UI/UIType");
require("Game/Recruit/RecruitService");

local CommonGoToPosition=class("CommonGoToPosition",UIBase);

function CommonGoToPosition:ctor()
    CommonGoToPosition.super.ctor(self)
end

--??????
function CommonGoToPosition:DoDataExchange()
    --self.Title = self:RegisterController(UnityEngine.UI.Text,"Title")
    self.Des = self:RegisterController(UnityEngine.UI.Text,"Des")
    self.Tips = self:RegisterController(UnityEngine.UI.Text,"Bg/Tips")
    self.OkBtn = self:RegisterController(UnityEngine.UI.Button,"OkBtn")
    self.CancleBtn = self:RegisterController(UnityEngine.UI.Button,"CancleBtn")
    self.BackBtn = self:RegisterController(UnityEngine.UI.Button,"BackBtn")
end

--?????????????
function CommonGoToPosition:DoEventAdd()
  self:AddListener(self.OkBtn,self.OnClickOKBtn)
  self:AddListener(self.CancleBtn,self.OnClickCancleBtn)
   self:AddListener(self.BackBtn,self.OnClickCloseBtn)
end

--??????????????????????????
function CommonGoToPosition:OnClickCloseBtn()
   UIService:Instance():HideUI(UIType.CommonGoToPosition)
end

function CommonGoToPosition:OnShow(parem)
    self.Des.text = parem[1];
    self.go = parem[2];
    self.fun1 = parem[3];
    self.fun2 = parem[4];
   
    --print(self.fun1);
    --print(self.fun2);
end

function CommonGoToPosition:OnClickOKBtn()
     if(self.fun1 ~=nil) then
        self.fun1(self.go);
    end
    UIService:Instance():HideUI(UIType.CommonGoToPosition)
end


function CommonGoToPosition:OnClickCancleBtn()
    if(self.fun2 ~=nil) then
        self.fun2(self.go);
    end
    self:OnClickCloseBtn();
end

return CommonGoToPosition;