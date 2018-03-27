-- 操作类型

OperatorType = 
{
    -- 空状态
    Empty = 0,

    -- 点击状态
    Click = 1, 

    -- 移动状态 
    Move = 2,

    -- 放大
    ZoomOut = 3,  

    -- 开始
    Begin = 4, 

    -- 取消点击
    CancleClick = 5, 

    -- 扩建
    Extension = 6, 

    -- 扩建点击
    ExtensionClick = 7, 

    -- 点击出设施
    ClickBuilding = 8, 

    -- 结束移动
    EndMove = 9, 
}

return OperatorType;