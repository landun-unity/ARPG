using System;
using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine.EventSystems;

public class LuaBehaviour : MonoBehaviour
{
    private LuaState mLuaState = null;
    private LuaTable mLuaTable = null;
    /// <summary>
    /// 按钮点击字典
    /// </summary>
    private Dictionary<string, LuaFunction> mButtonCallbacks = new Dictionary<string, LuaFunction>();
    /// <summary>
    /// 图片点击字典
    /// </summary>
    private Dictionary<GameObject, LuaFunction> mOnClickCallbacks = new Dictionary<GameObject, LuaFunction>();
    //private Dictionary<string, LuaFunction> mOnClickCallbacks = new Dictionary<string , LuaFunction>();
    /// <summary>
    /// 物体拖拽
    /// </summary>
    //private Dictionary<string, LuaFunction> mOnDragCallbacks = new Dictionary<string, LuaFunction>();
    private Dictionary<GameObject, LuaFunction> mOnDragCallbacks = new Dictionary<GameObject, LuaFunction>();

    /// <summary>
    /// 物体按下
    /// </summary>
    //private Dictionary<string, LuaFunction> mOnUpCallbacks = new Dictionary<string, LuaFunction>();
    private Dictionary<GameObject, LuaFunction> mOnUpCallbacks = new Dictionary<GameObject, LuaFunction>();

    /// <summary>
    /// 物体松开
    /// </summary>
    //private Dictionary<string, LuaFunction> mOnDownCallbacks = new Dictionary<string, LuaFunction>();
    private Dictionary<GameObject, LuaFunction> mOnDownCallbacks = new Dictionary<GameObject, LuaFunction>();

    /// <summary>
    /// ScrollRect onValueChanged
    /// </summary>
    private Dictionary<GameObject, LuaFunction> mOnValueChangeCallbacks = new Dictionary<GameObject, LuaFunction>();


    /// <summary>
    /// Scrollbar onValueChanged
    /// </summary>
    private Dictionary<GameObject, LuaFunction> mOnScrollbarChangeCallbacks = new Dictionary<GameObject, LuaFunction>();

    /// <summary>
    /// Slider onValueChanged
    /// </summary>
    private Dictionary<GameObject, LuaFunction> mOnSliderChangeCallbacks = new Dictionary<GameObject, LuaFunction>();

    /// <summary>
    /// Toggle onValueChanged
    /// </summary>
    private Dictionary<GameObject, LuaFunction> mOnToggleChangeCallbacks = new Dictionary<GameObject, LuaFunction>();

    /// <summary>
    /// Toggle onValueChanged
    /// </summary>
    private Dictionary<GameObject, LuaFunction> mOnInputFieldChangeCallbacks = new Dictionary<GameObject, LuaFunction>();

    /// <summary>
    /// Toggle onValueChanged
    /// </summary>
    private Dictionary<GameObject, LuaFunction> mOnInputFieldOnEndEdit = new Dictionary<GameObject, LuaFunction>();


    private LuaFunction mFixedUpdateFunc = null;
    private LuaFunction mUpdateFunc = null;
    private LuaFunction mLateUpdateFunc = null;

    private LuaFunction mOnEnableFunc = null;
    private LuaFunction mOnDisableFunc = null;

    private bool mUsingOnEnable = false;
    public bool UsingOnEnable
    {
        get
        {
            return mUsingOnEnable;
        }
        set
        {
            mUsingOnEnable = value;
        }
    }

    private bool mUsingOnDisable = false;
    public bool UsingOnDisable
    {
        get
        {
            return mUsingOnDisable;
        }
        set
        {
            mUsingOnDisable = value;
        }
    }

    private bool mIsStarted = false;

    private void SafeRelease(ref LuaFunction func)
    {
        if (func != null)
        {
            func.Dispose();
            func = null;
        }
    }

    private void SafeRelease(ref LuaTable table)
    {
        if (table != null)
        {
            table.Dispose();
            table = null;
        }
    }

    private bool CheckValid()
    {
        if (mLuaState == null) return false;
        if (mLuaTable == null) return false;
        return true;
    }

