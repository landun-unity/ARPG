using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class UpdateScr : MonoBehaviour {

    private Slider UpdatePercent;
    private Text UpdateText;
    private Text UpdateSize;
	void Start () {
        UpdatePercent = gameObject.transform.Find("UpdatePercentSlider").GetComponent<Slider>();
        UpdateText = gameObject.transform.Find("PercentText").GetComponent<Text>();
        UpdateSize = gameObject.transform.Find("SpeedAndSizeText").GetComponent<Text>();
	}
	
	
	void Update () {
        UpdatePercent.value = GameManager.Instance.z_UpdatePercent;
        UpdateText.text = "正在更新..." + (GameManager.Instance.z_UpdatePercent * 100).ToString("F1") + "%";
        UpdateSize.text = (GameManager.Instance.z_nowUpdateSize / (1024 * 1024)).ToString("F2") + "MB/" + (GameManager.Instance.z_update_Size / (1024 * 1024)).ToString("F2") + "MB";
	}
}
