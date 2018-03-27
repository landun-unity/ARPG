--Anchor:Dr
--Date: 16/9/13
--英雄数据类

local Hero=class("Hero");

function Hero:ctor()

    Hero.super.ctor(self);
    --英雄id
    self._heroId=0;
    --英雄名字
    self._heroName="";
    --英雄等级
    self._heroLevel=0;
    --英雄cost
    self._heroCost=0.0;
    --英雄兵种
    self._heroType="";
    --英雄攻击距离
    self._heroAttackDis=0;
    --英雄经验
    self._heroExperience=0;
    --英雄兵数
    self._heroSoldiers=0;
    --英雄所属城市
    self._heroBelongCity="";
    --英雄所属大阵营(如:魏/蜀/吴)
    self._heroCamp="";
    --英雄是否在部队中
    self._heroIsInArmy=false;
    --英雄星级
    self._heroYellowStar=0;
    --英雄进阶星级(红星)
    self._heroRedStar=0;
    --英雄是否觉醒
    self._heroIsAwake=false;
    --英雄是否能加点属性
    self._heroIsAddPoint=false;
    

end

--endregion
