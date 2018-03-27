using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class CheckUpdateScr : MonoBehaviour {
    private Text CheckUpdateText;
	// Use this for initialization
	void Start () {
        CheckUpdateText = gameObject.transform.Find("MessageText").GetComponent<Text>();
	}
	
	// Update is called once per frame
	void Update () {
        CheckUpdateText.text = "发现新内容需要更新！更新大小("+(GameManager.Instance.z_update_Size / (1024 * 1024)).ToString("F2").ToString()+"MB)";
	
	}
}
