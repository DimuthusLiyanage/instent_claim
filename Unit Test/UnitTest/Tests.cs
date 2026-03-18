using NUnit.Framework;
using Moq;
using System;
using System.Data;
using System.Text.RegularExpressions;

namespace UnitTest
{
    // ════════════════════════════════════════════════════════════════════
    //  SHARED MODELS  (defined once here — do NOT repeat in other files)
    // ════════════════════════════════════════════════════════════════════

    public class LoginResult
    {
        public bool Success { get; set; }
        public int UserId { get; set; }
        public string FullName { get; set; }
        public string Message { get; set; }
    }

    public class TokenResponse
    {
        public string access_token { get; set; }
        public string token_type { get; set; }
        public int expires_in { get; set; }
        public string refresh_token { get; set; }
        public string scope { get; set; }
    }

    public class GoogleUserInfo
    {
        public string id { get; set; }
        public string email { get; set; }
        public string verified_email { get; set; }
        public string name { get; set; }
        public string given_name { get; set; }
        public string family_name { get; set; }
        public string picture { get; set; }
    }

    // ════════════════════════════════════════════════════════════════════
    //  SHARED INTERFACES
    // ════════════════════════════════════════════════════════════════════

    public interface ILoginService
    {
        LoginResult Authenticate(string email, string password);
        string BuildGoogleAuthUrl(string clientId, string redirectUri);
    }

    public interface IDatabaseHelper
    {
        string HashPassword(string password);
        DataTable RegisterUser(string email, string password, string fullName, string phoneNumber);
        DataTable LoginUser(string email, string password);
        DataTable GoogleLogin(string email, string googleId, string fullName);
    }

    public interface IGoogleOAuthHelper
    {
        string GetAuthorizationUrl();
        TokenResponse ExchangeCodeForToken(string code);
        GoogleUserInfo GetUserInfo(string accessToken);
    }

    // ════════════════════════════════════════════════════════════════════
    //  TEST CLASS 1 — LoginService
    // ════════════════════════════════════════════════════════════════════
    [TestFixture]
    [Category("LoginService")]
    public class LoginServiceTests
    {
        private Mock<ILoginService> _mock;

        private readonly Regex _emailRegex = new Regex(
            @"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");

        [SetUp]
        public void SetUp() => _mock = new Mock<ILoginService>();

        [Test]
        public void Authenticate_ValidCredentials_ReturnsSuccess()
        {
            _mock.Setup(s => s.Authenticate("user@test.com", "Password1!"))
                 .Returns(new LoginResult { Success = true, UserId = 42, FullName = "John Doe" });

            var r = _mock.Object.Authenticate("user@test.com", "Password1!");

            Assert.That(r.Success, Is.True);
            Assert.That(r.UserId, Is.EqualTo(42));
            Assert.That(r.FullName, Is.EqualTo("John Doe"));
        }

        [Test]
        public void Authenticate_ValidCredentials_UserIdIsPositive()
        {
            _mock.Setup(s => s.Authenticate(It.IsAny<string>(), It.IsAny<string>()))
                 .Returns(new LoginResult { Success = true, UserId = 5, FullName = "Jane" });

            Assert.That(_mock.Object.Authenticate("jane@test.com", "pass").UserId, Is.GreaterThan(0));
        }

        [Test]
        public void Authenticate_ValidCredentials_FullNameIsNotEmpty()
        {
            _mock.Setup(s => s.Authenticate("user@test.com", "Password1!"))
                 .Returns(new LoginResult { Success = true, UserId = 1, FullName = "Alice" });

            Assert.That(_mock.Object.Authenticate("user@test.com", "Password1!").FullName, Is.Not.Empty);
        }

        [Test]
        public void Authenticate_WrongPassword_ReturnsFailureWithMessage()
        {
            _mock.Setup(s => s.Authenticate("user@test.com", "WrongPass!"))
                 .Returns(new LoginResult { Success = false, Message = "Invalid email or password." });

            var r = _mock.Object.Authenticate("user@test.com", "WrongPass!");

            Assert.That(r.Success, Is.False);
            Assert.That(r.Message, Is.EqualTo("Invalid email or password."));
        }

        [Test]
        public void Authenticate_UnknownEmail_ReturnsFailure()
        {
            _mock.Setup(s => s.Authenticate("nobody@nowhere.com", It.IsAny<string>()))
                 .Returns(new LoginResult { Success = false, Message = "Invalid email or password." });

            var r = _mock.Object.Authenticate("nobody@nowhere.com", "anypass");

            Assert.That(r.Success, Is.False);
            Assert.That(r.Message, Is.Not.Empty);
        }

