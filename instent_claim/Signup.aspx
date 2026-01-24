
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="instent_claim.Signup" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign Up - Vehicle Insurance Claim System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .signup-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 450px;
        }

        .signup-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .signup-header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .signup-header p {
            color: #666;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }

        .validator {
            color: #c33;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }

        .btn-signup {
            width: 100%;
            padding: 12px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-signup:hover {
            background: #5568d3;
        }

        .divider {
            text-align: center;
            margin: 25px 0;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            width: 45%;
            height: 1px;
            background: #ddd;
        }

        .divider::after {
            content: '';
            position: absolute;
            right: 0;
            top: 50%;
            width: 45%;
            height: 1px;
            background: #ddd;
        }

        .divider span {
            color: #666;
            font-size: 14px;
        }

        .btn-google {
            width: 100%;
            padding: 12px;
            background: white;
            color: #333;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: background 0.3s;
        }

        .btn-google:hover {
            background: #f8f8f8;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
            font-size: 14px;
        }

        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .error-message {
            background: #fee;
            color: #c33;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="signup-container">
            <div class="signup-header">
                <h1>Create Account</h1>
                <p>Vehicle Insurance Claim Prediction System</p>
            </div>

            <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                <asp:Label ID="lblMessage" runat="server" CssClass="error-message"></asp:Label>
            </asp:Panel>

            <div class="form-group">
                <label for="txtFullName">Full Name</label>
                <asp:TextBox ID="txtFullName" runat="server" placeholder="Enter your full name"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtFullName"
                    ErrorMessage="Full name is required" CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="txtEmail">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required" CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Invalid email format" CssClass="validator" Display="Dynamic"
                    ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"></asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label for="txtPhoneNumber">Phone Number (Optional)</label>
                <asp:TextBox ID="txtPhoneNumber" runat="server" placeholder="Enter your phone number"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtPassword">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Create a password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Password is required" CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Password must be at least 6 characters" CssClass="validator" Display="Dynamic"
                    ValidationExpression=".{6,}"></asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label for="txtConfirmPassword">Confirm Password</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirm your password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                    ErrorMessage="Please confirm your password" CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword"
                    ControlToCompare="txtPassword" ErrorMessage="Passwords do not match" CssClass="validator"
                    Display="Dynamic"></asp:CompareValidator>
            </div>

            <asp:Button ID="btnSignup" runat="server" Text="Create Account" CssClass="btn-signup" OnClick="btnSignup_Click" />

            <div class="divider">
                <span>OR</span>
            </div>

            <asp:Button ID="btnGoogleSignup" runat="server" Text="🔍 Sign up with Google" CssClass="btn-google"
                OnClick="btnGoogleSignup_Click" CausesValidation="false" />

            <div class="login-link">
                Already have an account? <a href="Login.aspx">Login here</a>
            </div>
        </div>
    </form>
</body>
</html>