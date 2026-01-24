<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="instent_claim.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login | AutoLens - Vehicle Insurance Claim System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        :root {
            --primary-blue: #4361ee;
            --primary-dark: #1a1a2e;
            --accent-teal: #06d6a0;
            --light-bg: #f8f9fa;
            --card-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            --input-border: #e0e0e0;
            --gradient-primary: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            --gradient-accent: linear-gradient(135deg, #06d6a0 0%, #118ab2 100%);
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
        }

        .background-shapes {
            position: absolute;
            width: 100%;
            height: 100%;
            z-index: -1;
            overflow: hidden;
        }

        .shape {
            position: absolute;
            border-radius: 50%;
            opacity: 0.1;
        }

        .shape-1 {
            width: 300px;
            height: 300px;
            background: var(--primary-blue);
            top: -100px;
            right: -100px;
        }

        .shape-2 {
            width: 200px;
            height: 200px;
            background: var(--accent-teal);
            bottom: -80px;
            left: -80px;
        }

        .login-wrapper {
            display: flex;
            width: 100%;
            max-width: 1000px;
            min-height: 600px;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            animation: fadeIn 0.8s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .brand-side {
            flex: 1;
            background: var(--gradient-primary);
            padding: 60px 40px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .brand-side::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="none" opacity="0.05"><path d="M0,0 L100,0 L100,100 Z" fill="white"/></svg>');
            background-size: cover;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            margin-bottom: 40px;
            font-size: 28px;
            font-weight: 700;
            z-index: 1;
        }

        .brand-logo i {
            margin-right: 15px;
            font-size: 36px;
            background: white;
            color: var(--primary-blue);
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .brand-content {
            z-index: 1;
            position: relative;
        }

        .brand-side h1 {
            font-size: 36px;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .brand-side p {
            font-size: 18px;
            line-height: 1.6;
            opacity: 0.9;
            margin-bottom: 30px;
        }

        .features {
            list-style: none;
            margin-top: 30px;
        }

        .features li {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .features i {
            background: rgba(255, 255, 255, 0.2);
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }

        .login-side {
            flex: 1;
            background: white;
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-header {
            margin-bottom: 40px;
            text-align: center;
        }

        .login-header h2 {
            color: var(--primary-dark);
            font-size: 32px;
            margin-bottom: 10px;
        }

        .login-header p {
            color: #666;
            font-size: 16px;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #444;
            font-weight: 500;
            font-size: 15px;
        }

        .input-with-icon {
            position: relative;
        }

        .input-with-icon i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #777;
            z-index: 1;
        }

        .form-control {
            width: 100%;
            padding: 14px 14px 14px 45px;
            border: 2px solid var(--input-border);
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: white;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15);
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #777;
            cursor: pointer;
            z-index: 2;
        }

        .btn-login {
            width: 100%;
            padding: 16px;
            background: var(--gradient-primary);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            letter-spacing: 0.5px;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(67, 97, 238, 0.3);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 30px 0;
            color: #888;
        }

        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #eee;
        }

        .divider span {
            padding: 0 15px;
            font-size: 14px;
        }

        .btn-google {
            width: 100%;
            padding: 14px;
            background: white;
            color: #444;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            transition: all 0.3s ease;
        }

        .btn-google:hover {
            border-color: #ddd;
            background: #f8f9fa;
            transform: translateY(-1px);
        }

        .btn-google i {
            color: #DB4437;
            font-size: 18px;
        }

        .signup-link {
            text-align: center;
            margin-top: 30px;
            color: #666;
            font-size: 15px;
        }

        .signup-link a {
            color: var(--primary-blue);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        .signup-link a:hover {
            color: #3a0ca3;
            text-decoration: underline;
        }

        .error-message {
            background: #ffeaea;
            color: #d32f2f;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
            border-left: 4px solid #d32f2f;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .error-message i {
            font-size: 18px;
        }

        .success-message {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
            border-left: 4px solid #2e7d32;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .remember-forgot {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
            font-size: 14px;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .forgot-password {
            color: var(--primary-blue);
            text-decoration: none;
        }

        .forgot-password:hover {
            text-decoration: underline;
        }

        @media (max-width: 900px) {
            .login-wrapper {
                flex-direction: column;
                max-width: 500px;
            }
            
            .brand-side {
                padding: 40px 30px;
            }
            
            .login-side {
                padding: 40px 30px;
            }
        }

        @media (max-width: 480px) {
            .login-wrapper {
                border-radius: 16px;
            }
            
            .brand-side, .login-side {
                padding: 30px 20px;
            }
            
            .brand-side h1 {
                font-size: 28px;
            }
            
            .login-header h2 {
                font-size: 26px;
            }
            
            .remember-forgot {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="background-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
    </div>
    
    <form id="form1" runat="server">
        <div class="login-wrapper">
            <!-- Brand/Info Side -->
            <div class="brand-side">
                <div class="brand-logo">
                    <i class="fas fa-car-crash"></i>
                    AutoLens
                </div>
                <div class="brand-content">
                    <h1>Intelligent Claim Processing</h1>
                    <p>AutoLens uses advanced AI to streamline your vehicle insurance claims. Get faster approvals and transparent tracking.</p>
                    
                    <ul class="features">
                        <li><i class="fas fa-bolt"></i> Fast claim processing</li>
                        <li><i class="fas fa-shield-alt"></i> Secure & reliable</li>
                        <li><i class="fas fa-chart-line"></i> Real-time tracking</li>
                        <li><i class="fas fa-headset"></i> 24/7 support</li>
                    </ul>
                </div>
            </div>
            
            <!-- Login Form Side -->
            <div class="login-side">
                <div class="login-header">
                    <h2>Welcome Back</h2>
                    <p>Sign in to your AutoLens account</p>
                </div>

                <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                    <asp:Label ID="lblMessage" runat="server" CssClass="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                    </asp:Label>
                </asp:Panel>

                <div class="form-group">
                    <label for="txtEmail">Email Address</label>
                    <div class="input-with-icon">
                        <i class="fas fa-envelope"></i>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="Enter your email"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                        ErrorMessage="Please enter a valid email address" ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <label for="txtPassword">Password</label>
                    <div class="input-with-icon">
                        <i class="fas fa-lock"></i>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password"></asp:TextBox>
                        <button type="button" class="password-toggle" id="togglePassword">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password is required" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>

                <div class="remember-forgot">
                    <div class="remember-me">
                        <asp:CheckBox ID="cbRememberMe" runat="server" />
                        <label for="cbRememberMe">Remember me</label>
                    </div>
                    <a href="ForgotPassword.aspx" class="forgot-password">Forgot password?</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn-login" OnClick="btnLogin_Click" />

                <div class="divider">
                    <span>Or continue with</span>
                </div>


             
                <asp:Button ID="btnGoogleLogin" runat="server" Text="Google"  CssClass="btn-google"
                    OnClick="btnGoogleLogin_Click" CausesValidation="false" class="fab fa-google" />
                <div class="signup-link">
                    Don't have an account? <a href="Signup.aspx">Create account</a>
                </div>
            </div>
        </div>
    </form>
    
    <script>
        // Toggle password visibility
        document.getElementById('togglePassword')?.addEventListener('click', function () {
            const passwordField = document.getElementById('<%= txtPassword.ClientID %>');
            const icon = this.querySelector('i');

            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });

        // Add focus effects to form controls
        const formControls = document.querySelectorAll('.form-control');
        formControls.forEach(control => {
            control.addEventListener('focus', function () {
                this.parentElement.parentElement.classList.add('focused');
            });

            control.addEventListener('blur', function () {
                this.parentElement.parentElement.classList.remove('focused');
            });
        });

        // Form validation feedback
        const form = document.getElementById('form1');
        form.addEventListener('submit', function () {
            const inputs = form.querySelectorAll('.form-control');
            inputs.forEach(input => {
                if (input.value.trim() === '') {
                    input.classList.add('invalid');
                } else {
                    input.classList.remove('invalid');
                }
            });
        });
    </script>
</body>
</html>