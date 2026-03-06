using System.IO;
using System.Threading.Tasks;
using Microsoft.Playwright.NUnit;
using NUnit.Framework;

namespace Predict_Test
{
    [TestFixture]
    public class Newclaim : PageTest
    {
        // Update this URL to match your local environment
        private readonly string PredictPageUrl = "https://localhost:44300/WebForm2.aspx";
        private string _dummyImagePath;

        [SetUp]
        public async Task Setup()
        {
            // Create a temporary dummy text file and pretend it's an image
            // In a real scenario, you should put a tiny real .jpg file in your test project folder
            _dummyImagePath = Path.Combine(Path.GetTempPath(), "test_car_damage.jpg");
            await File.WriteAllBytesAsync(_dummyImagePath, new byte[] { 0xFF, 0xD8, 0xFF, 0xE0 }); // Fake JPEG header
        }

        [TearDown]
        public void TearDown()
        {
            if (File.Exists(_dummyImagePath))
            {
                File.Delete(_dummyImagePath);
            }
        }

        [Test]
        public async Task PredictButton_Click_WithoutFile_ShouldShowErrorMessage()
        {
            // Act: Go to the page and click Predict without uploading anything
            await Page.GotoAsync(PredictPageUrl);
            await Page.ClickAsync("#btnPredict");

            // Assert: Verify the error label became visible and shows the right text
            var errorLocator = Page.Locator("#lblError");
            var isVisible = await errorLocator.IsVisibleAsync();
            var errorText = await errorLocator.InnerTextAsync();

            Assert.IsTrue(isVisible);
            Assert.IsTrue(errorText.Contains("Please select at least one image file"));
        }

        [Test]
        public async Task PredictButton_Click_WithValidFile_ShouldShowResults()
        {
            // IMPORTANT WARNING: 
            // This test will actually attempt to hit http://localhost:5000/api/predict 
            // and write to your local SQL database! Both must be running for this to pass.

            // Arrange: Go to the page
            await Page.GotoAsync(PredictPageUrl);

            // Upload the dummy file into your ASP:FileUpload control
            // Note: Make sure your asp:FileUpload control has ClientIDMode="Static" in the HTML!
            await Page.SetInputFilesAsync("#fileUpload", _dummyImagePath);

            // Act: Click predict and wait for the page to process
            await Page.RunAndWaitForNavigationAsync(async () =>
            {
                await Page.ClickAsync("#btnPredict");
            });

            // Assert: Check if the results panel became visible
            // If the Flask API isn't running, your C# catch block will fire and lblError will show instead.
            var errorLocator = Page.Locator("#lblError");
            var resultPanelLocator = Page.Locator("#resultPanel");

            if (await errorLocator.IsVisibleAsync())
            {
                var errorMsg = await errorLocator.InnerTextAsync();
                Assert.Fail($"Test failed because the API or DB threw an error: {errorMsg}");
            }
            else
            {
                // Verify the panel is visible and the cost label has data
                Assert.IsTrue(await resultPanelLocator.IsVisibleAsync());

                var costText = await Page.Locator("#lblEstimatedCost").InnerTextAsync();
                Assert.IsTrue(costText.Contains("Rs."));
            }
        }
    }
}