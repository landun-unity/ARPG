-- region *.lua
-- Date 16.11.1
-- 武将

local List = require("common/List")
local UIBase = require("Game/UI/UIBase");
local UIHeroCardInfo = class("UIHeroCardInfo", UIBase);
local DataHero = require("Game/Table/model/DataHero");
local DataSkill = require("Game/Table/model/DataSkill");
local DataHeroLevel = require("Game/Table/model/DataHeroLevel");
local DataSkill = require("Game/Table/model/DataSkill");
local ChangPosition = UnityEngine.Vector3(0, 40, 0);
local ChangeObj = nil;
local EffectsType = require("Game/Effects/EffectsType")
local MoveTime = 0.1;
local GeneralBackdropImagePos = Vector3.New(213, 0, 0);
local AddPointPos = Vector3.New(1000, 0, 0);
local ArmyType = require("Game/Hero/HeroCardPart/ArmyType")
local CampType = require("Game/Hero/HeroCardPart/CampType");
local add = "AddBright"
local add1 = "Add1"
local sub = "SubtractBright";
local sub1 = "Subtract";
local splite = "Disassemble1"
local splitebright = "Disassemble"

-- override
function UIHeroCardInfo:ctor()

    self.data = { };
    -- ----print("UIHeroCardInfo:ctor");
    UIHeroCardInfo.super.ctor(self);
    -- 英雄id
    self._heroId = 0;
    -- 英雄名字
    self._heroNameText = nil;
    -- 英雄等级
    self._heroLevelText = nil;
    self._level = nil;
    self.forces = nil;
    self.strength = nil;

    self.troopsMax = nil;
    self.strengthMax = nil;
    self.exp = nil;
    self.ExpMax = nil;
    self.ExpSlider = nil;
    self.StrengthSlider = nil;
    self.troopSlider = nil;

    -- 英雄cost
    self._heroCostText = nil;
    -- 英雄兵种类型
    self._heroSoldierType = nil;
    -- 英雄icon图片
    self._heroIconSprite = nil;
    -- 英雄攻击距离
    self._heroAttackDisText = nil;
    -- 英雄兵数
    self._heroSoldiersText = nil;
    -- 英雄所属大阵营(如:魏/蜀/吴)
    self._campParent = nil;

    self.heroInfo = nil;

    self._attack = nil;
    self._def = nil;
    self._attcity = nil;
    self._smart = nil;
    self._speed = nil;
    self._attackadd = nil;
    self._defadd = nil;
    self._attcityadd = nil;
    self._smartadd = nil;
    self._speedadd = nil;
    -- 洗点
    self.cleanTime = nil;
    self.cleanTimer = nil;
    self.cleanBtnText = nil;
    self.awakeImage = nil
    self._splitBtn = nil;
    self._skillBtn = nil;
    self._backBtn = nil;
    self._yellowstar = nil;
    self._redstar = nil;
    self.spirt = nil;
    --------------
    self.range = nil;
    self.cost = nil;
    self.camp = nil;
    self.skillsprite = nil;
    self.skillname = nil;
    self._type = nil;
    -- 英雄星级
    self._heroYellowStarObj = nil;
    -- 英雄进阶星级(红星)
    self._heroRedStarObj = nil;
    -- 英雄是否觉醒
    self._heroAwakeSprite = nil;
    -- 英雄是否能加点属性
    self._heroAddPointSprite = nil;

    -- 武将点击按钮
    -- self._heroBtn = nil;
    self.resetBtn = nil;
    self.skill1Btn = nil;
    self.skill1name = nil;
    self.awakeBtn = nil;
    self.awakeName = nil;
    self.pointBtn = nil;
    self.advannceBtn = nil;
    self.advanceImage = nil;
    self.canShow = nil;
    self.stateText = nil;
    self.NameText = nil;
    self.skillLevel = nil;
    self.skill1Level = nil;
    self.skillAwakeLevel = nil;
    self.skill2sprite = nil;


    --- 配点
    self.AddPoint = nil;
    self.cleanBtn = nil;
    self.back1Btn = nil;
    self.confirmBtn = nil;
    self.introBtn = nil;
    self.atksubtn = nil;
    self.atkplusBtn = nil;
    self.defsubBtn = nil;
    self.defplusBtn = nil;
    self.stysubBtn = nil;
    self.styplusBtn = nil;
    self.spdsubBtn = nil;
    self.spdplusBtn = nil;

    self.atk = nil;
    self.atk1 = nil;
    self.atk2 = nil;
    self.def = nil;
    self.def1 = nil;
    self.def2 = nil;


    self.sty = nil;
    self.sty1 = nil;
    self.sty2 = nil;

    self.spd = nil;
    self.spd1 = nil;
    self.spd2 = nil;

    self.points = nil;
    self.cleanUp = nil;
    self.confirmclean = nil;
    self.cancelclean = nil;
    self.introPoint = nil;
    self.introConfirmBtn = nil;
    self._percentChangge = nil;
    self.skill1sprite = nil;

    --- 四个加号
    self.atk3 = nil;
    self.def3 = nil;
    self.sty3 = nil;
    self.spd3 = nil;

    -- 不能觉醒
    self.CantAwake = nil;
    self.CantAwakeBtn = nil;

    -- 转换
    self.leftImage = nil;
    self.rightImage = nil;

    -- 保护
    self.isProtect = nil;
    self.ProtectPic = nil;

    self.closePic = "NoAttainLv5"
    self.defultPic = "MayStudy"
    self.commandPic = "Tactics04"
    self.attackPic = "Tactics03"
    self.activePic = "Tactics02"
    self.passivePic = "Tactics01"
    self.CantAwakeImage = "NoAwaken";

    self.panel = nil;

    -- 重置
    self.ResetUI = nil;
    self.resetInputFlied = nil;
    self.resetCancel = nil;
    self.resetConfirm = nil;
    self.resetBack = nil;
    self.resetIntro = nil;
    self.addPointBoo = nil;
    self.cardId = nil;
end