    public void Init(LuaTable tb)
    {
        mLuaState = SimpleLuaClient.GetMainState();
        if (mLuaState == null) return;

        if (tb == null)
        {
            mLuaTable = mLuaState.GetTable(name);
        }
        else
        {
            mLuaTable = tb;
        }
        if (mLuaTable == null)
        {
            Debug.LogWarning("mLuaTable is null:" + name);
            return;
        }
        mLuaTable["gameObject"] = gameObject;
        mLuaTable["transform"] = transform;
        mLuaTable["lua_behaviour"] = this;

        LuaFunction awakeFunc = mLuaTable.GetLuaFunction("Awake") as LuaFunction;
        if (awakeFunc != null)
        {
            awakeFunc.BeginPCall();
            awakeFunc.Push(mLuaTable);
            awakeFunc.PCall();
            awakeFunc.EndPCall();

            awakeFunc.Dispose();
            awakeFunc = null;
        }

        mUpdateFunc = mLuaTable.GetLuaFunction("Update") as LuaFunction;
        mFixedUpdateFunc = mLuaTable.GetLuaFunction("FixedUpdate") as LuaFunction;
        mLateUpdateFunc = mLuaTable.GetLuaFunction("LateUpdate") as LuaFunction;
    }

    private void Start()
    {
        if (!CheckValid()) return;

        LuaFunction startFunc = mLuaTable.GetLuaFunction("Start") as LuaFunction;
        if (startFunc != null)
        {
            startFunc.BeginPCall();
            startFunc.Push(mLuaTable);
            startFunc.PCall();
            startFunc.EndPCall();

            startFunc.Dispose();
            startFunc = null;
        }

        AddUpdate();
        mIsStarted = true;
    }

    private void AddUpdate()
    {
        if (!CheckValid()) return;

        LuaLooper luaLooper = SimpleLuaClient.Instance.GetLooper();
        if (luaLooper == null) return;

        if (mUpdateFunc != null)
        {
            luaLooper.UpdateEvent.Add(mUpdateFunc, mLuaTable);
        }

        if (mLateUpdateFunc != null)
        {
            luaLooper.LateUpdateEvent.Add(mLateUpdateFunc, mLuaTable);
        }

        if (mFixedUpdateFunc != null)
        {
            luaLooper.FixedUpdateEvent.Add(mFixedUpdateFunc, mLuaTable);
        }
    }

    private void RemoveUpdate()
    {
        if (!CheckValid()) return;

        LuaLooper luaLooper = SimpleLuaClient.Instance.GetLooper();
        if (luaLooper == null) return;

        if (mUpdateFunc != null)
        {
            luaLooper.UpdateEvent.Remove(mUpdateFunc, mLuaTable);
        }
        if (mLateUpdateFunc != null)
        {
            luaLooper.LateUpdateEvent.Remove(mLateUpdateFunc, mLuaTable);
        }
        if (mFixedUpdateFunc != null)
        {
            luaLooper.FixedUpdateEvent.Remove(mFixedUpdateFunc, mLuaTable);
        }
    }

    private void OnEnable()
    {
        if (UsingOnEnable)
        {
            if (!CheckValid()) return;

            if (mOnEnableFunc == null)
            {
                mOnEnableFunc = mLuaTable.GetLuaFunction("OnEnable") as LuaFunction;
            }
            if (mOnEnableFunc != null)
            {
                mOnEnableFunc.BeginPCall();
                mOnEnableFunc.PCall();
                mOnEnableFunc.EndPCall();
            }
        }

        if (mIsStarted)
        {
            AddUpdate();
        }
    }

    private void OnDisable()
    {
        if (UsingOnDisable)
        {
            if (!CheckValid()) return;

            if (mOnDisableFunc == null)
            {
                mOnDisableFunc = mLuaTable.GetLuaFunction("OnDisable") as LuaFunction;
            }
            if (mOnDisableFunc != null)
            {
                mOnDisableFunc.BeginPCall();
                mOnDisableFunc.PCall();
                mOnDisableFunc.EndPCall();
            }
        }

        RemoveUpdate();
    }

