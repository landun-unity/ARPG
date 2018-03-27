

--[[
   Name:  uimanager类
   anchor:Dr
   Data:16/9/7
   注意：如果uibese文件位置变了，需要修改本类LoadPerfab函数
--]]


local GameManage=require("FrameWork/Game/GameManage");
--加载表
local UIConfigTable=require("Game/table/model/DataUIConfig");
 local UIBase= require("UI/UIGameBase/UIBase");
local List=require("common/List");
local UIManager=class("UIManager",GameManage);
--local UILevelInfo=require("UI/UILevelInfo");


-- 构造函数
function UIManager:ctor()
    -- body
    print("UIManager:ctor");	
	UIManager.super.ctor(self);
	self._allUIObject={};--所有的UI
    --self._allLevelObject=List:new();
    self._allLevelObject={};--所有的层级table
    self._allGameObject={};--所有的gameobject
    self._instance=nil;
      --挂层级的父物体
        local ui_layer_go = UGameObject.Find("Canvas");
    self._totalParentObj = ui_layer_go.transform;


end

-- 单例
function UIManager:Instance()
    -- body
    if self._instance == nil then
        -- body
        self._instance = UIManager.new();
    end

    return self._instance;
end

--显示ui
function UIManager:ShowUI(_uiType,parem)
	

 local mUIBase=nil;
       if UIConfigTable[_uiType] then
     mUIBase=UIConfigTable[_uiType];	
    end

    local parentObj= self:AddUIPanel( _uiType, mUIBase.Level, mUIBase.Depth);
    --print(parentObj.gameObject.name);
    --没有就创建
	if self:ExitUI(_uiType)==false then

    self:CreateUI(_uiType,mUIBase.ResourcePath,mUIBase.ClassName, parentObj);
	
	end

    self:HideMutexUI(_uiType,mUIBase.Mutex);	
	local uiClass=self:GetUIClass(_uiType);

    uiClass:SetVisible(true,parem);

end



--隐藏互斥界面
function UIManager:HideMutexUI(_uiType,_mutexList)

if _mutexList==nil then
  print("UIMutexLIst is nil")
end

	for k,v in pairs(_mutexList) do
    local mUIType=v;
		local uiClass=self:GetUIClass(mUIType);
        if uiClass then
    uiClass:SetVisible(false,parem);
        end

	end
		
end

--获取到lua类
function UIManager:GetUIClass(_uiType)

    if self._allUIObject[_uiType] then
	 return  self._allUIObject[_uiType];
    end
    return nil;
end


--注意，如果表头不是为classname要修改此处
function UIManager:CreateUI(_uiType,_resoucePath,_className,_parentObj)
       
        --print("uitype:".._uiType);	
    local path=  _resoucePath;

 local uiBase= self:LoadPerfabFile(path, _className,_parentObj);
 if uiBase==nil then
	print("uiBase is nil");
 end

    if self._allUIObject[_uiType]==nil then
	self._allUIObject[_uiType]=uiBase;
    end
 	
	end
	


--注意：如果uibese文件位置变了，需要修改
--加载预制并初始化类
function UIManager:LoadPerfabFile(_perfabPath,_calsName,_parentObj)
	
    -- 找到界面的类
	local uiBase = require("UI/UIModel/".._calsName).new();
    --print("_parentObj:".._parentObj.gameObject.name);
	--加载预制
     GameResFactory.Instance():GetUIPrefab(_perfabPath,_parentObj.transform,uiBase,function (go)

	uiBase:Init();

end);


	if uiBase == nil then
		--todo
        print("uibase is nil");
		return;
    end

	return uiBase;   
	
end




--增加层级和物体
function UIManager:AddUIPanel( nUIType,  nLevel,  nDepth)
  
         local levelObj=self:GetLevelObject(nLevel);
         if levelObj==nil then
          levelObj=self:CreateLevelObj(nLevel);
    end

              --print("levelObj:"..levelObj.gameObject.name);

    if levelObj== nil then
    print("LevelObj is nil");
    end

      local depthObj= self:GetDepth(levelObj.gameObject,nDepth);
      if depthObj ==nill then
      depthObj= self: CreateDepthObj(levelObj.gameObject,nDepth);
        else
        print("depthObj is not nil");
       
         end
                       --print("depthObj:"..depthObj.gameObject.name);
--                       print(nUIType);
--         if self._allGameObject[nUIType]==nil then
--         self._allGameObject[nUIType]=depthObj;
--         end

          if depthObj ==nill then
          print("depthObj is nil");
          end
         -- print("depthObj:"..depthObj.name);
          return  depthObj;--self._allGameObject[nUIType];

--    if self._allUIObject[_uiType]==nil then
--	self._allUIObject[_uiType]=_uiObject;
--	end
    
    --层级
end


--获取深度
function UIManager:GetDepth(_parentObj,_depth)
  --print(_depth);
  --print("ChildCount:".._parentObj.gameObject.transform.childCount);
if _parentObj.gameObject.transform.childCount-1 <_depth or  _parentObj.gameObject.transform:GetChild(_depth)==nil then
   return nil;
end

 local depthObj=  _parentObj.gameObject.transform:GetChild(_depth);
 return depthObj;
end

--创建深度物体
function UIManager:CreateDepthObj(_parentObj,_depth)
--print(_parentObj.gameObject.name);
    if _depth>0 and self:GetDepth(_parentObj,_depth-1)==nil  then
   self:CreateDepthObj(_parentObj,_depth-1);
   end

  local obj=  UGameObject("UIDepth".._depth);
  obj.transform:SetParent(_parentObj.gameObject.transform);
  obj.transform.localPosition=Vector3.zero;


  return obj;
end

--创建层级物体
function UIManager:CreateLevelObj(_level)
    if _level>0 and self:GetLevelObject(_level-1)==nil  then
   self:CreateLevelObj(_level-1);
   end

      local camObj= self._totalParentObj;
      --print("camObj:"..camObj);
  local obj=  UGameObject("UIlevel".._level);
  obj.transform:SetParent(camObj.transform);
  obj.transform.localPosition=Vector3.zero;


   if self._allLevelObject[_level] ==nil then
   self._allLevelObject[_level]=obj;
   end

--   local uiLevel=UILevelInfo.new();


return obj;



end


--获取层级
function UIManager:GetLevelObject(nLevel)

  if self._allLevelObject[nLevel] then

   return self._allLevelObject[nLevel];
  end

  return nil;

end



--是否存在
function UIManager:ExitUI(_uiType)
     if self._allUIObject[_uiType]==nil then
	 return false;
	end	
	return true;	
end


--隐藏UI
function UIManager:HideUI(_uiType,_parem)

	local uiClass=self:GetUIClass(_uiType);
    if uiClass then
    uiClass:SetVisible(false,parem);
    end
end

return UIManager;



