--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

-- 新手引导ui类型

GuideUiType =
{
	-- 全屏点击进入下一步
	ClickAllScreenToNext = 1,

    -- 全屏不能点击等待指定条件再回调下一步
    WaitToNext = 2,

    -- 操作指定区域进入下一步
    OperateOneAreaToNext = 3,
}

return GuideUiType;

--endregion