    /// <summary>
    /// 按钮点击(依赖button组件)
    /// </summary>
    /// <param name="go"></param>
    /// <param name="luafunc"></param>
    public void AddClick(GameObject go, LuaFunction luafunc)
    {
        if (!CheckValid()) return;
        if (go == null || luafunc == null) return;
        if (!mButtonCallbacks.ContainsKey(go.name))
        {
            mButtonCallbacks.Add(go.name, luafunc);
           // UITriggerListener listener = go.GetComponent<UITriggerListener>();
           // if (listener == null)
           //listener=  go.AddComponent<UITriggerListener>();
            go.GetComponent<Button>().onClick.AddListener(
                delegate()
                {
                    luafunc.BeginPCall();
                    luafunc.Push(go);
                    luafunc.PCall();
                    luafunc.EndPCall();
                    Globals.Instance.SetCurrClickGo(go);
                }
            );
        }
    }

    
    public void AddOnValueChanged(GameObject go, LuaFunction luafunc)
    {
        if (!CheckValid()) return;
        if (go == null || luafunc == null) return;
        if (!mOnValueChangeCallbacks.ContainsKey(go))
        {
            mOnValueChangeCallbacks.Add(go, luafunc);
            // UITriggerListener listener = go.GetComponent<UITriggerListener>();
            // if (listener == null)
            //listener=  go.AddComponent<UITriggerListener>();
            //Debug.LogError("AddOnValueChanged");
            go.GetComponent<ScrollRect>().onValueChanged.AddListener(
                delegate(Vector2 vector2)
                {
                    luafunc.BeginPCall();
                    luafunc.Push(go);
                    luafunc.Push(vector2);
                    luafunc.PCall();
                    luafunc.EndPCall();
                }
            );
        }
    }

    public void AddSliderOnValueChanged(GameObject go, LuaFunction luafunc)
    {
        if (!CheckValid()) return;
        if (go == null || luafunc == null) return;
        if (!mOnSliderChangeCallbacks.ContainsKey(go))
        {
            mOnSliderChangeCallbacks.Add(go, luafunc);
            // UITriggerListener listener = go.GetComponent<UITriggerListener>();
            // if (listener == null)
            //listener=  go.AddComponent<UITriggerListener>();
            //Debug.LogError("AddOnValueChanged");
            go.GetComponent<Slider>().onValueChanged.AddListener(
                delegate(float mValue)
                {
                    luafunc.BeginPCall();
                    luafunc.Push(go);
                    luafunc.Push(mValue);
                    luafunc.PCall();
                    luafunc.EndPCall();
                }
            );
        }
    }

    public void AddToggleOnValueChanged(GameObject go, LuaFunction luafunc)
    {
        if (!CheckValid()) return;
        if (go == null || luafunc == null) return;
        if (!mOnToggleChangeCallbacks.ContainsKey(go))
        {
            mOnToggleChangeCallbacks.Add(go, luafunc);
            // UITriggerListener listener = go.GetComponent<UITriggerListener>();
            // if (listener == null)
            //listener=  go.AddComponent<UITriggerListener>();
            //Debug.LogError("AddOnValueChanged");
            go.GetComponent<Toggle>().onValueChanged.AddListener(
                delegate(bool shut)
                {
                    luafunc.BeginPCall();
                    luafunc.Push(go);
                    luafunc.Push(shut);
                    luafunc.PCall();
                    luafunc.EndPCall();
                }
            );
        }
    }

    public void AddInputFieldOnValueChanged(GameObject go, LuaFunction luafunc)
    {
        if (!CheckValid()) return;
        if (go == null || luafunc == null) return;
        if (!mOnInputFieldChangeCallbacks.ContainsKey(go))
        {
            mOnInputFieldChangeCallbacks.Add(go, luafunc);
            // UITriggerListener listener = go.GetComponent<UITriggerListener>();
            // if (listener == null)
            //listener=  go.AddComponent<UITriggerListener>();
            //Debug.LogError("AddOnValueChanged");
            go.GetComponent<InputField>().onValueChanged.AddListener(
                delegate(string value)
                {
                    luafunc.BeginPCall();
                    luafunc.Push(go);
                    luafunc.Push(value);
                    luafunc.PCall();
                    luafunc.EndPCall();
                }
            );
        }
    }

    public void AddInputFieldOnEndEdit(GameObject go, LuaFunction luafunc)
    {
        if (!CheckValid()) return;
        if (go == null || luafunc == null) return;
        if (!mOnInputFieldOnEndEdit.ContainsKey(go))
        {
            mOnInputFieldOnEndEdit.Add(go, luafunc);
            // UITriggerListener listener = go.GetComponent<UITriggerListener>();
            // if (listener == null)
            //listener=  go.AddComponent<UITriggerListener>();
            //Debug.LogError("AddOnValueChanged");
            go.GetComponent<InputField>().onEndEdit.AddListener(
                delegate(string value)
                {
                    luafunc.BeginPCall();
                    luafunc.Push(go);
                    luafunc.Push(value);
                    luafunc.PCall();
                    luafunc.EndPCall();
                }
            );
        }
    }

