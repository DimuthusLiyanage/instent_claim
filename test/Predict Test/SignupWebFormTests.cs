using System;
using System.Threading.Tasks;
using Microsoft.Playwright.NUnit;
using NUnit.Framework;

namespace Predict_Test
{
    [TestFixture]
    public class SignupWebFormTests : PageTest
    {
        // Update this URL to match your local development environment
        private readonly string SignupUrl = "https://localhost:44300/Signup.aspx";

        [Test]
        public async Task Signup_WithValidData_ShouldRegisterAndRedirectToLogin()
        {
            // Arrange: Generate a unique email so the database doesn't block duplicate registrations
            string uniqueEmail = $"testuser_{Guid.NewGuid().ToString().Substring(0, 8)}@example.com";

            await Page.GotoAsync(SignupUrl);

            // Fill out the registration form
            // Note: Make sure these textboxes have ClientIDMode="Static" in your .aspx file!
            await Page.FillAsync("#txtFullName", "Automated Test User");
            await Page.FillAsync("#txtEmail", uniqueEmail);
            await Page.FillAsync("#txtPhoneNumber", "555-0199");
            await Page.FillAsync("#txtPassword", "SecurePassword123!");

            // Act: Click signup and wait for the C# Response.Redirect to happen
            await Page.RunAndWaitForNavigationAsync(async () =>
            {
                await Page.ClickAsync("#btnSignup");
            });

            // Assert: Verify we landed on the Login page with the success query string
            Assert.IsTrue(Page.Url.Contains("Login.aspx"));
            Assert.IsTrue(Page.Url.Contains("registered=true"));
        }

        [Test]
        public async Task Signup_WithEmptyFields_ShouldShowErrorMessage()
        {
            // Note: This assumes your stored procedure (sp_RegisterUser) or database constraints 
            // return an error when inserting blank data. If you have HTML5 "required" attributes 
            // on your textboxes, Playwright might get blocked by the browser before the C# even runs!

            // Arrange: Go to the page (leaving fields blank)
            await Page.GotoAsync(SignupUrl);

            // Act: Click signup
            await Page.ClickAsync("#btnSignup");

            // Assert: Verify the error panel becomes visible and has text
            var messageLocator = Page.Locator("#lblMessage");
            var isVisible = await messageLocator.IsVisibleAsync();
            var messageText = await messageLocator.InnerTextAsync();

            Assert.IsTrue(isVisible, "The error message panel should become visible.");
            Assert.IsNotEmpty(messageText, "The error label should contain text.");
        }

        [Test]
        public async Task GoogleSignupButton_Click_ShouldRedirectToGoogleServers()
        {
            // Arrange: Go to the signup page
            await Page.GotoAsync(SignupUrl);

            // Act: Click the Google signup button
            await Page.RunAndWaitForNavigationAsync(async () =>
            {
                await Page.ClickAsync("#btnGoogleSignup");
            });

            // Assert: Verify your C# code correctly generated the URL and redirected the user
            Assert.IsTrue(Page.Url.StartsWith("https://accounts.google.com/o/oauth2"));
            Assert.IsTrue(Page.Url.Contains("response_type=code"));
        }
    }
}