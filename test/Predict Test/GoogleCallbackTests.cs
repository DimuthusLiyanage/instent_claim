using System.Threading.Tasks;
using Microsoft.Playwright.NUnit;
using NUnit.Framework;

namespace Predict_Test
{
    [TestFixture]
    public class GoogleCallbackTests : PageTest
    {
        // Change this to your local development URL
        private readonly string CallbackUrl = "https://localhost:44300/GoogleCallback.aspx";

        [Test]
        public async Task PageLoad_WithNoCode_ShouldRedirectToLogin()
        {
            // Act: Try to navigate to the callback page without a Google code
            await Page.GotoAsync(CallbackUrl);

            // Assert: Verify the first "if (string.IsNullOrEmpty(code))" block works
            // and successfully redirects the user back to the login page.
            Assert.IsTrue(Page.Url.Contains("Login.aspx"));
        }

        [Test]
        public async Task PageLoad_WithInvalidCode_ShouldRedirectToLoginWithError()
        {
            // Arrange: Create a fake URL with a bogus Google code
            string urlWithFakeCode = $"{CallbackUrl}?code=fake_invalid_google_code_123";

            // Act: Navigate to the URL
            await Page.GotoAsync(urlWithFakeCode);

            // Assert: Since the code is fake, ExchangeCodeForAccessToken will fail,
            // hit the catch block, and redirect with an error in the query string.
            Assert.IsTrue(Page.Url.Contains("Login.aspx"));
            Assert.IsTrue(Page.Url.Contains("error="));
        }
    }
}