function UIHeroCardInfo:DoDataExchange()

    -- 重置
    self.ResetUI = self:RegisterController(UnityEngine.Transform, "resetUI");
    self.resetInputFlied = self:RegisterController(UnityEngine.UI.InputField, "resetUI/InputField");
    self.resetCancel = self:RegisterController(UnityEngine.UI.Button, "resetUI/resetUIcancel");
    self.resetConfirm = self:RegisterController(UnityEngine.UI.Button, "resetUI/resetUIconfirm");
    self.resetBack = self:RegisterController(UnityEngine.UI.Button, "resetUI/resetUIback");
    self.panel = self:RegisterController(UnityEngine.Transform, "HideBtnPic");
    self.cleanBtnText = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/cleancard/OneBottomImage/confirm2/Text");
    self.cleanTime = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/cleancard/OneBottomImage/ChineseImage/Text (1)");
    self._heroNameText = self:RegisterController(UnityEngine.UI.Text, "HeroNameText");
    self.resetIntro = self:RegisterController(UnityEngine.UI.Text, "resetUI/resetbackground/Translucence/Text1")

    -- 英雄等级
    self._heroLevelText = self:RegisterController(UnityEngine.UI.Text, "GradeText/Text");
    -- 英雄cost
    self._heroCostText = self:RegisterController(UnityEngine.UI.Text, "Cost/CostValue");
    -- 英雄兵种类型
    self._heroSoldierType = self:RegisterController(UnityEngine.Transform, "SoldierType");
    -- 英雄icon图片
    self._heroIconSprite = self:RegisterController(UnityEngine.UI.Image, "HeroHeadImage");
    -- 英雄攻击距离
    self._heroAttackDisText = self:RegisterController(UnityEngine.UI.Text, "DistanceText");
    self._heroSoldiersText = self:RegisterController(UnityEngine.UI.Text, "NumberImage/BackGround/TroopsText");
    -- 英雄所属大阵营(如:魏/蜀/吴)
    self._campParent = self:RegisterController(UnityEngine.Transform, "StateFormImage");
    self._attack = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/attack/Text");
    self._def = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/def/Text");
    self._attcity = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/attCity/Text");
    self._smart = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/smart/Text");
    self._speed = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/speed/Text");

    self._attackadd = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/attack/T");
    self._defadd = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/def/T");
    self._attcityadd = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/attCity/T");
    self._smartadd = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/smart/T");
    self._speedadd = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/speed/T");
    -- 保护
    self.ProtectPic = self:RegisterController(UnityEngine.Transform, "ProtectSwitch/Image");
    self._isProtect = self:RegisterController(UnityEngine.UI.Image, "ProtectSwitch");
    self.ProtectBtn = self:RegisterController(UnityEngine.UI.Button, "ProtectSwitch");
    self.Protext = self:RegisterController(UnityEngine.UI.Text, "ProtectSwitch/Text");
    self._splitBtn = self:RegisterController(UnityEngine.UI.Button, "split");
    self._backBtn = self:RegisterController(UnityEngine.UI.Button, "back");
    self._yellowstar = self:RegisterController(UnityEngine.Transform, "hideMask/GeneralBackdropImage/StarImageSide/YellowStar");
    self._redstar = self:RegisterController(UnityEngine.Transform, "hideMask/GeneralBackdropImage/StarImageSide/RedStar");
    self.range = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/range/Text");
    self.cost = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/cost/Text");
    self.camp = self:RegisterController(UnityEngine.Transform, "hideMask/GeneralBackdropImage/camp/GameObject");
    self.skillsprite = self:RegisterController(UnityEngine.UI.Image, "skill/skillimage");
    self.skill1sprite = self:RegisterController(UnityEngine.UI.Image, "skill1/skill1image")
    self.skill2sprite = self:RegisterController(UnityEngine.UI.Image, "awake/skill2image")
    self.skillname = self:RegisterController(UnityEngine.UI.Text, "skill/Text");
    self.skill1name = self:RegisterController(UnityEngine.UI.Text, "skill1/Text");
    self.awakeName = self:RegisterController(UnityEngine.UI.Text, "awake/Text");
    self.skillLevel = self:RegisterController(UnityEngine.UI.Text, "skill/Image/Text");
    self.skill1Level = self:RegisterController(UnityEngine.UI.Text, "skill1/Image/Text");
    self.skillAwakeLevel = self:RegisterController(UnityEngine.UI.Text, "awake/Image/Text");
    self._skillBtn = self:RegisterController(UnityEngine.UI.Button, "skill");
    self.skill1Btn = self:RegisterController(UnityEngine.UI.Button, "skill1");
    self.awakeBtn = self:RegisterController(UnityEngine.UI.Button, "awake");
    self._type = self:RegisterController(UnityEngine.Transform, "hideMask/GeneralBackdropImage/SoldierTypeSide");
    self._level = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/Level/LevelText");
    self.forces = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/forces/Text");
    self.strength = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/strength/Text");
    self.exp = self:RegisterController(UnityEngine.UI.Text, "hideMask/GeneralBackdropImage/Level/Text");
    self.ExpSlider = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/Level/TroopsStripImage/ArticleIsLoadedImage");
    self.StrengthSlider = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/strength/TroopsStripImage/ArticleIsLoadedImage");
    self.troopSlider = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/forces/TroopsStripImage/ArticleIsLoadedImage");
    -- 英雄星级
    self._heroYellowStarObj = self:RegisterController(UnityEngine.Transform, "StarImage/YellowStar");
    -- 英雄进阶星级(红星)
    self._heroRedStarObj = self:RegisterController(UnityEngine.Transform, "StarImage/RedStar");
    self.resetBtn = self:RegisterController(UnityEngine.UI.Button, "reset");
    self.pointBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/GeneralBackdropImage/point");
    self.advannceBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/GeneralBackdropImage/advance");
    self.advanceImage = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/advance/advanceImage");
    self._heroAddPointSprite = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/point/Image");
    self.stateText = self:RegisterController(UnityEngine.UI.Text, "StatusText/StateText");
    self.NameText = self:RegisterController(UnityEngine.UI.Text, "StatusText/NameText");
    -- 配点
    self.cleanBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/clean");
    self.back1Btn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/back1");
    self.confirmBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/confirm");
    self.introBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/intro");
    self.atksubtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/atksub");
    self.atkplusBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/atkplus");
    self.defsubBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/defsub");
    self.defplusBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/defplus");
    self.stysubBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/stysub");
    self.styplusBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/styplus");
    self.spdsubBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/spdsub");
    self.spdplusBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/spdplus");
    self.atk = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/atk");
    self.atk1 = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/atk/Text");
    self.atk2 = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/atk/Text1");
    self.def = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/def");
    self.def1 = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/def/Text");
    self.def2 = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/def/Text1");
    self.sty = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/sty");
    self.sty1 = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/sty/Text");
    self.sty2 = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/sty/Text1");
    self.spd = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/spd");
    self.spd1 = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/spd/Text");
    self.spd2 = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/spd/Text1");
    self.points = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/points");
    self.cleanUp = self:RegisterController(UnityEngine.Transform, "hideMask/AddPoint/cleancard");
    self.confirmclean = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/cleancard/OneBottomImage/confirm2");
    self.cancelclean = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/cleancard/OneBottomImage/cancel");
    self.introPoint = self:RegisterController(UnityEngine.Transform, "hideMask/AddPoint/introPoint");
    self.introConfirmBtn = self:RegisterController(UnityEngine.UI.Button, "hideMask/AddPoint/introPoint/Image/confirm1");
    self._percentChangge = self:RegisterController(UnityEngine.Transform, "Partilce/Text");

    self.atk3 = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/atk/Text2");
    self.def3 = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/def/Text2");
    self.sty3 = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/sty/Text2");
    self.spd3 = self:RegisterController(UnityEngine.UI.Text, "hideMask/AddPoint/spd/Text2");

    -- 不能觉醒
    self.awakeImage = self:RegisterController(UnityEngine.Transform, "_AwakeImage");
    self.CantAwake = self:RegisterController(UnityEngine.Transform, "CantAwake");
    self.CantAwakeBtn = self:RegisterController(UnityEngine.UI.Button, "CantAwake/confirmawake");
    -- 转换
    self.leftImage = self:RegisterController(UnityEngine.UI.Button, "LeftImage");
    self.rightImage = self:RegisterController(UnityEngine.UI.Button, "RightImage");
    -- 点击配点效果
    self.GeneralBackdropImage = self:RegisterController(UnityEngine.Transform, "hideMask/GeneralBackdropImage");
    self.AddPoint = self:RegisterController(UnityEngine.Transform, "hideMask/AddPoint");
    -- 点击属性Tips提示
    self.Tips1 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/RarityTips");
    self.Tips2 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/LevelTips");
    self.Tips3 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/soliderNumTips");
    self.Tips4 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/powertips");
    self.Tips5 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/solidertypeTips");
    self.Tips6 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/costTips");
    self.Tips7 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/rangeTips");
    self.Tips8 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/campTips");
    self.Tips9 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/attackTips");
    self.Tips10 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/defTips");
    self.Tips11 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/smartTips");
    self.Tips12 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/seigeTips");
    self.Tips13 = self:RegisterController(UnityEngine.UI.Image, "hideMask/GeneralBackdropImage/speedTips");
end

