

using System;
using System.Web;
using System.Web.Security;

namespace instent_claim
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is authenticated
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Display user information
                if (Session["FullName"] != null)
                {
                    lblUserName.Text = Session["FullName"].ToString();
                }
                else if (Session["Email"] != null)
                {
                    lblUserName.Text = Session["Email"].ToString();
                }
                else
                {
                    lblUserName.Text = User.Identity.Name;
                }

                // Show badge if Google user
                if (Session["IsGoogleUser"] != null && (bool)Session["IsGoogleUser"])
                {
                    lblUserBadge.Text = "Google";
                    lblUserBadge.Visible = true;
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear session
            Session.Clear();
            Session.Abandon();

            // Sign out from forms authentication
            FormsAuthentication.SignOut();

            // Redirect to login page
            Response.Redirect("~/Login.aspx");
        }
    }
}