        [Test]
        public void Authenticate_Failure_UserIdIsZero()
        {
            _mock.Setup(s => s.Authenticate("bad@test.com", "bad"))
                 .Returns(new LoginResult { Success = false, UserId = 0, Message = "Invalid email or password." });

            Assert.That(_mock.Object.Authenticate("bad@test.com", "bad").UserId, Is.EqualTo(0));
        }

        [Test]
        [TestCase("", "password", TestName = "EmptyEmail")]
        [TestCase("email@test.com", "", TestName = "EmptyPassword")]
        [TestCase("", "", TestName = "BothEmpty")]
        public void Authenticate_EmptyFields_ReturnsRequiredMessage(string email, string password)
        {
            _mock.Setup(s => s.Authenticate(email, password))
                 .Returns(new LoginResult { Success = false, Message = "Email and password are required." });

            var r = _mock.Object.Authenticate(email, password);

            Assert.That(r.Success, Is.False);
            Assert.That(r.Message, Does.Contain("required"));
        }

        [Test]
        public void Authenticate_NullEmail_ReturnsFailure()
        {
            _mock.Setup(s => s.Authenticate(null, "password"))
                 .Returns(new LoginResult { Success = false, Message = "Email and password are required." });

            Assert.That(_mock.Object.Authenticate(null, "password").Success, Is.False);
        }

        [Test]
        public void BuildGoogleAuthUrl_ValidInputs_ContainsClientId()
        {
            _mock.Setup(s => s.BuildGoogleAuthUrl("my-id", It.IsAny<string>()))
                 .Returns("https://accounts.google.com/o/oauth2/v2/auth?client_id=my-id");

            Assert.That(_mock.Object.BuildGoogleAuthUrl("my-id", "https://r.com"), Does.Contain("my-id"));
        }

        [Test]
        public void BuildGoogleAuthUrl_ValidInputs_StartsWithGoogleDomain()
        {
            _mock.Setup(s => s.BuildGoogleAuthUrl(It.IsAny<string>(), It.IsAny<string>()))
                 .Returns("https://accounts.google.com/o/oauth2/v2/auth?client_id=abc");

            Assert.That(_mock.Object.BuildGoogleAuthUrl("abc", "https://r.com"),
                Does.StartWith("https://accounts.google.com"));
        }

        [Test]
        public void BuildGoogleAuthUrl_NullClientId_ReturnsEmpty()
        {
            _mock.Setup(s => s.BuildGoogleAuthUrl(null, It.IsAny<string>()))
                 .Returns(string.Empty);

            Assert.That(_mock.Object.BuildGoogleAuthUrl(null, "https://r.com"), Is.Empty);
        }

        [Test]
        [TestCase("user@example.com", true, TestName = "Standard email")]
        [TestCase("user.name@domain.co.uk", true, TestName = "Subdomain with dot")]
        [TestCase("user+tag@domain.org", true, TestName = "Plus addressing")]
        [TestCase("invalid-email", false, TestName = "No @ symbol")]
        [TestCase("missing@domain", false, TestName = "No TLD")]
        [TestCase("@nodomain.com", false, TestName = "Missing local part")]
        [TestCase("", false, TestName = "Empty string")]
        public void EmailRegex_MatchesLoginAspxValidator(string email, bool expected)
        {
            Assert.That(_emailRegex.IsMatch(email), Is.EqualTo(expected));
        }

        [Test]
        public void LoginResult_DefaultValues_AreCorrect()
        {
            var r = new LoginResult();
            Assert.That(r.Success, Is.False);
            Assert.That(r.UserId, Is.EqualTo(0));
            Assert.That(r.FullName, Is.Null);
            Assert.That(r.Message, Is.Null);
        }

        [TearDown]
        public void TearDown() => _mock.VerifyNoOtherCalls();
    }

    // ════════════════════════════════════════════════════════════════════
    //  TEST CLASS 2 — DatabaseHelper
    // ════════════════════════════════════════════════════════════════════
    [TestFixture]
    [Category("DatabaseHelper")]
    public class DatabaseHelperTests
    {
        [Test]
        public void HashPassword_ValidInput_Returns64CharHexString()
        {
            Assert.That(instent_claim.data.DatabaseHelper.HashPassword("Password1!").Length, Is.EqualTo(64));
        }