    public void AddScrollbarOnValueChange(GameObject go, LuaFunction luafunc)
    {
        if (!CheckValid()) return;
        if (go == null || luafunc == null) return;
        if (!mOnScrollbarChangeCallbacks.ContainsKey(go))
        {
            mOnScrollbarChangeCallbacks.Add(go, luafunc);
            // UITriggerListener listener = go.GetComponent<UITriggerListener>();
            // if (listener == null)
            //listener=  go.AddComponent<UITriggerListener>();
            //Debug.LogError("AddOnValueChanged");
            go.GetComponent<Scrollbar>().onValueChanged.AddListener(
                delegate(float mValue)
                {
                    luafunc.BeginPCall();
                    luafunc.Push(go);
                    luafunc.Push(mValue);
                    luafunc.PCall();
                    luafunc.EndPCall();
                }
            );
        }
    }
    ///// <summary>
    ///// 主要用于非按钮点击(比如图片)
    ///// </summary>
    ///// <param name="go"></param>
    ///// <param name="luafunc"></param>
    //public void AddOnClick(GameObject go, LuaFunction luafunc)
    //{
    //    Debug.LogError("AddOnClick in");
    //    if (!CheckValid()) return;
    //    if (go == null || luafunc == null) return;
    //    if (!mButtonCallbacks.ContainsKey(go.name))
    //    {
    //        mButtonCallbacks.Add(go.name, luafunc);
    //        UITriggerListener listener = go.GetComponent<UITriggerListener>();
    //        if (listener == null)
    //            listener = go.AddComponent<UITriggerListener>();
    //        listener.onClick = delegate(PointerEventData eventData)
    //        {
    //            luafunc.BeginPCall();
    //            luafunc.Push(go);
    //            luafunc.PCall();
    //            luafunc.EndPCall();
    //        };

    //    }
    //}

    /// <summary>
    /// 主要用于非按钮点击(比如图片)
    /// </summary>
    /// <param name="go"></param>
    /// <param name="luafunc"></param>
    public void AddOnClick(GameObject go, LuaFunction luafunc)
    {
        // Debug.LogError("AddOnClick in");
        if (!CheckValid()) return;
        if (go == null || luafunc == null) return;
        UITriggerListener listener =   UITriggerListener.Get(go);

        AddOnClickPartEvent(go, luafunc, mOnClickCallbacks, ref listener.onClick);
    }

    /// <summary>
    /// 拖拽
    /// </summary>
    /// <param name="go"></param>
    /// <param name="luafunc"></param>
    public void AddOnDrag(GameObject go, LuaFunction luafunc)
    {
        //Debug.LogError("AddOnDrag in");
        if (!CheckValid()) return;
        if (go == null || luafunc == null) return;
        UITriggerListener listener = UITriggerListener.Get(go);

        //AddPartEvent(go, luafunc, mOnDragCallbacks,ref listener.onDrag);
        AddOnClickPartEvent(go, luafunc, mOnDragCallbacks,ref listener.onDrag);
    }

    /// <summary>
    /// 按下
    /// </summary>
    /// <param name="go"></param>
    /// <param name="luafunc"></param>
    public void AddOnDown(GameObject go, LuaFunction luafunc)
    {
        //Debug.LogError("AddOnDown in");
        if (!CheckValid()) return;
        if (go == null || luafunc == null) return;
        UITriggerListener listener = UITriggerListener.Get(go);

        //AddPartEvent(go, luafunc, mOnDownCallbacks,ref listener.onDown);
        AddOnClickPartEvent(go, luafunc, mOnDownCallbacks,ref listener.onDown);
    }

    /// <summary>
    /// 松开
    /// </summary>
    /// <param name="go"></param>
    /// <param name="luafunc"></param>
    public void AddOnUp(GameObject go, LuaFunction luafunc)
    {
        //Debug.LogError("AddUp in");
        if (!CheckValid()) return;
        if (go == null || luafunc == null) return;
        UITriggerListener listener = UITriggerListener.Get(go);

        //AddPartEvent(go, luafunc, mOnUpCallbacks,ref listener.onUp);
        AddOnClickPartEvent(go, luafunc, mOnUpCallbacks,ref listener.onUp);
    }

