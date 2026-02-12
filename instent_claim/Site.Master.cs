using System;
using System.Web;
using System.Web.Security;
using System.Web.UI;

namespace instent_claim
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Display user information
                string fullName = string.Empty;

                if (Session["FullName"] != null)
                {
                    fullName = Session["FullName"].ToString();
                }
                else if (Session["Email"] != null)
                {
                    fullName = Session["Email"].ToString();
                }
                else if (Page.User.Identity.IsAuthenticated)
                {
                    fullName = Page.User.Identity.Name;
                }

                if (!string.IsNullOrEmpty(fullName))
                {
                    lblUserName.Text = fullName;

                    // Set Initial Server Side (Cleaner than JS)
                    if (fullName.Length > 0)
                    {
                        lblUserInitial.Text = fullName.Substring(0, 1).ToUpper();
                        if (fullName.Contains(" ") && fullName.Split(' ').Length > 1)
                        {
                            // Take first letter of first and last name if available
                            var parts = fullName.Split(' ');
                            lblUserInitial.Text = (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpper();
                        }
                    }
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
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();
            Response.Redirect("~/Login.aspx");
        }
    }
}