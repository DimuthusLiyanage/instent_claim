

using System;
using System.Configuration;
using System.Data;
using System.Web;
using instent_claim.data;

namespace instent_claim
{
    public partial class Signup : System.Web.UI.Page
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
            }
        }

        protected void btnSignup_Click(object sender, EventArgs e)
        {
            try
            {
                string fullName = txtFullName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string phoneNumber = txtPhoneNumber.Text.Trim();
                string password = txtPassword.Text.Trim();

                // Register user
                DataTable dt = DatabaseHelper.RegisterUser(email, password, fullName, phoneNumber);

                if (dt.Rows.Count > 0)
                {
                    int userId = Convert.ToInt32(dt.Rows[0]["UserId"]);

                    if (userId > 0)
                    {
                        // Registration successful, redirect to login
                        Response.Redirect("Login.aspx?registered=true");
                    }
                    else
                    {
                        // Registration failed
                        string message = dt.Rows[0]["Message"].ToString();
                        ShowMessage(message);
                    }
                }
                else
                {
                    ShowMessage("Registration failed. Please try again.");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("An error occurred: " + ex.Message);
            }
        }

        protected void btnGoogleSignup_Click(object sender, EventArgs e)
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
                ShowMessage("Google signup error: " + ex.Message);
            }
        }

        private void ShowMessage(string message)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
        }
    }
}