--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local UIBase=require("Game/UI/UIBase");
local SkillIconPart=require("SkillIconPart",UIBase);
--local CharacterInitial=require("Game/Table/model/DataCharacterInitial");

function SkillIconPart:ctor()

  --技能id
  self._skillId=nil;
  --技能名字
  self._skillNameText=nil;
    --技能icon
  self._skillSprite=nil;
  --技能学习进度text
  self._scheduleText=nil;
  --技能学习进度遮罩sprite
  self._scheduleSprite=nil;
  --技能能够学习次数和剩余学习次数
  self._learnTimesText=nil;
  --点击按钮
  self._btn=nil;
  

 SkillIconPart.super.ctor(self);
end


function SkillIconPart:DoDataExchange()
     	--self._skillNameText = self:RegisterController(UnityEngine.UI.Text,"StartGame")
	--self._skillSprite = self:RegisterController(UnityEngine.UI.Sprite,"AccountManager")



end



--iver
function UILoginGame:DoEventAdd()
    --self:AddListener(self._btn,self.OnClickOpenSkillDetailBtn);
    
end

--endregion
