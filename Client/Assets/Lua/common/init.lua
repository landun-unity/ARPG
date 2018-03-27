--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

-- 函数处理
function handler(obj, method )
    return function ( ... ) method( obj, ... ) end
end

require "common/class"
require("common/stack")
require("common/functions")
require("common/List")
require("common/Queue")
-- require "common/simple_state_machine"