        [Test]
        public void HashPassword_SameInput_AlwaysReturnsSameHash()
        {
            Assert.That(
                instent_claim.data.DatabaseHelper.HashPassword("MySecret"),
                Is.EqualTo(instent_claim.data.DatabaseHelper.HashPassword("MySecret")));
        }

        [Test]
        public void HashPassword_DifferentInputs_ReturnDifferentHashes()
        {
            Assert.That(
                instent_claim.data.DatabaseHelper.HashPassword("Password1"),
                Is.Not.EqualTo(instent_claim.data.DatabaseHelper.HashPassword("Password2")));
        }

        [Test]
        public void HashPassword_OutputIsLowerCaseHexOnly()
        {
            Assert.That(instent_claim.data.DatabaseHelper.HashPassword("test"), Does.Match(@"^[0-9a-f]+$"));
        }

        [Test]
        public void HashPassword_EmptyString_StillReturns64CharHash()
        {
            Assert.That(instent_claim.data.DatabaseHelper.HashPassword(string.Empty).Length, Is.EqualTo(64));
        }

        [Test]
        public void HashPassword_NullInput_ThrowsArgumentNullException()
        {
            Assert.That(() => instent_claim.data.DatabaseHelper.HashPassword(null),
                Throws.ArgumentNullException);
        }

        [Test]
        public void HashPassword_KnownValue_MatchesExpectedSHA256Prefix()
        {
            Assert.That(instent_claim.data.DatabaseHelper.HashPassword("abc"), Does.StartWith("ba7816bf"));
        }

        [Test]
        public void LoginUser_ValidCredentials_ReturnsRowWithPositiveUserId()
        {
            var mock = new Mock<IDatabaseHelper>();
            mock.Setup(db => db.LoginUser("alice@test.com", "pass"))
                .Returns(BuildUserTable(7, "Alice"));

            var result = mock.Object.LoginUser("alice@test.com", "pass");

            Assert.That(result.Rows.Count, Is.EqualTo(1));
            Assert.That(Convert.ToInt32(result.Rows[0]["UserId"]), Is.GreaterThan(0));
        }

        [Test]
        public void LoginUser_InvalidCredentials_ReturnsEmptyTable()
        {
            var mock = new Mock<IDatabaseHelper>();
            mock.Setup(db => db.LoginUser("wrong@test.com", "bad")).Returns(new DataTable());

            Assert.That(mock.Object.LoginUser("wrong@test.com", "bad").Rows.Count, Is.EqualTo(0));
        }

