<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="instent_claim.Signup" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign Up | AutoLens - Vehicle Insurance Claim System</title>
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
            --accent-orange: #ff9e00;
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

        .signup-wrapper {
            display: flex;
            width: 100%;
            max-width: 1200px;
            min-height: 700px;
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

        .signup-side {
            flex: 1;
            background: white;
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .signup-header {
            margin-bottom: 40px;
            text-align: center;
        }

        .signup-header h2 {
            color: var(--primary-dark);
            font-size: 32px;
            margin-bottom: 10px;
        }

        .signup-header p {
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

        .form-group label.required::after {
            content: " *";
            color: #ff6b6b;
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

        .password-strength {
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .strength-bar {
            flex: 1;
            height: 4px;
            background: #e0e0e0;
            border-radius: 2px;
            overflow: hidden;
        }

        .strength-fill {
            height: 100%;
            width: 0%;
            border-radius: 2px;
            transition: width 0.3s, background 0.3s;
        }

        .strength-text {
            font-size: 12px;
            font-weight: 500;
        }

        .btn-signup {
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
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-signup:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(67, 97, 238, 0.3);
        }

        .btn-signup:active {
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
            text-decoration: none;
        }

        .btn-google:hover {
            border-color: #ddd;
            background: #f8f9fa;
            transform: translateY(-1px);
            text-decoration: none;
        }

        .btn-google i {
            color: #DB4437;
            font-size: 18px;
        }

        .login-link {
            text-align: center;
            margin-top: 30px;
            color: #666;
            font-size: 15px;
        }

        .login-link a {
            color: var(--primary-blue);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        .login-link a:hover {
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

        .validator {
            color: #d32f2f;
            font-size: 12px;
            margin-top: 5px;
            display: block;
            font-weight: 500;
        }

        .terms-agreement {
            margin: 20px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            font-size: 14px;
        }

        .terms-checkbox {
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }

        .terms-checkbox input[type="checkbox"] {
            margin-top: 3px;
        }

        .terms-text {
            color: #666;
            line-height: 1.5;
        }

        .terms-text a {
            color: var(--primary-blue);
            text-decoration: none;
            font-weight: 500;
        }

        .terms-text a:hover {
            text-decoration: underline;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        @media (max-width: 1024px) {
            .signup-wrapper {
                max-width: 900px;
            }
        }

        @media (max-width: 900px) {
            .signup-wrapper {
                flex-direction: column;
                max-width: 500px;
            }
            
            .brand-side {
                padding: 40px 30px;
            }
            
            .signup-side {
                padding: 40px 30px;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }
        }

        @media (max-width: 480px) {
            .signup-wrapper {
                border-radius: 16px;
            }
            
            .brand-side, .signup-side {
                padding: 30px 20px;
            }
            
            .brand-side h1 {
                font-size: 28px;
            }
            
            .signup-header h2 {
                font-size: 26px;
            }
        }

        .progress-steps {
            display: flex;
            justify-content: space-between;
            margin-bottom: 40px;
            position: relative;
        }

        .progress-steps::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 0;
            right: 0;
            height: 2px;
            background: #e0e0e0;
            z-index: 1;
        }

        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            z-index: 2;
        }

        .step-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e0e0e0;
            color: #666;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-bottom: 10px;
            border: 4px solid white;
            transition: all 0.3s ease;
        }

        .step.active .step-circle {
            background: var(--primary-blue);
            color: white;
        }

        .step.completed .step-circle {
            background: var(--accent-teal);
            color: white;
        }

        .step-text {
            font-size: 12px;
            color: #666;
            font-weight: 500;
        }

        .step.active .step-text {
            color: var(--primary-blue);
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="background-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
    </div>
    
    <form id="form1" runat="server">
        <div class="signup-wrapper">
            <!-- Brand/Info Side -->
            <div class="brand-side">
                <div class="brand-logo">
                    <i class="fas fa-car-crash"></i>
                    AutoLens
                </div>
                <div class="brand-content">
                    <h1>Join AutoLens Today</h1>
                    <p>Experience intelligent vehicle insurance claim processing powered by AI. Get started in just a few steps.</p>
                    
                    <ul class="features">
                        <li><i class="fas fa-bolt"></i> Instant claim predictions</li>
                        <li><i class="fas fa-shield-alt"></i> Bank-level security</li>
                        <li><i class="fas fa-chart-line"></i> Real-time analytics</li>
                        <li><i class="fas fa-mobile-alt"></i> Mobile-friendly interface</li>
                        <li><i class="fas fa-headset"></i> 24/7 customer support</li>
                    </ul>

                    <div class="testimonial" style="margin-top: 40px; padding: 20px; background: rgba(255,255,255,0.1); border-radius: 10px;">
                        <p style="font-style: italic; margin-bottom: 10px;">"AutoLens reduced our claim processing time by 70%. Highly recommended!"</p>
                        <p style="font-size: 14px; opacity: 0.9;">— Insurance Partner</p>
                    </div>
                </div>
            </div>
            
            <!-- Signup Form Side -->
            <div class="signup-side">
                <div class="signup-header">
                    <h2>Create Account</h2>
                    <p>Start your journey with AutoLens</p>
                </div>

                <!-- Progress Steps -->
                <div class="progress-steps">
                    <div class="step active">
                        <div class="step-circle">1</div>
                        <div class="step-text">Account</div>
                    </div>
                    <div class="step">
                        <div class="step-circle">2</div>
                        <div class="step-text">Verification</div>
                    </div>
                    <div class="step">
                        <div class="step-circle">3</div>
                        <div class="step-text">Complete</div>
                    </div>
                </div>

                <asp:Panel ID="pnlMessage" runat="server" Visible="false">
                    <asp:Label ID="lblMessage" runat="server" CssClass="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                    </asp:Label>
                </asp:Panel>

                <!-- Full Name -->
                <div class="form-group">
                    <label for="txtFullName" class="required">Full Name</label>
                    <div class="input-with-icon">
                        <i class="fas fa-user"></i>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter your full name"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtFullName"
                        ErrorMessage="Full name is required" CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label for="txtEmail" class="required">Email Address</label>
                    <div class="input-with-icon">
                        <i class="fas fa-envelope"></i>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="Enter your email"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required" CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                        ErrorMessage="Please enter a valid email address" CssClass="validator" Display="Dynamic"></asp:RegularExpressionValidator>
                </div>

                <!-- Phone Number -->
                <div class="form-group">
                    <label for="txtPhoneNumber">Phone Number</label>
                    <div class="input-with-icon">
                        <i class="fas fa-phone"></i>
                        <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control" placeholder="Enter your phone number"></asp:TextBox>
                    </div>
                    <asp:RegularExpressionValidator ID="revPhoneNumber" runat="server" ControlToValidate="txtPhoneNumber"
                        ValidationExpression="^[+]?[\d\s\-\(\)]+$"
                        ErrorMessage="Please enter a valid phone number" CssClass="validator" Display="Dynamic"></asp:RegularExpressionValidator>
                </div>

                <!-- Password -->
                <div class="form-group">
                    <label for="txtPassword" class="required">Password</label>
                    <div class="input-with-icon">
                        <i class="fas fa-lock"></i>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Create a strong password"></asp:TextBox>
                        <button type="button" class="password-toggle" id="togglePassword">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <div class="password-strength">
                        <div class="strength-bar">
                            <div class="strength-fill" id="passwordStrengthBar"></div>
                        </div>
                        <span class="strength-text" id="passwordStrengthText">Weak</span>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                        ErrorMessage="Password is required" CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword"
                        ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
                        ErrorMessage="Password must be at least 8 characters with uppercase, lowercase, number, and special character" CssClass="validator" Display="Dynamic"></asp:RegularExpressionValidator>
                </div>

                <!-- Confirm Password -->
                <div class="form-group">
                    <label for="txtConfirmPassword" class="required">Confirm Password</label>
                    <div class="input-with-icon">
                        <i class="fas fa-lock"></i>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Confirm your password"></asp:TextBox>
                        <button type="button" class="password-toggle" id="toggleConfirmPassword">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Please confirm your password" CssClass="validator" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtPassword" ErrorMessage="Passwords do not match" CssClass="validator"
                        Display="Dynamic"></asp:CompareValidator>
                </div>

                <!-- Terms Agreement -->
                <div class="terms-agreement">
                    <div class="terms-checkbox">
                        <asp:CheckBox ID="cbTerms" runat="server" />
                        <div class="terms-text">
                            I agree to the <a href="Terms.aspx">Terms of Service</a> and <a href="Privacy.aspx">Privacy Policy</a>. 
                            I understand that my data will be processed in accordance with AutoLens's privacy policy.
                        </div>
                    </div>
                
                        CssClass="validator" Display="Dynamic" OnServerValidate="ValidateTerms"></asp:CustomValidator>
                </div>

                <!-- Signup Button -->
                <asp:LinkButton ID="btnSignup" runat="server" CssClass="btn-signup" OnClick="btnSignup_Click">
                    <i class="fas fa-user-plus"></i>
                    <span>Create Account</span>
                </asp:LinkButton>

                <div class="divider">
                    <span>Or sign up with</span>
                </div>

                <!-- Google Signup -->
                <asp:LinkButton ID="btnGoogleSignup" runat="server" CssClass="btn-google" OnClick="btnGoogleSignup_Click" CausesValidation="false">
                    <i class="fab fa-google"></i>
                    <span>Sign up with Google</span>
                </asp:LinkButton>

                <div class="login-link">
                    Already have an account? <a href="Login.aspx">Sign in here</a>
                </div>
            </div>
        </div>
    </form>
    
    <script>
        // Toggle password visibility
        const togglePassword = document.getElementById('togglePassword');
        const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
        const passwordField = document.getElementById('<%= txtPassword.ClientID %>');
        const confirmPasswordField = document.getElementById('<%= txtConfirmPassword.ClientID %>');

        if (togglePassword && passwordField) {
            togglePassword.addEventListener('click', function() {
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
        }

        if (toggleConfirmPassword && confirmPasswordField) {
            toggleConfirmPassword.addEventListener('click', function() {
                const icon = this.querySelector('i');
                if (confirmPasswordField.type === 'password') {
                    confirmPasswordField.type = 'text';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                } else {
                    confirmPasswordField.type = 'password';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                }
            });
        }

        // Password strength meter
        if (passwordField) {
            passwordField.addEventListener('input', function() {
                const password = this.value;
                const strengthBar = document.getElementById('passwordStrengthBar');
                const strengthText = document.getElementById('passwordStrengthText');
                
                let strength = 0;
                let color = '#ff6b6b';
                let text = 'Weak';
                
                // Check password strength
                if (password.length >= 8) strength++;
                if (/[a-z]/.test(password)) strength++;
                if (/[A-Z]/.test(password)) strength++;
                if (/[0-9]/.test(password)) strength++;
                if (/[^A-Za-z0-9]/.test(password)) strength++;
                
                // Update UI based on strength
                switch(strength) {
                    case 0:
                    case 1:
                        color = '#ff6b6b';
                        text = 'Weak';
                        strengthBar.style.width = '20%';
                        break;
                    case 2:
                    case 3:
                        color = '#ff9e00';
                        text = 'Fair';
                        strengthBar.style.width = '40%';
                        break;
                    case 4:
                        color = '#ffd166';
                        text = 'Good';
                        strengthBar.style.width = '60%';
                        break;
                    case 5:
                        color = '#06d6a0';
                        text = 'Strong';
                        strengthBar.style.width = '80%';
                        break;
                    case 6:
                        color = '#118ab2';
                        text = 'Very Strong';
                        strengthBar.style.width = '100%';
                        break;
                }
                
                strengthBar.style.background = color;
                strengthText.textContent = text;
                strengthText.style.color = color;
            });
        }

        // Form validation feedback
        const form = document.getElementById('form1');
        const inputs = form.querySelectorAll('.form-control');
        
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                if (this.value.trim() === '') {
                    this.classList.add('invalid');
                } else {
                    this.classList.remove('invalid');
                }
            });
            
            input.addEventListener('input', function() {
                this.classList.remove('invalid');
            });
        });

        // Terms checkbox validation
        const termsCheckbox = document.getElementById('<%= cbTerms.ClientID %>');
        if (termsCheckbox) {
            termsCheckbox.addEventListener('change', function() {
                const termsLabel = this.parentElement.parentElement;
                if (this.checked) {
                    termsLabel.classList.remove('invalid-terms');
                } else {
                    termsLabel.classList.add('invalid-terms');
                }
            });
        }

        // Simulate progress steps
        const steps = document.querySelectorAll('.step');
        if (steps.length > 0) {
            setTimeout(() => {
                steps[0].classList.add('completed');
                steps[1].classList.add('active');
            }, 1000);
        }
    </script>
</body>
</html>