    public void AddOnClickPartEvent(GameObject go, LuaFunction luafunc, Dictionary<GameObject, LuaFunction> mCallbacks, ref UITriggerListener.VoideDelegate delEvent)
    {
        if (!mCallbacks.ContainsKey(go))
        {
            mCallbacks.Add(go, luafunc);
            //UITriggerListener listener = go.GetComponent<UITriggerListener>();
            //if (listener == null)
            //    listener = go.AddComponent<UITriggerListener>();
            //Debug.Log("event:" + delEvent);
            delEvent = delegate(PointerEventData eventData)
            {
                //object[] eventDataObj = new[] {eventData};
                luafunc.BeginPCall();
                luafunc.Push(go);
                luafunc.PushArgs(new object[] { eventData });

                //luafunc.Push(eventData);
                luafunc.PCall();
                luafunc.EndPCall();
            };

        }
    }
    /// <summary>
    /// 事件处理
    /// </summary>
    /// <param name="go"></param>
    /// <param name="luafunc"></param>
    /// <param name="mCallbacks"></param>
    /// <param name="delEvent"></param>
    public void AddPartEvent(GameObject go, LuaFunction luafunc, Dictionary<string, LuaFunction> mCallbacks, ref UITriggerListener.VoideDelegate delEvent)
    {
        if (!mCallbacks.ContainsKey(go.name))
        {
            mCallbacks.Add(go.name, luafunc);
            //UITriggerListener listener = go.GetComponent<UITriggerListener>();
            //if (listener == null)
            //    listener = go.AddComponent<UITriggerListener>();
            //Debug.Log("event:" + delEvent);
            delEvent = delegate(PointerEventData eventData)
            {
                //object[] eventDataObj = new[] {eventData};
                luafunc.BeginPCall();
               luafunc.Push(go);
                luafunc.PushArgs(new object[] {eventData });
 
                //luafunc.Push(eventData);
                luafunc.PCall();
                luafunc.EndPCall();
            };

        }
    }

    public void RemoveClick(GameObject go)
    {
        if (!CheckValid()) return;
        if (go == null) return;
        LuaFunction luafunc = null;
        if (mButtonCallbacks.TryGetValue(go.name, out luafunc))
        {
            luafunc.Dispose();
            luafunc = null;
            mButtonCallbacks.Remove(go.name);
        }
    }

    public void RemoveOnValueChanged(GameObject go)
    {
        if (!CheckValid()) return;
        if (go == null) return;
        LuaFunction luafunc = null;
        if (mOnValueChangeCallbacks.TryGetValue(go, out luafunc))
        {
            luafunc.Dispose();
            luafunc = null;
            mOnValueChangeCallbacks.Remove(go);
        }
    }

    public void RemoveScrollbarOnValueChanged(GameObject go)
    {
        if (!CheckValid()) return;
        if (go == null) return;
        LuaFunction luafunc = null;
        if (mOnScrollbarChangeCallbacks.TryGetValue(go, out luafunc))
        {
            luafunc.Dispose();
            luafunc = null;
            mOnScrollbarChangeCallbacks.Remove(go);
        }
    }

    public void RemoveSliderOnValueChanged(GameObject go)
    {
        if (!CheckValid()) return;
        if (go == null) return;
        LuaFunction luafunc = null;
        if (mOnSliderChangeCallbacks.TryGetValue(go, out luafunc))
        {
            luafunc.Dispose();
            luafunc = null;
            mOnSliderChangeCallbacks.Remove(go);
        }
    }

    public void RemoveToggleOnValueChanged(GameObject go)
    {
        if (!CheckValid()) return;
        if (go == null) return;
        LuaFunction luafunc = null;
        if (mOnToggleChangeCallbacks.TryGetValue(go, out luafunc))
        {
            luafunc.Dispose();
            luafunc = null;
            mOnToggleChangeCallbacks.Remove(go);
        }
    }


    public void RemoveOnClick(GameObject go)
    {
        //RemovePartEvent(go, mOnClickCallbacks);
        RemoveObjPartEvent(go, mOnClickCallbacks);
    }


