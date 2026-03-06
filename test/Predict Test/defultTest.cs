using System.Threading.Tasks;
using Microsoft.Playwright.NUnit;
using NUnit.Framework;

namespace Predict_Test
{
    [TestFixture]
    public class DashboardWebFormTests : PageTest // Inherits from Playwright's PageTest
    {
        // Change this to the local URL where your app runs during development
        private readonly string AppUrl = "https://localhost:44300/WebForm1.aspx";

        [Test]
        public async Task PageLoad_WhenNotAuthenticated_ShouldRedirectToLogin()
        {
            // Act: Try to go to the dashboard without logging in
            await Page.GotoAsync(AppUrl);

            // Assert: Verify your C# code redirected us to the login page
            Assert.IsTrue(Page.Url.Contains("Login.aspx"));
        }

        [Test]
        public async Task PageLoad_WhenAuthenticated_ShouldDisplayDashboardStats()
        {
            // Arrange: Go to login page and log in first
            await Page.GotoAsync("https://localhost:44300/Login.aspx");
            await Page.FillAsync("#txtEmail", "testuser@email.com"); // Assuming you have email/password textboxes
            await Page.FillAsync("#txtPassword", "password123");
            await Page.ClickAsync("#btnLogin"); // Click the login button

            // Act: Wait for the dashboard (WebForm1) to load
            await Page.WaitForURLAsync(AppUrl);

            // Assert: Check if your C# code successfully populated the Labels
            // Playwright reads the actual text rendered on the screen
            var noOfClaimsText = await Page.Locator("#lblNoOfClaims").InnerTextAsync();
            var totalCostText = await Page.Locator("#lblTotalCost").InnerTextAsync();

            Assert.IsNotNull(noOfClaimsText);
            Assert.IsTrue(totalCostText.Contains("Rs.")); // Validates the "Rs." formatting in your code
        }
    }
}