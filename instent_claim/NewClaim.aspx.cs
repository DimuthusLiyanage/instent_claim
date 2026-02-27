using Newtonsoft.Json;
using System;
using System.Collections.Generic;
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
        // URL for your running Flask API
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
            // Validate that files are selected
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
                var displayList = new List<object>(); // Data source for the Repeater

                // Process up to 5 images as requested
                foreach (HttpPostedFile file in fileUpload.PostedFiles.Take(5))
                {
                    // 1. Generate Base64 for front-end preview
                    byte[] fileBytes = new byte[file.ContentLength];
                    file.InputStream.Read(fileBytes, 0, file.ContentLength);
                    string base64String = Convert.ToBase64String(fileBytes);
                    string imageSrc = $"data:{file.ContentType};base64,{base64String}";

                    // 2. Call the Flask API using the file stream
                    file.InputStream.Position = 0; // Reset stream position for the API call
                    var apiResponse = await CallFlaskAPI(file);

                    if (apiResponse != null && apiResponse.Success)
                    {
                        allResults.Add(apiResponse.Data);

                        // Add to list for the Repeater gallery
                        displayList.Add(new
                        {
                            ImageUrl = imageSrc,
                            Class = apiResponse.Data.PredictedClass,
                            Cost = apiResponse.Data.EstimatedCost
                        });
                    }
                }

                if (allResults.Any())
                {
                    // Bind data to the image gallery
                    rptImages.DataSource = displayList;
                    rptImages.DataBind();

                    // Display aggregated totals in LKR
                    lblPredictedClass.Text = string.Join(", ", allResults.Select(r => r.PredictedClass).Distinct());
                    lblEstimatedCost.Text = $"Rs. {allResults.Sum(r => r.EstimatedCost):N0}";
                    lblConfidence.Text = $"{allResults.Average(r => r.Confidence):F1}% (Avg)";

                    resultPanel.Visible = true;
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
            {
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