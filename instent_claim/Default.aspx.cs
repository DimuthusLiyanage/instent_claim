using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace instent_claim
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Set the Welcome Name independently in the Content Page
                // This replaces the JavaScript logic from the original page
                string fullName = string.Empty;

                if (Session["FullName"] != null)
                {
                    fullName = Session["FullName"].ToString();
                }
                else if (Session["Email"] != null)
                {
                    fullName = Session["Email"].ToString();
                }
                else
                {
                    fullName = User.Identity.Name;
                }

                // Get first name only for the "Welcome back, [Name]!" message
                if (!string.IsNullOrEmpty(fullName))
                {
                    var names = fullName.Split(' ');
                    lblWelcomeName.Text = names[0];
                }
            }
        }
    }
}