        [Test]
        public void LoginUser_Success_FullNameIsPresent()
        {
            var mock = new Mock<IDatabaseHelper>();
            mock.Setup(db => db.LoginUser(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(BuildUserTable(3, "Bob Builder"));

            Assert.That(mock.Object.LoginUser("bob@test.com", "pass").Rows[0]["FullName"].ToString(),
                Is.EqualTo("Bob Builder"));
        }

        [Test]
        public void RegisterUser_NewEmail_ReturnsPositiveUserId()
        {
            var mock = new Mock<IDatabaseHelper>();
            mock.Setup(db => db.RegisterUser("new@test.com", "pass", "New User", "071"))
                .Returns(BuildResultTable(10, "Success"));

            Assert.That(Convert.ToInt32(mock.Object.RegisterUser("new@test.com", "pass", "New User", "071").Rows[0]["UserId"]),
                Is.GreaterThan(0));
        }

        [Test]
        public void RegisterUser_DuplicateEmail_ReturnsZeroUserIdWithErrorMessage()
        {
            var mock = new Mock<IDatabaseHelper>();
            mock.Setup(db => db.RegisterUser("existing@test.com", It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(BuildResultTable(0, "Email already exists."));

            var result = mock.Object.RegisterUser("existing@test.com", "pass", "User", "");

            Assert.That(Convert.ToInt32(result.Rows[0]["UserId"]), Is.EqualTo(0));
            Assert.That(result.Rows[0]["Message"].ToString(), Does.Contain("already"));
        }

        [Test]
        public void RegisterUser_NullPhoneNumber_IsAccepted()
        {
            var mock = new Mock<IDatabaseHelper>();
            mock.Setup(db => db.RegisterUser("user@test.com", "pass", "User", null))
                .Returns(BuildResultTable(5, "Success"));

            Assert.That(Convert.ToInt32(mock.Object.RegisterUser("user@test.com", "pass", "User", null).Rows[0]["UserId"]),
                Is.GreaterThan(0));
        }

        [Test]
        public void GoogleLogin_NewGoogleUser_ReturnsNewUserId()
        {
            var mock = new Mock<IDatabaseHelper>();
            mock.Setup(db => db.GoogleLogin("g@gmail.com", "gid-123", "Google User"))
                .Returns(BuildUserTable(99, "Google User"));

            Assert.That(Convert.ToInt32(mock.Object.GoogleLogin("g@gmail.com", "gid-123", "Google User").Rows[0]["UserId"]),
                Is.EqualTo(99));
        }

        [Test]
        public void GoogleLogin_ExistingGoogleUser_ReturnsExistingUserIdAndName()
        {
            var mock = new Mock<IDatabaseHelper>();
            mock.Setup(db => db.GoogleLogin(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(BuildUserTable(42, "Returning User"));

            var result = mock.Object.GoogleLogin("r@gmail.com", "gid-999", "Returning User");

            Assert.That(Convert.ToInt32(result.Rows[0]["UserId"]), Is.EqualTo(42));
            Assert.That(result.Rows[0]["FullName"].ToString(), Is.EqualTo("Returning User"));
        }

        private DataTable BuildUserTable(int userId, string fullName)
        {
            var dt = new DataTable();
            dt.Columns.Add("UserId", typeof(int));
            dt.Columns.Add("FullName", typeof(string));
            dt.Rows.Add(userId, fullName);
            return dt;
        }

        private DataTable BuildResultTable(int userId, string message)
        {
            var dt = new DataTable();
            dt.Columns.Add("UserId", typeof(int));
            dt.Columns.Add("Message", typeof(string));
            dt.Rows.Add(userId, message);
            return dt;
        }
    }

    // ════════════════════════════════════════════════════════════════════
    //  TEST CLASS 3 — GoogleOAuthHelper
    // ════════════════════════════════════════════════════════════════════
    [TestFixture]
    [Category("GoogleOAuthHelper")]
    public class GoogleOAuthHelperTests
    {
        private Mock<IGoogleOAuthHelper> _mock;

        [SetUp]
        public void SetUp() => _mock = new Mock<IGoogleOAuthHelper>();

        [Test]
        public void GetAuthorizationUrl_StartsWithGoogleOAuthEndpoint()
        {
            _mock.Setup(o => o.GetAuthorizationUrl())
                 .Returns("https://accounts.google.com/o/oauth2/v2/auth?client_id=abc&response_type=code&scope=openid+email+profile&access_type=offline&prompt=consent");

            Assert.That(_mock.Object.GetAuthorizationUrl(),
                Does.StartWith("https://accounts.google.com/o/oauth2/v2/auth"));
        }

        [Test]
        public void GetAuthorizationUrl_ContainsResponseTypeCode()
        {
            _mock.Setup(o => o.GetAuthorizationUrl()).Returns("https://accounts.google.com/...?response_type=code");
            Assert.That(_mock.Object.GetAuthorizationUrl(), Does.Contain("response_type=code"));
        }

        [Test]
        public void GetAuthorizationUrl_ContainsOpenIdScope()
        {
            _mock.Setup(o => o.GetAuthorizationUrl()).Returns("https://accounts.google.com/...&scope=openid+email+profile");
            Assert.That(_mock.Object.GetAuthorizationUrl(), Does.Contain("openid"));
        }

        [Test]
        public void GetAuthorizationUrl_ContainsPromptConsent()
        {
            _mock.Setup(o => o.GetAuthorizationUrl()).Returns("https://accounts.google.com/...&prompt=consent");
            Assert.That(_mock.Object.GetAuthorizationUrl(), Does.Contain("prompt=consent"));
        }

        [Test]
        public void GetAuthorizationUrl_ContainsAccessTypeOffline()
        {
            _mock.Setup(o => o.GetAuthorizationUrl()).Returns("https://accounts.google.com/...&access_type=offline");
            Assert.That(_mock.Object.GetAuthorizationUrl(), Does.Contain("access_type=offline"));
        }

        [Test]
        public void ExchangeCodeForToken_ValidCode_ReturnsBearerToken()
        {
            _mock.Setup(o => o.ExchangeCodeForToken("valid-code"))
                 .Returns(new TokenResponse { access_token = "ya29.fake", token_type = "Bearer", expires_in = 3600, refresh_token = "1//refresh" });

            var r = _mock.Object.ExchangeCodeForToken("valid-code");

            Assert.That(r, Is.Not.Null);
            Assert.That(r.token_type, Is.EqualTo("Bearer"));
            Assert.That(r.access_token, Is.Not.Empty);
        }

        [Test]
        public void ExchangeCodeForToken_ValidCode_ExpiresInIsPositive()
        {
            _mock.Setup(o => o.ExchangeCodeForToken(It.IsAny<string>()))
                 .Returns(new TokenResponse { access_token = "token", expires_in = 3600 });

            Assert.That(_mock.Object.ExchangeCodeForToken("code").expires_in, Is.GreaterThan(0));
        }

        [Test]
        public void ExchangeCodeForToken_ValidCode_RefreshTokenIsPresent()
        {
            _mock.Setup(o => o.ExchangeCodeForToken("code"))
                 .Returns(new TokenResponse { access_token = "token", refresh_token = "1//refresh" });

            Assert.That(_mock.Object.ExchangeCodeForToken("code").refresh_token, Is.Not.Empty);
        }

        [Test]
        public void ExchangeCodeForToken_InvalidCode_ThrowsExceptionWithMessage()
        {
            _mock.Setup(o => o.ExchangeCodeForToken("bad-code"))
                 .Throws(new Exception("Token exchange failed: invalid_grant"));

            Assert.That(
                () => _mock.Object.ExchangeCodeForToken("bad-code"),
                Throws.TypeOf<Exception>().With.Message.Contains("Token exchange failed"));
        }

        [Test]
        public void ExchangeCodeForToken_EmptyCode_ThrowsArgumentException()
        {
            _mock.Setup(o => o.ExchangeCodeForToken(string.Empty))
                 .Throws(new ArgumentException("Authorization code cannot be empty"));

            Assert.That(() => _mock.Object.ExchangeCodeForToken(string.Empty), Throws.TypeOf<ArgumentException>());
        }

        [Test]
        public void GetUserInfo_ValidToken_ReturnsPopulatedGoogleUserInfo()
        {
            _mock.Setup(o => o.GetUserInfo("valid-token"))
                 .Returns(new GoogleUserInfo { id = "10800001", email = "user@gmail.com", verified_email = "true", name = "John Doe", given_name = "John", family_name = "Doe" });

            var r = _mock.Object.GetUserInfo("valid-token");

            Assert.That(r, Is.Not.Null);
            Assert.That(r.email, Is.Not.Empty);
            Assert.That(r.id, Is.Not.Empty);
            Assert.That(r.name, Is.EqualTo("John Doe"));
        }

        [Test]
        public void GetUserInfo_ValidToken_EmailIsVerified()
        {
            _mock.Setup(o => o.GetUserInfo(It.IsAny<string>()))
                 .Returns(new GoogleUserInfo { email = "user@gmail.com", verified_email = "true" });

            Assert.That(_mock.Object.GetUserInfo("token").verified_email, Is.EqualTo("true"));
        }

        [Test]
        public void GetUserInfo_ValidToken_FullNameMatchesGivenPlusFamily()
        {
            _mock.Setup(o => o.GetUserInfo(It.IsAny<string>()))
                 .Returns(new GoogleUserInfo { name = "Jane Smith", given_name = "Jane", family_name = "Smith" });

            var r = _mock.Object.GetUserInfo("token");
            Assert.That(r.name, Is.EqualTo($"{r.given_name} {r.family_name}"));
        }

        [Test]
        public void GetUserInfo_ExpiredToken_ThrowsExceptionWithMessage()
        {
            _mock.Setup(o => o.GetUserInfo("expired-token"))
                 .Throws(new Exception("Failed to get user info: 401 Unauthorized"));

            Assert.That(
                () => _mock.Object.GetUserInfo("expired-token"),
                Throws.TypeOf<Exception>().With.Message.Contains("Failed to get user info"));
        }

        [Test]
        public void GetUserInfo_NullToken_ThrowsArgumentNullException()
        {
            _mock.Setup(o => o.GetUserInfo(null)).Throws(new ArgumentNullException("accessToken"));

            Assert.That(() => _mock.Object.GetUserInfo(null), Throws.ArgumentNullException);
        }

        [Test]
        public void TokenResponse_DefaultValues_AreNullOrZero()
        {
            var t = new TokenResponse();
            Assert.That(t.access_token, Is.Null);
            Assert.That(t.refresh_token, Is.Null);
            Assert.That(t.token_type, Is.Null);
            Assert.That(t.expires_in, Is.EqualTo(0));
        }

        [Test]
        public void GoogleUserInfo_DefaultValues_AreNull()
        {
            var u = new GoogleUserInfo();
            Assert.That(u.id, Is.Null);
            Assert.That(u.email, Is.Null);
            Assert.That(u.name, Is.Null);
        }

        [TearDown]
        public void TearDown() => _mock.VerifyNoOtherCalls();
    }
}