function UIHeroCardInfo:DoEventAdd()


    -- z转换卡牌
    self:AddListener(self.leftImage, self.OnClickleftImageBtn)
    self:AddListener(self.rightImage, self.OnClickrightImageBtn)
    self:AddListener(self._backBtn, self.OnClickBackBtn)
    self:AddListener(self._splitBtn, self.OnClick_splitBtn)
    self:AddListener(self._skillBtn, self.OnClick_skillBtn)
    self:AddListener(self.resetBtn, self.OnClickresetBtn)
    self:AddListener(self.skill1Btn, self.OnClickskill1Btn)
    self:AddListener(self.awakeBtn, self.OnClickawakeBtn)
    self:AddListener(self.pointBtn, self.OnClickapointBtn)
    self:AddListener(self.advannceBtn, self.OnClickadvannceBtn)

    -- 配点
    self:AddListener(self.cleanBtn, self.OnClickcleanBtn)
    self:AddListener(self.back1Btn, self.OnClickback1Btn)
    self:AddListener(self.confirmBtn, self.OnClickconfirmBtn)
    self:AddListener(self.introBtn, self.OnClickintroBtn)
    self:AddListener(self.introConfirmBtn, self.OnClickintroConfirmBtn)
    self:AddListener(self.atksubtn, self.OnClickatksubtn)
    self:AddListener(self.atkplusBtn, self.OnClickatkplusBtn)
    self:AddListener(self.defsubBtn, self.OnClickdefsubBtn)
    self:AddListener(self.defplusBtn, self.OnClickdefplusBtn)
    self:AddListener(self.stysubBtn, self.OnClickstysubBtn)
    self:AddListener(self.styplusBtn, self.OnClickstyplusBtn)
    self:AddListener(self.spdsubBtn, self.OnClickspdsubBtn)
    self:AddListener(self.spdplusBtn, self.OnClickspdplusBtn)
    self:AddListener(self.confirmclean, self.OnClickconfirmclean)
    self:AddListener(self.cancelclean, self.OnClickcancelclean)

    -- 不能觉醒
    self:AddListener(self.CantAwakeBtn, self.OnClickCantAwakeBtn)


    -- 重置
    self:AddListener(self.resetConfirm, self.OnClicresetConfirm)

    self:AddListener(self.resetBack, self.OnClickresetBack)

    self:AddListener(self.resetCancel, self.OnClickresetCancel)

    -- 保护
    self:AddListener(self.ProtectBtn, self.OnClickProtectBtn)

    -- Tips
    self:AddOnDown(self.Tips1, self.OnClickDownTips1)
    self:AddOnDown(self.Tips2, self.OnClickDownTips2)
    self:AddOnDown(self.Tips3, self.OnClickDownTips3)
    self:AddOnDown(self.Tips4, self.OnClickDownTips4)
    self:AddOnDown(self.Tips5, self.OnClickDownTips5)
    self:AddOnDown(self.Tips6, self.OnClickDownTips6)
    self:AddOnDown(self.Tips7, self.OnClickDownTips7)
    self:AddOnDown(self.Tips8, self.OnClickDownTips8)
    self:AddOnDown(self.Tips9, self.OnClickDownTips9)
    self:AddOnDown(self.Tips10, self.OnClickDownTips10)
    self:AddOnDown(self.Tips11, self.OnClickDownTips11)
    self:AddOnDown(self.Tips12, self.OnClickDownTips12)
    self:AddOnDown(self.Tips13, self.OnClickDownTips13)
    self:AddOnUp(self.Tips1, self.OnClickUpTips1)
    self:AddOnUp(self.Tips2, self.OnClickUpTips2)
    self:AddOnUp(self.Tips3, self.OnClickUpTips3)
    self:AddOnUp(self.Tips4, self.OnClickUpTips4)
    self:AddOnUp(self.Tips5, self.OnClickUpTips5)
    self:AddOnUp(self.Tips6, self.OnClickUpTips6)
    self:AddOnUp(self.Tips7, self.OnClickUpTips7)
    self:AddOnUp(self.Tips8, self.OnClickUpTips8)
    self:AddOnUp(self.Tips9, self.OnClickUpTips9)
    self:AddOnUp(self.Tips10, self.OnClickUpTips10)
    self:AddOnUp(self.Tips11, self.OnClickUpTips11)
    self:AddOnUp(self.Tips12, self.OnClickUpTips12)
    self:AddOnUp(self.Tips13, self.OnClickUpTips13)

end

-- TIpsssssss
function UIHeroCardInfo:OnClickDownTips1()
    self.Tips1.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickDownTips2()
    self.Tips2.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickDownTips3()
    self.Tips3.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickDownTips4()
    self.Tips4.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickDownTips5()
    self.Tips5.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickDownTips6()
    self.Tips6.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickDownTips7()
    self.Tips7.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickDownTips8()
    self.Tips8.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickDownTips9()
    self.Tips9.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickDownTips10()
    self.Tips10.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickDownTips11()
    self.Tips11.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickDownTips12()
    self.Tips12.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickDownTips13()
    self.Tips13.gameObject.transform:GetChild(0).gameObject:SetActive(true)
end
function UIHeroCardInfo:OnClickUpTips1()
    self.Tips1.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end
function UIHeroCardInfo:OnClickUpTips2()
    self.Tips2.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end
function UIHeroCardInfo:OnClickUpTips3()
    self.Tips3.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end
function UIHeroCardInfo:OnClickUpTips4()
    self.Tips4.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end
function UIHeroCardInfo:OnClickUpTips5()
    self.Tips5.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end
function UIHeroCardInfo:OnClickUpTips6()
    self.Tips6.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end
function UIHeroCardInfo:OnClickUpTips7()
    self.Tips7.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end
function UIHeroCardInfo:OnClickUpTips8()
    self.Tips8.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end
function UIHeroCardInfo:OnClickUpTips9()
    self.Tips9.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end
function UIHeroCardInfo:OnClickUpTips10()
    self.Tips10.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end
function UIHeroCardInfo:OnClickUpTips11()
    self.Tips11.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end
function UIHeroCardInfo:OnClickUpTips12()
    self.Tips12.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end
function UIHeroCardInfo:OnClickUpTips13()
    self.Tips13.gameObject.transform:GetChild(0).gameObject:SetActive(false)
end



function UIHeroCardInfo:OnClicresetConfirm()

    if self.resetInputFlied.text == "重置" then
        self.ResetUI.gameObject:SetActive(false)
        HeroService:Instance():SendResetCardMessage(self.data[1].id)
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.InputReset)
    end

end

function UIHeroCardInfo:OnClickresetBack()
    self.ResetUI.gameObject:SetActive(false)

end

function UIHeroCardInfo:OnClickresetCancel()
    self.ResetUI.gameObject:SetActive(false)

end


function UIHeroCardInfo:OnClickProtectBtn()

    if self.data[1].isProtect == false then

        HeroService:Instance():SendCardProtect(self.data[1].id, true)
    else
        HeroService:Instance():SendCardProtect(self.data[1].id, false)
    end

end



function UIHeroCardInfo:GetArmyType(i)
    if i == ArmyType.Qi then
        return "骑"
    end
    if i == ArmyType.Gong then
        return "弓"
    end
    if i == ArmyType.Bu then
        return "步"
    end
end

function UIHeroCardInfo:GetCamp(i)
    if i == CampType.Qin then
        return "秦"
    end
    if i == CampType.Janpan then
        return "侍"
    end
    if i == CampType.Europe then
        return "都铎"
    end
    if i == CampType.Viking then
        return "维京"
    end
end


