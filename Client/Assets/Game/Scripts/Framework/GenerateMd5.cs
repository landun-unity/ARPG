using System.Security.Cryptography;
/// <summary>
/// Éú³ÉMd5×Ö·û´®
/// </summary>
using System.Text;
public class GenerateMd5
{
    public string _GenerateMd5Str(string str)
    {
        byte[] b = Encoding.Default.GetBytes(str);
        b = new MD5CryptoServiceProvider().ComputeHash(b);
        string ret = "";
        for (int i = 0; i < b.Length; i++)
        {
            ret += b[i].ToString("x").PadLeft(2, '0');
        }

        return ret;
    }

}