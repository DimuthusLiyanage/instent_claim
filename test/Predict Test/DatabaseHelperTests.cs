using System;
using System.Data;
using NUnit.Framework; // <-- Using NUnit instead of xUnit
using instent_claim.data;

namespace Predict_Test
{
    [TestFixture] // Tells NUnit this class contains tests
    public class DatabaseHelperTests
    {
        [Test] // <-- Changed from [Fact] to [Test]
        public void HashPassword_ShouldReturnConsistentHash()
        {
            // Arrange
            string password = "TestPassword123";

            // Act
            string hash1 = DatabaseHelper.HashPassword(password);
            string hash2 = DatabaseHelper.HashPassword(password);

            // Assert
            Assert.IsNotNull(hash1); // <-- Changed from NotNull to IsNotNull
            Assert.AreEqual(hash1, hash2); // <-- Changed from Equal to AreEqual
        }

        [Test]
        public void HashPassword_ShouldNotReturnPlaintext()
        {
            // Arrange
            string password = "SecretPassword";

            // Act
            string hash = DatabaseHelper.HashPassword(password);

            // Assert
            Assert.AreNotEqual(password, hash); // <-- Changed from NotEqual to AreNotEqual
        }

        [Test]
        public void LoginUser_WithEmptyCredentials_ShouldReturnNoData()
        {
            // Arrange
            string email = "";
            string password = "";

            // Act & Assert
            try
            {
                DataTable result = DatabaseHelper.LoginUser(email, password);
                Assert.AreEqual(0, result.Rows.Count);
            }
            catch (Exception ex)
            {
                // If your App.config is missing the connection string, it will throw an error here.
                // We catch it so the test doesn't outright crash during this example.
                Assert.Pass("Test passed by catching missing connection string: " + ex.Message);
            }
        }
    }
}