function UIHeroCardInfo:OnShow(data)

    if self:CanClick()==false then
    else
        HeroService:Instance():SetAllCardsActive(false)
    end

    self.GeneralBackdropImage.localPosition = GeneralBackdropImagePos
    self.AddPoint.localPosition = AddPointPos
    self.panel.gameObject:SetActive(false)
    self.stateText.gameObject:SetActive(false)
    self.NameText.gameObject:SetActive(false)

    self.data = data;
    self._heroId = data[1].tableID;
    self.canShow = data[2];
    self.heroInfo = DataHero[data[1].tableID];
    self.cardId = data[1].id;

    -- 重置
    self.ResetUI.gameObject:SetActive(false)
    self.resetIntro.text = "请在下方输入“重置”对<color=#00FF00>【" .. self:GetCamp(self.heroInfo.Camp) .. self.heroInfo.Name .. self:GetArmyType(self.heroInfo.BaseArmyType) .. "】</color>进行重置"

    if self.heroInfo == nil then
        -- print("HeroCard tableID  is nil!!  Need  add this  in dataHero")
    end
    self._heroNameText.text = self.heroInfo.Name;
    self._heroCostText.text = self.heroInfo.Cost;
    self._heroAttackDisText.text = self.heroInfo.AttackRange;

    self:SetSoldierType(self.heroInfo.BaseArmyType)
    self:SetSoldierTypeSide(self.heroInfo.BaseArmyType)
    self:SetCamp(self.heroInfo.Camp)

    if self.canShow == false then
        self._attack.text = self.heroInfo.AttackBase
        self._def.text = self.heroInfo.DefenseBase
        self._attcity.text = self.heroInfo.SiegeBase
        self._smart.text = self.heroInfo.SpiritBase
        self._speed.text = self.heroInfo.SpeedBase
    else
        self._attack.text = math.floor(self.heroInfo.AttackBase + data[1].level * self.heroInfo.AttackUpgrade - self.heroInfo.AttackUpgrade + data[1].attack);

        self._def.text = math.floor(self.heroInfo.DefenseBase + data[1].level * self.heroInfo.DefenseUpgrade - self.heroInfo.DefenseUpgrade + data[1].def);

        self._attcity.text = math.floor(self.heroInfo.SiegeBase +(data[1].level - 1) * self.heroInfo.SiegeUpgrade);

        self._smart.text = math.floor(self.heroInfo.SpiritBase + data[1].level * self.heroInfo.SpiritUpgrade - self.heroInfo.SpiritUpgrade + data[1].strategy);

        self._speed.text = math.floor(self.heroInfo.SpeedBase + data[1].level * self.heroInfo.SpeedUpgrade - self.heroInfo.SpeedUpgrade + data[1].speed);

        self.awakeImage.gameObject:SetActive(data[1].isAwaken)
    end


    self.range.text = self.heroInfo.AttackRange;
    self.cost.text = self.heroInfo.Cost;

    self._attackadd.text = "(+" .. self.heroInfo.AttackUpgrade .. ")";
    self._defadd.text = "(+" .. self.heroInfo.DefenseUpgrade .. ")";
    self._attcityadd.text = "(+" .. self.heroInfo.SiegeUpgrade .. ")";
    self._smartadd.text = "(+" .. self.heroInfo.SpiritUpgrade .. ")";
    self._speedadd.text = "(+" .. self.heroInfo.SpeedUpgrade .. ")";


    self:SetInfoCamp(self.heroInfo.Camp)

    local skillId = DataHero[self.data[1].tableID].SkillOriginalID
    self.skillname.text = DataSkill[skillId].SkillnameText;
    self.skillsprite.sprite = self:GetImage(DataSkill[DataHero[self.data[1].tableID].SkillOriginalID].Type)

    if self.data[1]:GetSkill(2) ~= 0 then
        self.skill1sprite.sprite = self:GetImage(DataSkill[self.data[1]:GetSkill(2)].Type)
    else
        if self.data[1].level < 5 then
            self.skill1sprite.sprite = GameResFactory.Instance():GetResSprite(self.closePic);
        else
            self.skill1sprite.sprite = GameResFactory.Instance():GetResSprite(self.defultPic);
            --- 是否打开过这张卡的特效，存贮在客户端
            if GameResFactory.Instance():GetInt(self.data[1].id .. PlayerService:Instance():GetPlayerId()) == 0 then
                EffectsService:Instance():AddEffect(self.skill1Btn.gameObject, EffectsType.UnlockEffect, 1)
                GameResFactory.Instance():SetInt(self.data[1].id .. PlayerService:Instance():GetPlayerId(), 1)
            end
        end
    end



    if self.data[1].isProtect == false then
        self.Protext.text = "未保护"
        self.ProtectPic.transform:GetChild(0).gameObject:SetActive(false)
        self.ProtectPic.transform:GetChild(1).gameObject:SetActive(true)
    else
        self.Protext.text = "已保护"
        self.ProtectPic.transform:GetChild(0).gameObject:SetActive(true)
        self.ProtectPic.transform:GetChild(1).gameObject:SetActive(false)
    end

    self.skillLevel.text = self.data[1].allSkillLevelList[1]
    self._heroIconSprite.sprite = GameResFactory.Instance():GetResSprite(self.heroInfo.LengthPortrait);

    self:SetYellowStar(self.heroInfo.Star, self._heroYellowStarObj)
    self:SetYellowStar(self.heroInfo.Star, self._yellowstar)
    ---------------------------------技能图片
    if self.canShow == false then
        -- 英雄星级
        self:SetRedStar(self.heroInfo.Star, 0, self._redstar)
        self:SetRedStar(self.heroInfo.Star, 0, self._heroRedStarObj)
        if self.data[1].level ~= nil then
            self._level.text = "Lv." .. self.data[1].level
            self.exp.text = "0/" .. DataHeroLevel[self.data[1].level].ExperienceLevelUp;
            self._heroLevelText.text = self.data[1].level;
            self._attack.text = math.floor(self.heroInfo.AttackBase + data[1].level * self.heroInfo.AttackUpgrade - self.heroInfo.AttackUpgrade + data[1].attack);

            self._def.text = math.floor(self.heroInfo.DefenseBase + data[1].level * self.heroInfo.DefenseUpgrade - self.heroInfo.DefenseUpgrade + data[1].def);

            self._attcity.text = math.floor(self.heroInfo.SiegeBase +(data[1].level - 1) * self.heroInfo.SiegeUpgrade);

            self._smart.text = math.floor(self.heroInfo.SpiritBase + data[1].level * self.heroInfo.SpiritUpgrade - self.heroInfo.SpiritUpgrade + data[1].strategy);

            self._speed.text = math.floor(self.heroInfo.SpeedBase + data[1].level * self.heroInfo.SpeedUpgrade - self.heroInfo.SpeedUpgrade + data[1].speed);

            self.awakeImage.gameObject:SetActive(data[1].isAwaken)
        else
            self._heroLevelText.text = 1;
        end

        -- 英雄进阶星级(红星)
        -- 英雄是否觉醒
        -- 英雄是否能加点属性

        self._heroAddPointSprite.gameObject:SetActive(false);

    else

        local mhero = self.data[1]
        if self.canShow then
            self._level.text = "LV." .. mhero.level
            if PlayerService:Instance():CheckCardInArmy(mhero.id) then
                local building = BuildingService:Instance():GetBuilding(mhero.buildingId)
                self.troopsMax = DataHeroLevel[mhero.level].UnitAmount + building:GetCityPropertyByFacilityProperty(FacilityProperty.NumberTroops);
            else
                self.troopsMax = DataHeroLevel[mhero.level].UnitAmount

            end
            -- 兵力接口
            self.ExpMax = DataHeroLevel[mhero.level].ExperienceLevelUp;
        else
            self.troopsMax = DataHeroLevel[1].UnitAmount
            self.ExpMax = DataHeroLevel[1].ExperienceLevelUp;
            self._level.text = "LV.1"
        end

        -- 经验接口
        self.strengthMax = 100;
        self._heroSoldiersText.text = mhero.troop;
        self.forces.text = mhero.troop .. "/" .. self.troopsMax;
        if self.canShow == true then
            local strength = mhero.power:GetValue();
            if strength > self.strengthMax then
                strength = self.strengthMax
            end
            self.strength.text = math.floor(strength) .. "/" .. self.strengthMax;
            self.StrengthSlider.fillAmount = math.floor(mhero.power:GetValue()) / self.strengthMax
        else
            self.strength.text = "0/100"
            self.StrengthSlider.fillAmount = 0
        end

        self.exp.text = mhero.exp .. "/" .. self.ExpMax;
        self.ExpSlider.fillAmount = mhero.exp / self.ExpMax
        self.troopSlider.fillAmount = mhero.troop / self.troopsMax

        self:SetRedStar(self.heroInfo.Star, mhero.advancedTime, self._redstar)
        self:SetRedStar(self.heroInfo.Star, mhero.advancedTime, self._heroRedStarObj)
        -- 英雄进阶星级(红星)
        if mhero.point > 0 then
            self._heroAddPointSprite.gameObject:SetActive(true)
        else
            self._heroAddPointSprite.gameObject:SetActive(false)
        end
        self._heroLevelText.text = mhero.level;

        if mhero:GetSkill(2) == 0 then

            if mhero.level < 5 then
                self.skill1name.text = "武将LV5"
            else
                self.skill1name.text = "可学习"
            end
            self.skill1Level.text = ""
        else
            self.skill1name.text = DataSkill[self.data[1].allSkillSlotList[2]].SkillnameText;
            self.skill1Level.text = self.data[1].allSkillLevelList[2]
        end

        if mhero:GetSkill(3) == 0 then
            if mhero.isAwaken == false then
                if mhero.level > 19 and mhero:GetSkillLevel(1) > 9 then
                    self.awakeName.text = "可觉醒"
                else
                    self.awakeName.text = "未觉醒"
                end
                self.skill2sprite.sprite = GameResFactory.Instance():GetResSprite(self.CantAwakeImage);
            else
                self.awakeName.text = "可学习"
                self.skill2sprite.sprite = GameResFactory.Instance():GetResSprite(self.defultPic);
            end
            self.skillAwakeLevel.text = ""
        else
            self.skill2sprite.sprite = self:GetImage(DataSkill[self.data[1]:GetSkill(3)].Type)
            self.awakeName.text = DataSkill[self.data[1].allSkillSlotList[3]].SkillnameText;
            self.skillAwakeLevel.text = self.data[1].allSkillLevelList[3]
        end
    end


    if self.canShow == false then
        self.resetBtn.gameObject:SetActive(false)
        self.advannceBtn.gameObject:SetActive(false)
        self.pointBtn.gameObject:SetActive(false)
        self.leftImage.gameObject:SetActive(false);
        self.rightImage.gameObject:SetActive(false)
    end
    if self.canShow == true then
        self.resetBtn.gameObject:SetActive(true)
        self.advannceBtn.gameObject:SetActive(true)
        self.pointBtn.gameObject:SetActive(true)
        self.leftImage.gameObject:SetActive(true);
        self.rightImage.gameObject:SetActive(true)
        self:CanNotBeAdvance()
    end

    if self.data[1].advancedTime >= DataHero[self.data[1].tableID].Star then
        self.advannceBtn.gameObject:SetActive(false)
    end

    --- 配点

    -- --print(self.heroInfo.AttackBase)
    self.atk.text = self.heroInfo.AttackBase + data[1].level * self.heroInfo.AttackUpgrade - self.heroInfo.AttackUpgrade + data[1].attack
    self.atk1.text = self.heroInfo.AttackBase + data[1].level * self.heroInfo.AttackUpgrade - self.heroInfo.AttackUpgrade + data[1].attack
    self.atk2.text = data[1].attack;

    self.def.text = self.heroInfo.DefenseBase + data[1].level * self.heroInfo.DefenseUpgrade - self.heroInfo.DefenseUpgrade + data[1].def
    self.def1.text = self.heroInfo.DefenseBase + data[1].level * self.heroInfo.DefenseUpgrade - self.heroInfo.DefenseUpgrade + data[1].def
    self.def2.text = data[1].def;

    self.sty.text = self.heroInfo.SpiritBase + data[1].level * self.heroInfo.SpiritUpgrade - self.heroInfo.SpiritUpgrade + data[1].strategy
    self.sty1.text = self.heroInfo.SpiritBase + data[1].level * self.heroInfo.SpiritUpgrade - self.heroInfo.SpiritUpgrade + data[1].strategy
    self.sty2.text = data[1].strategy;

    self.spd.text = self.heroInfo.SpeedBase + data[1].level * self.heroInfo.SpeedUpgrade - self.heroInfo.SpeedUpgrade + data[1].speed
    self.spd1.text = self.heroInfo.SpeedBase + data[1].level * self.heroInfo.SpeedUpgrade - self.heroInfo.SpeedUpgrade + data[1].speed
    self.spd2.text = data[1].speed;


    -- 能否重置
    if self.data[1].advancedTime > 0 then

        self.resetBtn.gameObject:SetActive(true)
    else
        self.resetBtn.gameObject:SetActive(false)

    end
    -- 洗点
    if self.data[1].lastResetPointTime ~= 0 then
        self.cleanTime.text = ""
        self.cleanBtnText.text = "20玉"
        local showtime = self.data[1].lastResetPointTime + 7 * 24 * 1000 * 3600 - PlayerService:Instance():GetLocalTime();
        if showtime < 0 then
            self:resettime(self.data[1])
        else
            self:TimeDown(showtime, self.cleanTime, self.cleanTimer)
        end
    else
        self.cleanTime.text = "当前可进行免费洗点"
        self.cleanBtnText.text = "免费"
    end

    self.points.text = data[1].point;
    self.AddPoint.gameObject:SetActive(false);
    self.cleanUp.gameObject:SetActive(false)
    self.introPoint.gameObject:SetActive(false);
    self.CantAwake.gameObject:SetActive(false)


    -------------------在各个页面去隐藏两个按钮
    if UIService:Instance():GetOpenedUI(UIType.UIRecruitUI) or UIService:Instance():GetOpenedUI(UIType.ArmyFunctionUI) then
        self.leftImage.gameObject:SetActive(false);
        self.rightImage.gameObject:SetActive(false)
        -- print(HeroService:Instance():GetHeroById(self.data[1].id))
        if HeroService:Instance():GetHeroById(self.data[1].id) == nil then
            self.resetBtn.gameObject:SetActive(false)
            self.advannceBtn.gameObject:SetActive(false)
            self.pointBtn.gameObject:SetActive(false)
            self.leftImage.gameObject:SetActive(false);
            self.rightImage.gameObject:SetActive(false)
            self.data[2] = false
            self.canShow = false
        end
    end


    if UIService:Instance():GetOpenedUI(UIType.UIHeroCardPackage) then
        self.leftImage.gameObject:SetActive(true);
        self.rightImage.gameObject:SetActive(true)
    else
        self.leftImage.gameObject:SetActive(false);
        self.rightImage.gameObject:SetActive(false)
    end

    if PlayerService:Instance():CheckCardInArmy(self.data[1].id) then
        self.leftImage.gameObject:SetActive(false);
        self.rightImage.gameObject:SetActive(false)
    else
        self.leftImage.gameObject:SetActive(true);
        self.rightImage.gameObject:SetActive(true)
    end



    if UIService:Instance():GetOpenedUI(UIType.UIRecruitUI) then
        self.leftImage.gameObject:SetActive(false);
        self.rightImage.gameObject:SetActive(false)
    end


    if self:CanClick() == false then
        self.advannceBtn.gameObject:SetActive(false)
        self.leftImage.gameObject:SetActive(false);
        self.pointBtn.gameObject:SetActive(false)
        self.rightImage.gameObject:SetActive(false)
    end

    if self:CanSplite() == false then
        self.data[2] = false
    end


    if tonumber(self.points.text) > 0 then
        self.defplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add);
        self.atkplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add);
        self.styplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add);
        self.spdplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add);
    else
        self.defplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add1);
        self.atkplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add1);
        self.styplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add1);
        self.spdplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add1);
    end
    self:SplitePic()
    self.atksubtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub1);
    self.spdsubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub1);
    self.defsubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub1);
    self.stysubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub1);


    -- chonghizz

