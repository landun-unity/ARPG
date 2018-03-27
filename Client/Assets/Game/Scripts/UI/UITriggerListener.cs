using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine.EventSystems;
using UnityEngine;

public  class UITriggerListener : EventTrigger
{
    public delegate void VoideDelegate(PointerEventData eventData);
    public VoideDelegate onDown;
    public VoideDelegate onUp;
    public VoideDelegate onClick;
    public VoideDelegate onExit;
    public VoideDelegate onSelect;
    public VoideDelegate onEnter;
    public VoideDelegate onDrag;

    static public UITriggerListener Get(GameObject go)
    {
        UITriggerListener listener = go.GetComponent<UITriggerListener>();
        if (listener == null)
            listener = go.AddComponent<UITriggerListener>();
        listener.enabled = true;
        return listener;
    }

    //删除脚本
    static public void  RemoveListener(GameObject go)
    {
        UITriggerListener listener = go.GetComponent<UITriggerListener>();
        if (listener != null)
            //Destroy(listener);
           listener.enabled = false;
    }

    
    public override void OnPointerClick(PointerEventData eventData)
    {
        if (onClick != null)
            onClick(eventData);
    }

    public override void OnPointerDown(PointerEventData eventData)
    {
        //Debug.LogError("onDown");
        if (onDown != null)
            onDown(eventData);
    }

    public override void OnPointerUp(PointerEventData eventData)
    {
        if (onUp != null)
            onUp(eventData);
    }

    public override void OnDrag(PointerEventData eventData)
    {
        if (onDrag != null)
            onDrag(eventData);
    }
}
