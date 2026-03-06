using System;
using NUnit.Framework;
using instent_claim.data; // Matches your class namespace

namespace Predict_Test
{
    [TestFixture]
    public class GoogleOAuthHelperTests
    {
        [Test]
        public void GetAuthorizationUrl_ShouldReturnCorrectlyFormattedUrl()
        {
            // Act
            string url = GoogleOAuthHelper.GetAuthorizationUrl();

            // Assert
            Assert.IsNotNull(url);
            Assert.IsTrue(url.StartsWith("https://accounts.google.com/o/oauth2/v2/auth"));
            Assert.IsTrue(url.Contains("response_type=code"));
            Assert.IsTrue(url.Contains("prompt=consent"));
            Assert.IsTrue(url.Contains("access_type=offline"));
        }

        [Test]
        public void ExchangeCodeForToken_WithInvalidCode_ShouldThrowException()
        {
            // Arrange
            string fakeCode = "invalid_auth_code_12345";

            // Act & Assert
            // We expect an Exception because Google will reject our fake code
            Exception ex = Assert.Throws<Exception>(() =>
                GoogleOAuthHelper.ExchangeCodeForToken(fakeCode)
            );

            // Verify our custom error message from the catch block is working
            Assert.IsTrue(ex.Message.Contains("Token exchange failed"));
        }

        [Test]
        public void GetUserInfo_WithInvalidToken_ShouldThrowException()
        {
            // Arrange
            string fakeToken = "invalid_access_token_12345";

            // Act & Assert
            // We expect an Exception because Google will reject our fake token
            Exception ex = Assert.Throws<Exception>(() =>
                GoogleOAuthHelper.GetUserInfo(fakeToken)
            );

            // Verify our custom error message from the catch block is working
            Assert.IsTrue(ex.Message.Contains("Failed to get user info"));
        }
    }
}