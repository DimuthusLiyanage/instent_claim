
using System;
using System.Configuration;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

namespace instent_claim.data
{
    public class GoogleOAuthHelper
    {
        private static readonly string ClientId = ConfigurationManager.AppSettings["GoogleClientId"];
        private static readonly string ClientSecret = ConfigurationManager.AppSettings["GoogleClientSecret"];
        private static readonly string RedirectUri = ConfigurationManager.AppSettings["GoogleRedirectUri"];

        public static string GetAuthorizationUrl()
        {
            string scope = HttpUtility.UrlEncode("openid email profile");

            return $"https://accounts.google.com/o/oauth2/v2/auth?" +
                   $"client_id={ClientId}" +
                   $"&redirect_uri={HttpUtility.UrlEncode(RedirectUri)}" +
                   $"&response_type=code" +
                   $"&scope={scope}" +
                   $"&access_type=offline" +
                   $"&prompt=consent";
        }

        public static TokenResponse ExchangeCodeForToken(string code)
        {
            try
            {
                string tokenEndpoint = "https://oauth2.googleapis.com/token";

                string postData = $"code={code}" +
                                $"&client_id={ClientId}" +
                                $"&client_secret={ClientSecret}" +
                                $"&redirect_uri={HttpUtility.UrlEncode(RedirectUri)}" +
                                $"&grant_type=authorization_code";

                byte[] data = Encoding.UTF8.GetBytes(postData);

                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(tokenEndpoint);
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = data.Length;

                using (Stream stream = request.GetRequestStream())
                {
                    stream.Write(data, 0, data.Length);
                }

                string responseText;
                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                {
                    responseText = reader.ReadToEnd();
                }

                JavaScriptSerializer serializer = new JavaScriptSerializer();
                return serializer.Deserialize<TokenResponse>(responseText);
            }
            catch (WebException ex)
            {
                using (StreamReader reader = new StreamReader(ex.Response.GetResponseStream()))
                {
                    string errorResponse = reader.ReadToEnd();
                    throw new Exception($"Token exchange failed: {errorResponse}");
                }
            }
        }

        public static GoogleUserInfo GetUserInfo(string accessToken)
        {
            try
            {
                string userInfoEndpoint = "https://www.googleapis.com/oauth2/v2/userinfo";

                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(userInfoEndpoint);
                request.Method = "GET";
                request.Headers.Add("Authorization", $"Bearer {accessToken}");

                string responseText;
                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                {
                    responseText = reader.ReadToEnd();
                }

                JavaScriptSerializer serializer = new JavaScriptSerializer();
                return serializer.Deserialize<GoogleUserInfo>(responseText);
            }
            catch (WebException ex)
            {
                using (StreamReader reader = new StreamReader(ex.Response.GetResponseStream()))
                {
                    string errorResponse = reader.ReadToEnd();
                    throw new Exception($"Failed to get user info: {errorResponse}");
                }
            }
        }
    }

    public class TokenResponse
    {
        public string access_token { get; set; }
        public string token_type { get; set; }
        public int expires_in { get; set; }
        public string refresh_token { get; set; }
        public string scope { get; set; }
    }

    public class GoogleUserInfo
    {
        public string id { get; set; }
        public string email { get; set; }
        public string verified_email { get; set; }
        public string name { get; set; }
        public string given_name { get; set; }
        public string family_name { get; set; }
        public string picture { get; set; }
    }
}