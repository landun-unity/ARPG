--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

-- 新手保护期阶段

NewerPeriodType =
{
    None = 0,

    -- 新手保护期开始
    StartNewerPeriod = 1,

    -- 名望2500 可屯田
    OpenMitaFunc = 2,

    -- 名望4000 可练兵
    OpenTrainFunc = 3,

    -- 名望5000 可驻守
    OpenGarrisonFunc = 4,

    -- 新手保护期结束
    NewerPeriodEnd = 5,

}

return NewerPeriodType;

--endregion