    public void RemoveDrag(GameObject go)
    {
        //RemovePartEvent(go, mOnDragCallbacks);
        RemoveObjPartEvent(go, mOnDragCallbacks);
    }

    public void RemoveUp(GameObject go)
    {
        //RemovePartEvent(go, mOnUpCallbacks);
        RemoveObjPartEvent(go, mOnUpCallbacks);
    }

    public void RemoveDown(GameObject go)
    {
        //RemovePartEvent(go, mOnDownCallbacks);
        RemoveObjPartEvent(go, mOnDownCallbacks);
    }


    public void RemoveListener(GameObject go, LuaFunction luafunc)
    {
        UITriggerListener.RemoveListener(go);
    }

    public void RemovePartEvent(GameObject go,Dictionary<string, LuaFunction> mCallBack)
    {
        if (!CheckValid()) return;
        if (go == null) return;
        LuaFunction luafunc = null;
        if (mCallBack.TryGetValue(go.name, out luafunc))
        {
            luafunc.Dispose();
            luafunc = null;
            mCallBack.Remove(go.name);
        }
    }

    public void RemoveObjPartEvent(GameObject go, Dictionary<GameObject, LuaFunction> mCallBack)
    {
        if (!CheckValid()) return;
        if (go == null) return;
        LuaFunction luafunc = null;
        if (mCallBack.TryGetValue(go, out luafunc))
        {
            luafunc.Dispose();
            luafunc = null;
            mCallBack.Remove(go);
        }
    }


    public void ClearClick()
    {
        foreach (var de in mButtonCallbacks)
        {
            if (de.Value != null)
            {
                de.Value.Dispose();
            }
        }
        mButtonCallbacks.Clear();
    }

    public void ClearAllEvent()
    {
        ClearObjPartEvent(mOnClickCallbacks);
        ClearObjPartEvent(mOnDragCallbacks);
        ClearObjPartEvent(mOnDownCallbacks);
        ClearObjPartEvent(mOnUpCallbacks);
        ClearObjPartEvent(mOnValueChangeCallbacks);
        ClearObjPartEvent(mOnSliderChangeCallbacks);
        ClearObjPartEvent(mOnToggleChangeCallbacks);
        ClearObjPartEvent(mOnScrollbarChangeCallbacks);
    }


    public void ClearPartEvent(Dictionary<string, LuaFunction> mCallBack)
    {
        foreach (var de in mCallBack)
        {
            if (de.Value != null)
            {
                de.Value.Dispose();
            }
        }
        mCallBack.Clear();
    }

    public void ClearObjPartEvent(Dictionary<GameObject, LuaFunction> mCallBack)
    {
        foreach (var de in mCallBack)
        {
            if (de.Value != null)
            {
                de.Value.Dispose();
            }
        }
        mCallBack.Clear();
    }

    private void OnDestroy()
    {
        if (!CheckValid()) return;
        ClearClick();
        ClearAllEvent();
        LuaFunction destroyFunc = mLuaTable.GetLuaFunction("OnDestroy") as LuaFunction;
        if (destroyFunc != null)
        {
            destroyFunc.BeginPCall();
            destroyFunc.PCall();
            destroyFunc.EndPCall();

            destroyFunc.Dispose();
            destroyFunc = null;
        }

        SafeRelease(ref mFixedUpdateFunc);
        SafeRelease(ref mUpdateFunc);
        SafeRelease(ref mLateUpdateFunc);
        SafeRelease(ref mOnEnableFunc);
        SafeRelease(ref mOnDisableFunc);
        SafeRelease(ref mLuaTable);
    }


    public void SetGuideMaskEnableFalse(GameObject go)
    {
        if (go == null)
            return;
        GuideHighlightMask ghm = go.GetComponent<GuideHighlightMask>();
        if (ghm == null || ghm.enabled == false)
            return;
        ghm.enabled = false;
    }

    public void SetGuideMaskEnableTrue(GameObject go, LuaFunction callBack, bool tempBool)
    {
        if (go == null)
            return;

        GuideHighlightMask ghm = go.GetComponent<GuideHighlightMask>();
        if (ghm == null)
            return;

        ghm.SetIsClickNextStep(tempBool);

        if (callBack != null)
        {
            ghm.SetGuideCallBack(callBack);
        }

        if (ghm.enabled != true)
        {
            ghm.enabled = true;
        }
    }

}
