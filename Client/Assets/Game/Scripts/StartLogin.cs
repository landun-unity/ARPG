using UnityEngine;
using System.Collections;

public class StartLogin : MonoBehaviour
{
    // Use this for initialization
    void Start()
    {
        if (Globals.Instance.BoolFirstTime())
        {
            Globals.Instance.SetFirstTime(false);
        }
        else
        {
            AppFacade.Instance.GetManager<LuaManager>().StartMain();   //启动游戏
        }
    }
}
