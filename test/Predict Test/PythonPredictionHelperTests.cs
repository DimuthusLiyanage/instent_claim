using System;
using System.IO;
using System.Threading.Tasks;
using Newtonsoft.Json;
using NUnit.Framework;
using instent_claim.data; 

namespace Predict_Test
{
    [TestFixture]
    public class PythonPredictionHelperTests
    {
        private string _dummySuccessBatPath;
        private string _dummyFailBatPath;

        [SetUp] // Runs before every test
        public void Setup()
        {
            // 1. Create a dummy executable that simulates a SUCCESSFUL Python script outputting JSON
            _dummySuccessBatPath = Path.Combine(Path.GetTempPath(), "dummy_python_success.bat");
            string successJson = "{\"success\": true, \"predicted_class\": \"Scratch\", \"estimated_cost\": 250.0, \"confidence\": 0.95, \"error\": null}";
            File.WriteAllText(_dummySuccessBatPath, $"@echo {successJson}");

            // 2. Create a dummy executable that simulates a FAILED Python script (Exit Code 1)
            _dummyFailBatPath = Path.Combine(Path.GetTempPath(), "dummy_python_fail.bat");
            File.WriteAllText(_dummyFailBatPath, "@exit /b 1");
        }

        [TearDown] // Runs after every test to clean up our mess
        public void TearDown()
        {
            if (File.Exists(_dummySuccessBatPath)) File.Delete(_dummySuccessBatPath);
            if (File.Exists(_dummyFailBatPath)) File.Delete(_dummyFailBatPath);
        }

        [Test]
        public void PredictionResult_ShouldDeserializeCorrectly()
        {
            // Arrange
            string json = "{\"success\": true, \"predicted_class\": \"Dent\", \"estimated_cost\": 500.50, \"confidence\": 0.88}";

            // Act
            var result = JsonConvert.DeserializeObject<PredictionResult>(json);

            // Assert
            Assert.IsNotNull(result);
            Assert.IsTrue(result.Success);
            Assert.AreEqual("Dent", result.PredictedClass);
            Assert.AreEqual(500.50m, result.EstimatedCost);
            Assert.AreEqual(0.88m, result.Confidence);
        }

        [Test]
        public async Task PredictAsync_WithValidSimulatedProcess_ShouldReturnMappedResult()
        {
            // Arrange
            // We pass our dummy batch file as the "pythonExePath"
            var helper = new PythonPredictionHelper(_dummySuccessBatPath, "fake_script.py");

            // Act
            var result = await helper.PredictAsync("fake_image.jpg");

            // Assert
            Assert.IsNotNull(result, "Result should not be null.");
            Assert.IsTrue(result.Success, "Expected success to be true.");
            Assert.AreEqual("Scratch", result.PredictedClass);
            Assert.AreEqual(250.0m, result.EstimatedCost);
        }

        [Test]
        public async Task PredictAsync_WhenProcessFails_ShouldReturnFalseWithErrorMessage()
        {
            // Arrange
            // We pass our dummy batch file that forces an Exit Code 1
            var helper = new PythonPredictionHelper(_dummyFailBatPath, "fake_script.py");

            // Act
            var result = await helper.PredictAsync("fake_image.jpg");

            // Assert
            Assert.IsNotNull(result);
            Assert.IsFalse(result.Success);
            Assert.AreEqual("Script failed", result.Error);
        }

        [Test]
        public async Task PredictAsync_WithInvalidExecutablePath_ShouldCatchException()
        {
            // Arrange
            string badPath = "C:\\PathThatDoesNotExist\\python.exe";
            var helper = new PythonPredictionHelper(badPath, "fake_script.py");

            // Act
            var result = await helper.PredictAsync("fake_image.jpg");

            // Assert
            Assert.IsNotNull(result);
            Assert.IsFalse(result.Success);
            // The system throws a "The system cannot find the file specified" exception.
            // We just verify that an error message was caught and assigned.
            Assert.IsNotEmpty(result.Error);
        }
    }
}