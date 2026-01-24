
using System;
using System.Configuration;
using System.Data;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Security;
using instent_claim.data;

namespace instent_claim
{
    public partial class GoogleCallback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string code = Request.QueryString["code"];

            if (string.IsNullOrEmpty(code))
            {
                Response.Redirect("Login.aspx");
                return;
            }

            try
            {
                // Exchange authorization code for access token
                string accessToken = ExchangeCodeForAccessToken(code);

                if (!string.IsNullOrEmpty(accessToken))
                {
                    // Get user info from Google
                    GoogleUserInfo userInfo = GetGoogleUserInfo(accessToken);

                    if (userInfo != null)
                    {
                        // Login or register user
                        DataTable dt = DatabaseHelper.GoogleLogin(userInfo.Email, userInfo.Id, userInfo.Name);

                        if (dt.Rows.Count > 0)
                        {
                            int userId = Convert.ToInt32(dt.Rows[0]["UserId"]);

                            if (userId > 0)
                            {
                                // Login successful
                                FormsAuthentication.SetAuthCookie(userInfo.Email, false);

                                // Store user information in session
                                Session["UserId"] = userId;
                                Session["Email"] = userInfo.Email;
                                Session["FullName"] = dt.Rows[0]["FullName"].ToString();

                                // Redirect to home page
                                Response.Redirect("~/Default.aspx");
                            }
                            else
                            {
                                Response.Redirect("Login.aspx");
                            }
                        }
                    }
                }

                Response.Redirect("Login.aspx");
            }
            catch (Exception ex)
            {
                // Log error and redirect
                Response.Redirect("Login.aspx?error=" + HttpUtility.UrlEncode(ex.Message));
            }
        }

        private string ExchangeCodeForAccessToken(string code)
        {
            string clientId = ConfigurationManager.AppSettings["GoogleClientId"];
            string clientSecret = ConfigurationManager.AppSettings["GoogleClientSecret"];
            string redirectUri = ConfigurationManager.AppSettings["GoogleRedirectUri"];

            string tokenEndpoint = "https://oauth2.googleapis.com/token";

            string postData = string.Format(
                "code={0}&client_id={1}&client_secret={2}&redirect_uri={3}&grant_type=authorization_code",
                code, clientId, clientSecret, HttpUtility.UrlEncode(redirectUri));

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(tokenEndpoint);
            request.Method = "POST";
            request.ContentType = "application/x-www-form-urlencoded";

            using (StreamWriter writer = new StreamWriter(request.GetRequestStream()))
            {
                writer.Write(postData);
            }

            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            string responseText;

            using (StreamReader reader = new StreamReader(response.GetResponseStream()))
            {
                responseText = reader.ReadToEnd();
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            dynamic tokenResponse = serializer.Deserialize<dynamic>(responseText);

            return tokenResponse["access_token"];
        }

        private GoogleUserInfo GetGoogleUserInfo(string accessToken)
        {
            string userInfoEndpoint = "https://www.googleapis.com/oauth2/v2/userinfo";

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(userInfoEndpoint);
            request.Method = "GET";
            request.Headers.Add("Authorization", "Bearer " + accessToken);

            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            string responseText;

            using (StreamReader reader = new StreamReader(response.GetResponseStream()))
            {
                responseText = reader.ReadToEnd();
            }

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            GoogleUserInfo userInfo = serializer.Deserialize<GoogleUserInfo>(responseText);

            return userInfo;
        }
    }

    public class GoogleUserInfo
    {
        public string Id { get; set; }
        public string Email { get; set; }
        public string Name { get; set; }
        public string Picture { get; set; }
    }
}