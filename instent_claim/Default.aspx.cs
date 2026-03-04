using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

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

                if (!string.IsNullOrEmpty(fullName))
                {
                    var names = fullName.Split(' ');
                    lblWelcomeName.Text = names[0];
                }

                // Call the database to get the user's stats
                string username = User.Identity.Name;
                LoadDashboardStats(username);
            }
        }

        private void LoadDashboardStats(string username)
        {
            string connStr = ConfigurationManager.ConnectionStrings["InsuranceClaimDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Use the name of the Stored Procedure instead of the query string
                using (SqlCommand cmd = new SqlCommand("sp_GetDashboardStats", conn))
                {
                    // Crucial: Tell the command it is a Stored Procedure
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Username", username);

                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                int claimCount = Convert.ToInt32(reader["ClaimCount"]);
                                decimal totalCost = Convert.ToDecimal(reader["TotalCost"]);
                                decimal maxConfidence = Convert.ToDecimal(reader["MaxConfidence"]);

                                lblNoOfClaims.Text = claimCount.ToString("N0");
                                lblTotalCost.Text = $"Rs. {totalCost:N0}";
                                lblMaxConfidence.Text = $"{maxConfidence:F1}%";
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        // Log the exception (ex) here if needed
                        lblNoOfClaims.Text = "0";
                        lblTotalCost.Text = "Rs. 0";
                        lblMaxConfidence.Text = "0%";
                    }
                }
            }
        }
    }
}