end

function UIHeroCardInfo:SplitePic(args)
    -- 打开可拆解界面
    if self.heroInfo.Star > 2 and self.heroInfo.ExtractSkillIDArray[1] ~= nil then
        self._splitBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(splitebright);
    else
        self._splitBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(splite);
    end

end


function UIHeroCardInfo:AddPointPic()
    if tonumber(self.atk2.text) > self.data[1].attack then
        self.atksubtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub);
        self.atk2.color = Color.green
        self.atk3.color = Color.green
    else
        self.atk3.color = Color.white
        self.atk2.color = Color.white
    end
    if tonumber(self.def2.text) > self.data[1].def then
        self.defsubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub);
        self.def2.color = Color.green
        self.def3.color = Color.green

    else
        self.def3.color = Color.white
        self.def2.color = Color.white
    end
    if tonumber(self.spd2.text) > self.data[1].speed then
        self.spdsubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub);
        self.spd2.color = Color.green
        self.spd3.color = Color.green
    else
        self.spd3.color = Color.white
        self.spd2.color = Color.white
    end
    if tonumber(self.sty2.text) > self.data[1].strategy then
        self.stysubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub);
        self.sty3.color = Color.green
        self.sty2.color = Color.green
    else
        self.sty3.color = Color.white
        self.sty2.color = Color.white
    end
    if tonumber(self.points.text) > 0 then
        self.defplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add);
        self.atkplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add);
        self.styplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add);
        self.spdplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add);
    else
        self.defplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add1);
        self.atkplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add1);
        self.styplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add1);
        self.spdplusBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(add1);
    end
