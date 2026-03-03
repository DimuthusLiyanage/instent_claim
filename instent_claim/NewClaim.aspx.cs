using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;              // Added for ConfigurationManager
using System.Data;                       // Added for CommandType
using System.Data.SqlClient;              // Added for SQL connection
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;

namespace instent_claim
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        private const string API_URL = "http://localhost:5000/api/predict";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                resultPanel.Visible = false;
            }
        }

        protected async void btnPredict_Click(object sender, EventArgs e)
        {
            if (!fileUpload.HasFiles)
            {
                lblError.Text = "Please select at least one image file.";
                lblError.Visible = true;
                return;
            }

            try
            {
                lblError.Visible = false;
                var allResults = new List<PredictionData>();
                var displayList = new List<object>();
                var dbErrors = new List<string>(); // To collect any database errors silently

                // Get current user (if authentication is enabled, otherwise fallback)
                string currentUser = User.Identity.IsAuthenticated ? User.Identity.Name : "Anonymous";
                DateTime now = DateTime.Now;

                foreach (HttpPostedFile file in fileUpload.PostedFiles.Take(5))
                {
                    // Generate Base64 for front-end preview
                    byte[] fileBytes = new byte[file.ContentLength];
                    file.InputStream.Read(fileBytes, 0, file.ContentLength);
                    string base64String = Convert.ToBase64String(fileBytes);
                    string imageSrc = $"data:{file.ContentType};base64,{base64String}";

                    // Call the Flask API
                    file.InputStream.Position = 0;
                    var apiResponse = await CallFlaskAPI(file);

                    if (apiResponse != null && apiResponse.Success)
                    {
                        allResults.Add(apiResponse.Data);
                        displayList.Add(new
                        {
                            ImageUrl = imageSrc,
                            Class = apiResponse.Data.PredictedClass,
                            Cost = apiResponse.Data.EstimatedCost
                        });

                        // Save to database using stored procedure
                        try
                        {
                            await SavePredictionToDatabase(currentUser, apiResponse.Data, now);
                        }
                        catch (Exception ex)
                        {
                            // Log the error but continue processing other images
                            dbErrors.Add($"Failed to save prediction for {file.FileName}: {ex.Message}");
                        }
                    }
                }

                if (allResults.Any())
                {
                    rptImages.DataSource = displayList;
                    rptImages.DataBind();

                    lblPredictedClass.Text = string.Join(", ", allResults.Select(r => r.PredictedClass).Distinct());
                    lblEstimatedCost.Text = $"Rs. {allResults.Sum(r => r.EstimatedCost):N0}";
                    lblConfidence.Text = $"{allResults.Average(r => r.Confidence):F1}% (Avg)";

                    resultPanel.Visible = true;

                    // Optionally display database errors as a warning (not interrupting the user)
                    if (dbErrors.Any())
                    {
                        lblError.Text = "Warning: Some records could not be saved to the database.";
                        lblError.Visible = true;
                        // You could also log dbErrors to a file or event log
                    }
                }
                else
                {
                    lblError.Text = "No valid analysis returned from the AI model.";
                    lblError.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Error communicating with AI service: " + ex.Message;
                lblError.Visible = true;
            }
        }

        private async Task<ApiResponse> CallFlaskAPI(HttpPostedFile file)
        {
            using (var client = new HttpClient())
            using (var content = new MultipartFormDataContent())
            {
                byte[] fileBytes = new byte[file.ContentLength];
                file.InputStream.Position = 0;
                file.InputStream.Read(fileBytes, 0, file.ContentLength);

                var fileContent = new ByteArrayContent(fileBytes);
                fileContent.Headers.ContentType = MediaTypeHeaderValue.Parse(file.ContentType);
                content.Add(fileContent, "file", file.FileName);

                var response = await client.PostAsync(API_URL, content);
                if (response.IsSuccessStatusCode)
                {
                    string jsonResponse = await response.Content.ReadAsStringAsync();
                    return JsonConvert.DeserializeObject<ApiResponse>(jsonResponse);
                }
                return null;
            }
        }

        /// <summary>
        /// Inserts a prediction record into the database using a stored procedure.
        /// Assumes a stored procedure named 'InsertPrediction' with parameters:
        /// @User, @PredictedClass, @EstimatedCost, @Confidence, @CreatedDateTime
        /// </summary>
        private async Task SavePredictionToDatabase(string user, PredictionData data, DateTime createdDateTime)
        {
            string connStr = ConfigurationManager.ConnectionStrings["InsuranceClaimDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("InsertPrediction", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@User", user);
                cmd.Parameters.AddWithValue("@PredictedClass", data.PredictedClass);
                cmd.Parameters.AddWithValue("@EstimatedCost", data.EstimatedCost);
                cmd.Parameters.AddWithValue("@Confidence", data.Confidence);
                cmd.Parameters.AddWithValue("@CreatedDateTime", createdDateTime);

                await conn.OpenAsync();
                await cmd.ExecuteNonQueryAsync();
            }
        }

        #region Helper Classes for JSON Mapping
        public class ApiResponse
        {
            [JsonProperty("success")]
            public bool Success { get; set; }
            [JsonProperty("data")]
            public PredictionData Data { get; set; }
            [JsonProperty("error")]
            public string Error { get; set; }
        }

        public class PredictionData
        {
            [JsonProperty("predicted_class")]
            public string PredictedClass { get; set; }
            [JsonProperty("estimated_cost")]
            public decimal EstimatedCost { get; set; }
            [JsonProperty("confidence")]
            public decimal Confidence { get; set; }
        }
        #endregion
    }
}