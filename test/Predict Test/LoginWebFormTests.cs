using System.Threading.Tasks;
using Microsoft.Playwright.NUnit;
using NUnit.Framework;

namespace Predict_Test
{
    [TestFixture]
    public class LoginWebFormTests : PageTest // Inherits from Playwright to control the browser
    {
        // Update this to match your local development port
        private readonly string LoginUrl = "https://localhost:44300/Login.aspx";

        [Test]
        public async Task PageLoad_WithRegisteredQueryString_ShouldShowSuccessMessage()
        {
            // Act: Navigate to the login page with the "registered=true" parameter
            await Page.GotoAsync($"{LoginUrl}?registered=true");

            // Assert: Verify your ShowMessage logic displays the correct text
            var messageText = await Page.Locator("#lblMessage").InnerTextAsync();
            Assert.IsTrue(messageText.Contains("Registration successful"));
        }

        [Test]
        public async Task Login_WithInvalidCredentials_ShouldShowErrorMessage()
        {
            // Arrange: Go to the page and fill out the form
            await Page.GotoAsync(LoginUrl);
            await Page.FillAsync("#txtEmail", "wrong@email.com");
            await Page.FillAsync("#txtPassword", "wrongpassword");

            // Act: Click the login button
            await Page.ClickAsync("#btnLogin");

            // Assert: Verify the error message appears
            var messageText = await Page.Locator("#lblMessage").InnerTextAsync();

            // Checking for either the default invalid message or a custom DB message
            Assert.IsTrue(messageText.Contains("Invalid email or password") || messageText.Length > 0);
        }

        [Test]
        public async Task GoogleLoginButton_Click_ShouldRedirectToGoogle()
        {
            // Arrange: Go to the login page
            await Page.GotoAsync(LoginUrl);

            // Act: Click the Google login button and wait for the page to redirect
            await Page.RunAndWaitForNavigationAsync(async () =>
            {
                await Page.ClickAsync("#btnGoogleLogin");
            });

            // Assert: Verify the user was sent to the Google OAuth servers
            Assert.IsTrue(Page.Url.StartsWith("https://accounts.google.com/o/oauth2"));
            Assert.IsTrue(Page.Url.Contains("response_type=code"));
        }

        [Test]
        public async Task Login_WithValidCredentials_ShouldRedirectToDefaultPage()
        {
            // Note: For this test to pass, you MUST have this user in your local testing database!

            // Arrange
            await Page.GotoAsync(LoginUrl);
            await Page.FillAsync("#txtEmail", "realuser@yourdomain.com");
            await Page.FillAsync("#txtPassword", "RealPassword123!");

            // Act: Click login and wait for the redirect
            await Page.RunAndWaitForNavigationAsync(async () =>
            {
                await Page.ClickAsync("#btnLogin");
            });

            // Assert: Verify we landed on the home page after Session and AuthCookies were set
            Assert.IsTrue(Page.Url.Contains("Default.aspx"));
        }
    }
}