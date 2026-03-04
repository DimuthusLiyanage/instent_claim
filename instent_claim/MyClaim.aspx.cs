using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace instent_claim
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Default filter: Last 30 days
                txtFromDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
                txtToDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                BindGrid();
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            BindGrid();
        }

        private void BindGrid()
        {
            string connStr = ConfigurationManager.ConnectionStrings["InsuranceClaimDB"].ConnectionString;
            string currentUser = User.Identity.IsAuthenticated ? User.Identity.Name : "Anonymous";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetFilteredClaims", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Username", currentUser);

                    // Date Range Filters
                    if (DateTime.TryParse(txtFromDate.Text, out DateTime fromDate))
                    {
                        cmd.Parameters.AddWithValue("@FromDate", fromDate);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@FromDate", DBNull.Value);
                    }

                    if (DateTime.TryParse(txtToDate.Text, out DateTime toDate))
                    {
                        // Add 1 day to include the full end date
                        cmd.Parameters.AddWithValue("@ToDate", toDate.AddDays(1));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@ToDate", DBNull.Value);
                    }

                    // Confidence Filter
                    if (decimal.TryParse(txtConfidence.Text, out decimal minConfidence))
                    {
                        cmd.Parameters.AddWithValue("@MinConfidence", minConfidence);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@MinConfidence", DBNull.Value);
                    }

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gvClaims.DataSource = dt;
                        gvClaims.DataBind();
                    }
                }
            }
        }
    }
}