using UnityEngine;
using System.Collections;

public class StartLua : MonoBehaviour {

	// Use this for initialization
    //开始第二个场景从新调用启动Lua框架，并启用第二场景所走的Lua主方法
	void Start() {
        AppFacade.Instance.GetManager<LuaManager>().StartMain();
	}
}
