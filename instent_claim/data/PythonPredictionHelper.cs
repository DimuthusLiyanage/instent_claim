using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Threading.Tasks;

namespace instent_claim.data
{
    // Global result class to fix conversion errors
    public class PredictionResult
    {
        [JsonProperty("success")]
        public bool Success { get; set; }

        [JsonProperty("predicted_class")]
        public string PredictedClass { get; set; }

        [JsonProperty("estimated_cost")]
        public decimal EstimatedCost { get; set; }

        [JsonProperty("confidence")]
        public decimal Confidence { get; set; }

        [JsonProperty("error")]
        public string Error { get; set; }
    }

    public class PythonPredictionHelper
    {
        private readonly string pythonExePath;
        private readonly string scriptPath;

        public PythonPredictionHelper(string pythonPath, string scriptPath)
        {
            this.pythonExePath = pythonPath;
            this.scriptPath = scriptPath;
        }

        public async Task<PredictionResult> PredictAsync(string imagePath)
        {
            try
            {
                var startInfo = new ProcessStartInfo
                {
                    FileName = pythonExePath,
                    Arguments = $"\"{scriptPath}\" \"{imagePath}\"",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                };

                using (var process = new Process { StartInfo = startInfo })
                {
                    process.Start();
                    string output = await process.StandardOutput.ReadToEndAsync();
                    await Task.Run(() => process.WaitForExit());

                    if (process.ExitCode != 0) return new PredictionResult { Success = false, Error = "Script failed" };
                    return JsonConvert.DeserializeObject<PredictionResult>(output);
                }
            }
            catch (Exception ex)
            {
                return new PredictionResult { Success = false, Error = ex.Message };
            }
        }
    }
}