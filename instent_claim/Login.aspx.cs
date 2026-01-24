

using System;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using instent_claim.data;

namespace instent_claim
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is already logged in
                if (User.Identity.IsAuthenticated)
                {
                    Response.Redirect("~/Default.aspx");
                }

                // Check for registration success message
                if (Request.QueryString["registered"] == "true")
                {
                    ShowMessage("Registration successful! Please login.", "success");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text.Trim();

                DataTable dt = DatabaseHelper.LoginUser(email, password);

                if (dt.Rows.Count > 0)
                {
                    int userId = Convert.ToInt32(dt.Rows[0]["UserId"]);

                    if (userId > 0)
                    {
                        // Login successful
                        string fullName = dt.Rows[0]["FullName"].ToString();

                        // Create authentication ticket
                        FormsAuthentication.SetAuthCookie(email, false);

                        // Store user information in session
                        Session["UserId"] = userId;
                        Session["Email"] = email;
                        Session["FullName"] = fullName;

                        // Redirect to home page
                        Response.Redirect("~/Default.aspx");
                    }
                    else
                    {
                        // Login failed
                        string message = dt.Rows[0]["Message"].ToString();
                        ShowMessage(message, "error");
                    }
                }
                else
                {
                    ShowMessage("Invalid email or password", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("An error occurred: " + ex.Message, "error");
            }
        }

        protected void btnGoogleLogin_Click(object sender, EventArgs e)
        {
            try
            {
                string clientId = ConfigurationManager.AppSettings["GoogleClientId"];
                string redirectUri = ConfigurationManager.AppSettings["GoogleRedirectUri"];

                string googleAuthUrl = "https://accounts.google.com/o/oauth2/v2/auth?" +
                    "client_id=" + clientId +
                    "&redirect_uri=" + HttpUtility.UrlEncode(redirectUri) +
                    "&response_type=code" +
                    "&scope=" + HttpUtility.UrlEncode("openid email profile") +
                    "&access_type=offline" +
                    "&prompt=consent";

                Response.Redirect(googleAuthUrl);
            }
            catch (Exception ex)
            {
                ShowMessage("Google login error: " + ex.Message, "error");
            }
        }

        private void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
            lblMessage.CssClass = type == "success" ? "success-message" : "error-message";
        }
    }
}