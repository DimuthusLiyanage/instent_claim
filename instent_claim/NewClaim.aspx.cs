using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Http;
using System.Net.Http.Headers;


namespace instent_claim
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        // Python API endpoint URL
        private const string API_URL = "http://localhost:5000/api/predict";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initialize page
                resultPanel.Visible = false;
            }

        }
        protected async void btnPredict_Click(object sender, EventArgs e)
        {
            if (!fileUpload.HasFile)
            {
                lblError.Text = "Please select an image file.";
                lblError.Visible = true;
                return;
            }

            try
            {
                lblError.Visible = false;
                resultPanel.Visible = false;

                // Get uploaded file
                HttpPostedFile uploadedFile = fileUpload.PostedFile;

                // Validate file type
                string[] allowedExtensions = { ".jpg", ".jpeg", ".png" };
                string fileExtension = Path.GetExtension(uploadedFile.FileName).ToLower();

                if (Array.IndexOf(allowedExtensions, fileExtension) == -1)
                {
                    lblError.Text = "Invalid file type. Only JPG, JPEG, and PNG are allowed.";
                    lblError.Visible = true;
                    return;
                }

                // Call Python API
                var result = await CallPredictionAPI(uploadedFile);

                if (result != null && result.Success)
                {
                    // Display results
                    DisplayResults(result.Data, uploadedFile);
                }
                else
                {
                    lblError.Text = "Prediction failed: " + (result?.Error ?? "Unknown error");
                    lblError.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Error: " + ex.Message;
                lblError.Visible = true;
            }
        }

        private async Task<ApiResponse> CallPredictionAPI(HttpPostedFile file)
        {
            using (var client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(30);

                // Create multipart form data
                using (var content = new MultipartFormDataContent())
                {
                    // Read file stream
                    byte[] fileBytes = new byte[file.ContentLength];
                    file.InputStream.Read(fileBytes, 0, file.ContentLength);

                    // Add file to form data
                    var fileContent = new ByteArrayContent(fileBytes);
                    fileContent.Headers.ContentType = MediaTypeHeaderValue.Parse(file.ContentType);
                    content.Add(fileContent, "file", file.FileName);

                    // Send POST request
                    var response = await client.PostAsync(API_URL, content);

                    if (response.IsSuccessStatusCode)
                    {
                        string jsonResponse = await response.Content.ReadAsStringAsync();
                        return JsonConvert.DeserializeObject<ApiResponse>(jsonResponse);
                    }
                    else
                    {
                        string errorContent = await response.Content.ReadAsStringAsync();
                        return new ApiResponse
                        {
                            Success = false,
                            Error = $"API Error: {response.StatusCode} - {errorContent}"
                        };
                    }
                }
            }
        }

        private void DisplayResults(PredictionData data, HttpPostedFile file)
        {
            // Display the uploaded image
            byte[] fileBytes = new byte[file.ContentLength];
            file.InputStream.Position = 0;
            file.InputStream.Read(fileBytes, 0, file.ContentLength);
            string base64Image = Convert.ToBase64String(fileBytes);
            imgPreview.ImageUrl = $"data:{file.ContentType};base64,{base64Image}";

            // Display prediction results with LKR formatting
            lblPredictedClass.Text = data.PredictedClass;
            lblEstimatedCost.Text = $"Rs. {data.EstimatedCost:N0}"; // LKR format with comma separator
            lblConfidence.Text = $"{data.Confidence}%";

            // Show result panel
            resultPanel.Visible = true;
        }

        #region Helper Classes for JSON Deserialization
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

            [JsonProperty("all_predictions")]
            public Dictionary<string, decimal> AllPredictions { get; set; }
        }

        #endregion
    }
}