end


-- 打开配点界面
function UIHeroCardInfo:OpenAddPoint()
    if self.addPointBoo then
        self.AddPoint.gameObject:SetActive(true);
        self.AddPoint.localPosition = GeneralBackdropImagePos
        self.GeneralBackdropImage.localPosition = AddPointPos
    else
        self.AddPoint.gameObject:SetActive(false)
        self.AddPoint.localPosition = AddPointPos
        self.GeneralBackdropImage.localPosition = GeneralBackdropImagePos
    end
end



function UIHeroCardInfo:OnClickconfirmclean()
    -- 洗点
    self.cleanUp.gameObject:SetActive(false)
    HeroService:Instance():SendResetPointMessage(self.data[1].id)

end

function UIHeroCardInfo:OnClickintroBtn()
    -- 节点介绍
    self.introPoint.gameObject:SetActive(true)

end




function UIHeroCardInfo:OnClickintroConfirmBtn()
    -- 关闭介绍

    -- --print("-- 关闭介绍")
    self.introPoint.gameObject:SetActive(false)

end

function UIHeroCardInfo:OnClickcancelclean()
    -- 取消洗点
    self.cleanUp.gameObject:SetActive(false)
end


-- 转换卡牌
function UIHeroCardInfo:OnClickleftImageBtn()
    local data = { self:GetBackCard(), self.canShow };
    UIService:Instance():GetUIClass(UIType.UIHeroCardInfo):OnShow(data)
end


function UIHeroCardInfo:OnClickrightImageBtn()
    local data = { self:GetNextCard(), self.canShow };
    UIService:Instance():GetUIClass(UIType.UIHeroCardInfo):OnShow(data)
end


-- 打开配点界面
function UIHeroCardInfo:OnClickapointBtn()
    self.AddPoint.gameObject:SetActive(true)
    local posImage = self.GeneralBackdropImage.localPosition;
    local posPointImage = self.AddPoint.localPosition;
    CommonService:Instance():Play("Audio/AddPointComplate")
    self.AddPoint.transform:DOLocalMove(posImage, MoveTime)
    self.GeneralBackdropImage.transform:DOLocalMove(posPointImage, MoveTime)

end

function UIHeroCardInfo:OnClickcleanBtn()

    if self.data[1].level < 15 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.LevelUnderfifteen)
        return
    end
    if self.data[1].attack == 0 and self.data[1].def == 0 and self.data[1].speed == 0 and self.data[1].strategy == 0 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoPointAdd)
        return
    end
    self.cleanUp.gameObject:SetActive(true)
    self.addPointBoo = true;

end

-- 属性提升特效
function UIHeroCardInfo:ShowPartilce()
    self._percentChangge.gameObject:SetActive(true);
    self._percentChangge.transform.localPosition = Vector3.zero;
    ChangeObj = self._percentChangge.gameObject

    local ltDescr = self._percentChangge.transform:DOLocalMove(ChangPosition, 1)
    ltDescr:OnComplete(self, self.ToChangeProgressOver)

end
function UIHeroCardInfo:ToChangeProgressOver()
    if ChangeObj then
        ChangeObj:SetActive(false);
    end
end



function UIHeroCardInfo:OnClickconfirmBtn()

    -- 完成配点
    if tonumber(self.points.text) ~= self.data[1].point then
        local atkPoint = tonumber(self.atk2.text) - self.data[1].attack;
        local defenCount = tonumber(self.def2.text) - self.data[1].def;
        local strageCount = tonumber(self.sty2.text) - self.data[1].strategy;
        local speedCount = tonumber(self.spd2.text) - self.data[1].speed;
        -- print("发送加点消系")
        HeroService:Instance():SendAddPointMessage(self.data[1].id, atkPoint, defenCount, strageCount, speedCount)
        self.addPointBoo = true;
        self:ShowPartilce()
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoPointAdd)
    end

end

-- 关闭配电界面

function UIHeroCardInfo:OnClickback1Btn()
    -- --print("guanbijiemian ")
    self.addPointBoo = false;
    local posImage = self.GeneralBackdropImage.localPosition;
    local posPointImage = self.AddPoint.localPosition;
    self.AddPoint.transform:DOLocalMove(posImage, MoveTime)
    self.GeneralBackdropImage.transform:DOLocalMove(posPointImage, MoveTime)
end

-- 攻击加点
function UIHeroCardInfo:OnClickatksubtn()

    if tonumber(self.atk2.text) - self.data[1].attack == 0 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoPointAddAtHere)
    end
    if tonumber(self.atk2.text) >= 1 and tonumber(self.atk1.text) > tonumber(self.atk.text) then
        self.atk1.text = tonumber(self.atk1.text) -1;
        self.atk2.text = tonumber(self.atk2.text) -1;
        self.points.text = tonumber(self.points.text) + 1;
    end
    if tonumber(self.atk2.text) - self.data[1].attack > 0 then
        self.atksubtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub);
    else
        self.atksubtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub1);
    end

    self:AddPointPic()
end

function UIHeroCardInfo:AddPointCue()
    if tonumber(self.points.text) == 0 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, 50)
    end
end

function UIHeroCardInfo:OnClickatkplusBtn()
    if tonumber(self.points.text) >= 1 then
        self.atk1.text = tonumber(self.atk1.text) + 1;
        self.atk2.text = tonumber(self.atk2.text) + 1;
        self.points.text = tonumber(self.points.text) -1;
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoPointCanAdd)
    end
    if tonumber(self.points.text) > 0 then
        self.atksubtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub);
    end
    self:AddPointPic()

end
-- 防御加点
function UIHeroCardInfo:OnClickdefsubBtn()

    if tonumber(self.def2.text) - self.data[1].def == 0 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoPointAddAtHere)
    end
    if tonumber(self.def2.text) >= 1 and tonumber(self.def1.text) > tonumber(self.def.text) then
        self.def1.text = tonumber(self.def1.text) -1;
        self.def2.text = tonumber(self.def2.text) -1;
        self.points.text = tonumber(self.points.text) + 1;
    end
    if tonumber(self.def2.text) - self.data[1].def > 0 then
        self.defsubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub);
    else
        self.defsubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub1);
    end

    self:AddPointPic()

end

function UIHeroCardInfo:OnClickdefplusBtn()
    if tonumber(self.points.text) >= 1 then
        self.def1.text = tonumber(self.def1.text) + 1;
        self.def2.text = tonumber(self.def2.text) + 1;
        self.points.text = tonumber(self.points.text) -1;
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoPointCanAdd)
    end
    if tonumber(self.points.text) > 0 then
        self.defsubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub);
    end
    self:AddPointPic()


