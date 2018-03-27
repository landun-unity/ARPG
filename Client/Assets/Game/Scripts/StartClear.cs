using UnityEngine;
using System.Collections;

public class StartClear : MonoBehaviour {

	// Use this for initialization
	void Start () {
        AppFacade.Instance.GetManager<LuaManager>().StartMain();   //启动游戏
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
