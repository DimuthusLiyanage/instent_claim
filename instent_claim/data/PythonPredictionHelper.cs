using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace instent_claim.data
{
    public class PythonPredictionHelper
    {
        
            private readonly string pythonExePath;
            private readonly string scriptPath;

            /// <summary>
            /// Initialize with paths to Python executable and prediction script
            /// </summary>
            /// <param name="pythonPath">Path to python.exe (e.g., "C:\\Python39\\python.exe")</param>
            /// <param name="scriptPath">Path to predict_standalone.py</param>
            public PythonPredictionHelper(string pythonPath, string scriptPath)
            {
                this.pythonExePath = pythonPath;
                this.scriptPath = scriptPath;
            }

            /// <summary>
            /// Execute prediction by calling Python script
            /// </summary>
            /// <param name="imagePath">Full path to the image file</param>
            /// <returns>Prediction result</returns>
            public async Task<PredictionResult> PredictAsync(string imagePath)
            {
                if (!File.Exists(imagePath))
                {
                    throw new FileNotFoundException("Image file not found", imagePath);
                }

                if (!File.Exists(pythonExePath))
                {
                    throw new FileNotFoundException("Python executable not found", pythonExePath);
                }

                if (!File.Exists(scriptPath))
                {
                    throw new FileNotFoundException("Python script not found", scriptPath);
                }

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

                        // Read output
                        string output = await process.StandardOutput.ReadToEndAsync();
                        string error = await process.StandardError.ReadToEndAsync();

                        await Task.Run(() => process.WaitForExit());

                        if (process.ExitCode != 0)
                        {
                            throw new Exception($"Python script error: {error}");
                        }

                        // Parse JSON output
                        var result = JsonConvert.DeserializeObject<PredictionResult>(output);
                        return result;
                    }
                }
                catch (Exception ex)
                {
                    return new PredictionResult
                    {
                        Success = false,
                        Error = $"Prediction error: {ex.Message}"
                    };
                }
            }

            /// <summary>
            /// Execute prediction synchronously
            /// </summary>
            public PredictionResult Predict(string imagePath)
            {
                return PredictAsync(imagePath).GetAwaiter().GetResult();
            }
        }

        #region Result Classes

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

            [JsonProperty("all_predictions")]
            public System.Collections.Generic.Dictionary<string, decimal> AllPredictions { get; set; }

            [JsonProperty("error")]
            public string Error { get; set; }
        }

        #endregion
    }