end
-- 谋略加点
function UIHeroCardInfo:OnClickstysubBtn()

    if tonumber(self.sty2.text) - self.data[1].strategy == 0 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoPointAddAtHere)
    end

    if tonumber(self.sty2.text) >= 1 and tonumber(self.sty1.text) > tonumber(self.sty.text) then
        self.sty1.text = tonumber(self.sty1.text) -1;
        self.sty2.text = tonumber(self.sty2.text) -1;
        self.points.text = tonumber(self.points.text) + 1;
    end
    if tonumber(self.sty2.text) - self.data[1].strategy > 0 then
        self.stysubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub);
    else
        self.stysubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub1);
    end
    self:AddPointPic()

end

function UIHeroCardInfo:OnClickstyplusBtn()
    if tonumber(self.points.text) >= 1 then
        self.sty1.text = tonumber(self.sty1.text) + 1;
        self.sty2.text = tonumber(self.sty2.text) + 1;
        self.points.text = tonumber(self.points.text) -1;
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoPointCanAdd)
    end
    if tonumber(self.points.text) > 0 then
        self.stysubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub);
    end
    self:AddPointPic()

end
-- 速度加点
function UIHeroCardInfo:OnClickspdsubBtn()
    if tonumber(self.spd2.text) - self.data[1].speed == 0 then
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoPointAddAtHere)
    end
    if tonumber(self.spd2.text) >= 1 and tonumber(self.spd1.text) > tonumber(self.spd.text) then
        self.spd1.text = tonumber(self.spd1.text) -1;
        self.spd2.text = tonumber(self.spd2.text) -1;
        self.points.text = tonumber(self.points.text) + 1;
    end
    if tonumber(self.spd2.text) - self.data[1].speed > 0 then
        self.spdsubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub);
    else
        self.spdsubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub1);
    end
    self:AddPointPic()

end

function UIHeroCardInfo:OnClickspdplusBtn()
    if tonumber(self.points.text) >= 1 then
        self.spd1.text = tonumber(self.spd1.text) + 1;
        self.spd2.text = tonumber(self.spd2.text) + 1;
        self.points.text = tonumber(self.points.text) -1;
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.NoPointCanAdd)
    end
    if tonumber(self.points.text) > 0 then
        self.spdsubBtn.gameObject:GetComponent(typeof(UnityEngine.UI.Image)).sprite = GameResFactory.Instance():GetResSprite(sub);
    end
    self:AddPointPic()

end


-- 设置英雄红色星级
function UIHeroCardInfo:SetRedStar(mYellowStar, mRedStar, obj)
    local redTran = obj.transform;
    for i = 1, redTran.childCount do
        local tran = redTran:GetChild(i - 1);
        tran.gameObject:SetActive(false);
    end
    for i = 1, mRedStar do
        local tran = redTran:GetChild(i - 1);
        tran.gameObject:SetActive(true);
    end
end

function UIHeroCardInfo:OnClickBackBtn()
    UIService:Instance():HideUI(UIType.UIHeroCardInfo);
    if self:CanClick() then
        HeroService:Instance():SetAllCardsActive(true)
    end
end

function UIHeroCardInfo:OnClick_splitBtn()
    -- 打开可拆解界面
    if self.heroInfo.Star > 2 and self.heroInfo.ExtractSkillIDArray[1] ~= nil then
        UIService:Instance():ShowUI(UIType.UIHeroSpliteSkill, self.data);
        UIService:Instance():HideUI(UIType.UIHeroCardInfo)
        UIService:Instance():HideUI(UIType.UIHeroSpliteHero)
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.CantSpliteTheCard)
    end
end

function UIHeroCardInfo:OnClickresetBtn()
    self.ResetUI.gameObject:SetActive(true)
end

function UIHeroCardInfo:OnClickawakeBtn()
    local armyinfo = PlayerService:Instance():GetArmyInfoByCardId(self.cardId)
    if self.canShow then
        local mhero = self.data[1]
        if self.data[1]:GetSkill(3) == 0 then
            if mhero.level > 19 and mhero.allSkillLevelList[1] > 9 then
                if armyinfo ~= nil then
                    if armyinfo:GetArmyState() ~= ArmyState.None then
                        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HeroAbsenceCity);
                        return
                    elseif mhero.isAwaken then
                        if self:CanClick() == false then
                            UIService:Instance():ShowUI(UIType.UICueMessageBox, 2404)
                            return
                        end
                        SkillService:Instance():HeroLearnSkill(self.data[1].id, 3)
                    else
                        UIService:Instance():HideUI(UIType.UIHeroCardInfo)
                        UIService:Instance():ShowUI(UIType.UIHeroAwake, self.data)
                    end
                elseif mhero.isAwaken then
                    if self:CanClick() == false then
                        UIService:Instance():ShowUI(UIType.UICueMessageBox, 2404)
                        return
                    end
                    SkillService:Instance():HeroLearnSkill(self.data[1].id, 3)
                else
                    if self:CanClick() == false then
                        UIService:Instance():ShowUI(UIType.UICueMessageBox, 2404)
                        return
                    end
                    UIService:Instance():HideUI(UIType.UIHeroCardInfo)
                    UIService:Instance():ShowUI(UIType.UIHeroAwake, self.data)
                end
            else
                self.CantAwake.gameObject:SetActive(true)
            end
        else
            SkillService:Instance():HeroStrengthenSkill(self.data[1].id, self.data[1].allSkillSlotList[3], true)
        end
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.CantOpenInHandBook)
    end
end

function UIHeroCardInfo:OnClickCantAwakeBtn()
    self.CantAwake.gameObject:SetActive(false)
end


function UIHeroCardInfo:OnClickskill1Btn()
    local armyinfo = PlayerService:Instance():GetArmyInfoByCardId(self.cardId)
    if self.canShow then
        if self.data[1]:GetSkill(2) == 0 then
            if self.data[1].level > 4 then
                if armyinfo ~= nil then
                    if armyinfo:GetArmyState() ~= ArmyState.None then
                        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.HeroAbsenceCity);
                        return
                    else
                        if self:CanClick() == false then
                            UIService:Instance():ShowUI(UIType.UICueMessageBox, 2404)
                            return
                        end
                        SkillService:Instance():HeroLearnSkill(self.data[1].id, 2)
                    end
                else
                    if self:CanClick() == false then
                        UIService:Instance():ShowUI(UIType.UICueMessageBox, 2404)
                        return
                    end
                    SkillService:Instance():HeroLearnSkill(self.data[1].id, 2)
                end
            else

                UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.CantLearnSkill)
            end
        else
            SkillService:Instance():HeroStrengthenSkill(self.data[1].id, self.data[1].allSkillSlotList[2], true)
        end
    else
        UIService:Instance():ShowUI(UIType.UICueMessageBox, UICueMessageType.CantOpenInHandBook)
    end
end


function UIHeroCardInfo:OnClick_skillBtn()
    local skillid = DataHero[self.data[1].tableID].SkillOriginalID;
    SkillService:Instance():HeroStrengthenSkill(self.data[1].id, skillid, self.canShow)

end

function UIHeroCardInfo:OnClickadvannceBtn()
    if UIService:Instance():GetOpenedUI(UIType.UIRecruitUI) and UIService:Instance():GetOpenedUI(UIType.UIHeroAdvance) then
        UIService:Instance():HideUI(UIType.UIRecruitUI)
        UIService:Instance():ShowUI(UIType.UIGameMainView)
    end
    UIService:Instance():HideUI(UIType.UIHeroCardInfo)
    UIService:Instance():HideUI(UIType.UITactisTransExp)
    UIService:Instance():HideUI(UIType.UIHeroSpliteHero)
    UIService:Instance():ShowUI(UIType.UIHeroAdvance, self.data)
end



function UIHeroCardInfo:SetSoldierType(mSoldierType)

    local childeIndex = -1;
    if mSoldierType == ArmyType.Qi then
        childeIndex = 0;
    elseif mSoldierType == ArmyType.Gong then
        childeIndex = 1;
    elseif mSoldierType == ArmyType.Bu then
        childeIndex = 2;

    else
        return;
    end

    self:ShowChild(childeIndex, self._heroSoldierType.transform);
end

function UIHeroCardInfo:SetSoldierTypeSide(mSoldierType)

    local childeIndex = -1;
    if mSoldierType == ArmyType.Qi then
        childeIndex = 0;
    elseif mSoldierType == ArmyType.Gong then
        childeIndex = 1;
    elseif mSoldierType == ArmyType.Bu then
        childeIndex = 2;

    else
        -- --print("Can not find SoldierType");
        return;
    end

    self:ShowChild(childeIndex, self._type.transform);
end


function UIHeroCardInfo:HideBtn()

    self.resetBtn.gameObject:SetActive(false)
    self.advannceBtn.gameObject:SetActive(false)
    self.pointBtn.gameObject:SetActive(false)
    self.leftImage.gameObject:SetActive(false);
    self.rightImage.gameObject:SetActive(false)
    self.panel.gameObject:SetActive(true)
end



-- 设置英雄星级
function UIHeroCardInfo:SetStar(mYellowStar, mRedStar)
    self:SetYellowStar(mYellowStar);
    self:SetRedStar(mYellowStar, mRedStar);
end

-- 设置英雄黄色星级
function UIHeroCardInfo:SetYellowStar(mstar, obj)

    local yellowTran = obj.transform;

    if yellowTran == nil then
        error("yellowStar is nil");
        return;
    end

    for i = 1, yellowTran.childCount do
        local tran = yellowTran:GetChild(i - 1);
        if (i - 1) < mstar then
            tran.gameObject:SetActive(true);
        else
            tran.gameObject:SetActive(false);
        end

    end
end







-- 设置子物体下的某一个显示
function UIHeroCardInfo:ShowChild(mChildIndex, mTransform)

    if mTransform == nil or mChildIndex < 0 then
        -- --print("transform is nil or childindex<0");
        return;
    end

    local tranParent = mTransform;
    tranParent.gameObject:SetActive(true);


    for i = 1, tranParent.childCount do
        local tran = tranParent:GetChild(i - 1);
        if (i - 1) == mChildIndex then
            tran.gameObject:SetActive(true);
        else
            tran.gameObject:SetActive(false);
        end

    end
end


-- 设置阵营
function UIHeroCardInfo:SetCamp(mCamp)

    local tranParent = self._campParent.transform;
    tranParent.gameObject:SetActive(true);

    for i = 1, tranParent.childCount do
        if i == mCamp then
            tranParent:GetChild(i - 1).gameObject:SetActive(true);
        else
            tranParent:GetChild(i - 1).gameObject:SetActive(false);
        end

    end

end

-- 设置阵营
function UIHeroCardInfo:SetInfoCamp(mCamp)

    local tranParent = self.camp.transform;
    tranParent.gameObject:SetActive(true);
    for i = 1, tranParent.childCount do
        if i == mCamp then
            tranParent:GetChild(i - 1).gameObject:SetActive(true);
        else
            tranParent:GetChild(i - 1).gameObject:SetActive(false);
        end

    end

end


function UIHeroCardInfo:CanNotBeAdvance()

    local size = HeroService:Instance():GetOwnHeroCount();
    local num = 0
    local herolist = List:new();
    for i = 1, size do
        if HeroService:Instance():GetOwnHeroes(i).tableID == self.data[1].tableID then
            num = num + 1;
        end
    end
    if num > 1 then
        self.advanceImage.gameObject:SetActive(true)
    else
        self.advanceImage.gameObject:SetActive(false)
    end
end


function UIHeroCardInfo:GetNextCard()
    local size = HeroService:Instance():GetOwnHeroCount();
    for i = 1, size do
        if self.data[1].id == HeroService:Instance():GetSortList(i):Get(i).id then
            if i + 1 > size then
                return HeroService:Instance():GetSortList():Get(1)
            end
            return HeroService:Instance():GetSortList():Get(i + 1)
        end
    end
end

function UIHeroCardInfo:GetBackCard()

    local size = HeroService:Instance():GetOwnHeroCount();
    for i = 1, size do
        if self.data[1].id == HeroService:Instance():GetSortList():Get(i).id then

            if i - 1 < 1 then
                return HeroService:Instance():GetSortList():Get(size)
            end
            return HeroService:Instance():GetSortList():Get(i - 1)
        end
    end
end
----播放特效

-- 设置图片
function UIHeroCardInfo:GetImage(num)

    if num == nil then
        return GameResFactory.Instance():GetResSprite(self.defultPic);
    end

    if num == 3 then

        return GameResFactory.Instance():GetResSprite(self.commandPic);
    end
    if num == 4 then

        return GameResFactory.Instance():GetResSprite(self.attackPic);
    end
    if num == 1 then

        return GameResFactory.Instance():GetResSprite(self.activePic);
    end

    if num == 2 then

        return GameResFactory.Instance():GetResSprite(self.passivePic);
    end
end


-- endFunction 倒计时结束回调
function UIHeroCardInfo:TimeDown(showTime, showText, timer)
    local cdTime = math.floor(showTime / 1000)
    timer = Timer.New( function()
        cdTime = cdTime > 0 and cdTime - 1 or 0;
        showText.text = self:GetDateString(cdTime);
        if cdTime == 0 then
            if timer ~= nil then
                timer:Stop();
                timer = nil;
                if endFunction ~= nil then
                    endFunction();
                end
                return;
            end
        end
    end , 1, -1, false);
    timer:Start();
    return timer;
end

-- 通用时间转字符串 单位：秒  转换格式：  02:20:34
function UIHeroCardInfo:GetDateString(costTime)
    local timeString = nil;
    local day = CommonService:Instance():FormatToDays(costTime)
    timeString = day .. "天后可进行免费洗点"
    return timeString;
end

function UIHeroCardInfo:resettime(herocard)

    self.cleanTime.text = "可以进行免费洗点"
    self.cleanBtnText.text = "免费"
    herocard:SetLastResetTime(0)

end

-- 进阶特效
function UIHeroCardInfo:AdvanceSucessful()
    EffectsService:Instance():AddEffect(self._heroIconSprite.gameObject, EffectsType.GrowupEffect, 1)
end
-- 觉醒特效
function UIHeroCardInfo:AwakeSucessful()
    EffectsService:Instance():AddEffect(self._heroIconSprite.gameObject, EffectsType.AwakenEffect, 1, function()
        self:AwakeIcon()
    end )
    EffectsService:Instance():AddEffect(self.awakeBtn.gameObject, EffectsType.UnlockEffect, 1)
end

-- 觉醒图标
function UIHeroCardInfo:AwakeIcon()
    EffectsService:Instance():AddEffect(self.awakeImage.gameObject, EffectsType.AwakeniconEffect, 1, function()
        self.awakeImage.gameObject:SetActive(true)
    end )
end


function UIHeroCardInfo:CanClick()

    local openExp = UIService:Instance():GetOpenedUI(UIType.UITactisTransExp)
    local openSplit = UIService:Instance():GetOpenedUI(UIType.UIHeroSpliteHero)
    local openReseach = UIService:Instance():GetOpenedUI(UIType.UITactisResearch)
    local openAdvance = UIService:Instance():GetOpenedUI(UIType.UIHeroAdvance)
    local openAwake = UIService:Instance():GetOpenedUI(UIType.UIHeroAwake)
    if openExp or openSplit or openReseach or openAdvance or openAwake then
        return false
    end
    return true
end


function UIHeroCardInfo:CanSplite()
    local openExp = UIService:Instance():GetOpenedUI(UIType.UITactisTransExp)
    local openReseach = UIService:Instance():GetOpenedUI(UIType.UITactisResearch)
    local openAdvance = UIService:Instance():GetOpenedUI(UIType.UIHeroAdvance)
    local openAwake = UIService:Instance():GetOpenedUI(UIType.UIHeroAwake)
    if openExp or openReseach or openAdvance or openAwake then
        return false
    end
    return true
end




return UIHeroCardInfo

-- endregion
