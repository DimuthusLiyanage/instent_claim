<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="instent_claim.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard | AutoLens - Vehicle Insurance Claim System</title>
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
            --accent-purple: #7209b7;
            --light-bg: #f8f9fa;
            --card-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
            --sidebar-width: 260px;
            --header-height: 70px;
        }

        body {
            background: #f5f7fa;
            min-height: 100vh;
            display: flex;
            color: #333;
        }

        /* Sidebar Styles */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--primary-dark);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .sidebar-header {
            padding: 25px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 22px;
            font-weight: 700;
        }

        .sidebar-logo i {
            background: var(--primary-blue);
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .nav-menu {
            padding: 20px 0;
        }

        .nav-item {
            padding: 15px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .nav-item:hover, .nav-item.active {
            background: rgba(67, 97, 238, 0.1);
            color: white;
            border-left-color: var(--primary-blue);
        }

        .nav-item i {
            width: 20px;
            text-align: center;
        }

        .nav-item.active {
            background: rgba(67, 97, 238, 0.2);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            min-height: 100vh;
        }

        /* Header */
        .header {
            background: white;
            height: var(--header-height);
            padding: 0 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-left h1 {
            font-size: 22px;
            color: var(--primary-dark);
            font-weight: 600;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 15px;
            border-radius: 25px;
            background: var(--light-bg);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .user-profile:hover {
            background: #e9ecef;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 18px;
        }

        .user-info {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            font-weight: 600;
            color: var(--primary-dark);
        }

        .user-role {
            font-size: 12px;
            color: #666;
            margin-top: 2px;
        }

        .btn-logout {
            padding: 10px 20px;
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 107, 107, 0.3);
        }

        /* Dashboard Content */
        .dashboard-content {
            padding: 30px;
        }

        /* Welcome Banner */
        .welcome-banner {
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        .welcome-banner::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 200px;
            height: 200px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            transform: translate(30%, -30%);
        }

        .welcome-content h2 {
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .welcome-content p {
            font-size: 16px;
            opacity: 0.9;
            max-width: 600px;
        }

        .welcome-icon {
            font-size: 80px;
            opacity: 0.2;
            position: absolute;
            right: 40px;
            bottom: -20px;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }

        .stat-icon.purple { background: linear-gradient(135deg, #7209b7 0%, #560bad 100%); }
        .stat-icon.blue { background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%); }
        .stat-icon.teal { background: linear-gradient(135deg, #06d6a0 0%, #049f7a 100%); }
        .stat-icon.orange { background: linear-gradient(135deg, #ff9e00 0%, #ff8500 100%); }

        .stat-info h3 {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 5px;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 5px;
        }

        .stat-change {
            font-size: 12px;
            font-weight: 600;
        }

        .stat-change.positive { color: #06d6a0; }
        .stat-change.negative { color: #ff6b6b; }

        /* Feature Cards Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }

        .feature-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            border: 1px solid #f0f0f0;
        }

        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-blue), var(--accent-teal));
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            background: linear-gradient(135deg, rgba(67, 97, 238, 0.1) 0%, rgba(67, 97, 238, 0.2) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 25px;
            color: var(--primary-blue);
            font-size: 24px;
        }

        .feature-card h3 {
            font-size: 20px;
            color: var(--primary-dark);
            margin-bottom: 15px;
            font-weight: 600;
        }

        .feature-card p {
            color: #666;
            line-height: 1.6;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .feature-link {
            color: var(--primary-blue);
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .feature-link:hover {
            color: #3a0ca3;
            gap: 12px;
        }

        /* Quick Actions */
        .quick-actions {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-top: 30px;
            box-shadow: var(--card-shadow);
        }

        .section-title {
            font-size: 20px;
            color: var(--primary-dark);
            margin-bottom: 25px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
        }

        .action-btn {
            background: var(--light-bg);
            border: none;
            padding: 15px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: var(--primary-dark);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .action-btn:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }

        .action-btn i {
            color: var(--primary-blue);
            font-size: 18px;
        }

        /* Mobile Responsive */
        @media (max-width: 1024px) {
            .sidebar {
                width: 70px;
                overflow: hidden;
            }

            .sidebar:hover {
                width: var(--sidebar-width);
            }

            .sidebar-header {
                justify-content: center;
                padding: 25px 10px;
            }

            .sidebar-logo span {
                display: none;
            }

            .sidebar:hover .sidebar-logo span {
                display: inline;
            }

            .nav-item span {
                display: none;
            }

            .sidebar:hover .nav-item span {
                display: inline;
            }

            .main-content {
                margin-left: 70px;
            }

            .sidebar:hover ~ .main-content {
                margin-left: var(--sidebar-width);
            }
        }

        @media (max-width: 768px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .header {
                padding: 0 15px;
            }

            .user-info {
                display: none;
            }

            .welcome-banner {
                flex-direction: column;
                text-align: center;
                gap: 20px;
            }

            .welcome-icon {
                position: relative;
                right: 0;
                bottom: 0;
                opacity: 0.3;
            }
        }

        @media (max-width: 480px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }

            .header-left h1 {
                font-size: 18px;
            }

            .btn-logout span {
                display: none;
            }

            .btn-logout {
                padding: 10px;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Sidebar Navigation -->
        <div class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo">
                    <i class="fas fa-car-crash"></i>
                    <span>AutoLens</span>
                </div>
            </div>
            
            <div class="nav-menu">
                <a href="#" class="nav-item active">
                    <i class="fas fa-home"></i>
                    <span>Dashboard</span>
                </a>
                <a href="NewClaim.aspx" class="nav-item">
                    <i class="fas fa-plus-circle"></i>
                    <span>New Claim</span>
                </a>
                <a href="MyClaims.aspx" class="nav-item">
                    <i class="fas fa-file-alt"></i>
                    <span>My Claims</span>
                </a>
                <a href="Analytics.aspx" class="nav-item">
                    <i class="fas fa-chart-bar"></i>
                    <span>Analytics</span>
                </a>
                <a href="Settings.aspx" class="nav-item">
                    <i class="fas fa-cog"></i>
                    <span>Settings</span>
                </a>
                <a href="Help.aspx" class="nav-item">
                    <i class="fas fa-question-circle"></i>
                    <span>Help & Support</span>
                </a>
            </div>
        </div>

        <!-- Main Content Area -->
        <div class="main-content">
            <!-- Header -->
            <div class="header">
                <div class="header-left">
                    <h1>AutoLens Dashboard</h1>
                </div>
                
                <div class="header-right">
                    <div class="user-profile">
                        <div class="user-avatar">
                            <asp:Label ID="lblUserInitial" runat="server"></asp:Label>
                        </div>
                        <div class="user-info">
                            <span class="user-name">
                                <asp:Label ID="lblUserName" runat="server"></asp:Label>
                                <asp:Label ID="lblUserBadge" runat="server" CssClass="user-role"></asp:Label>
                            </span>
                        </div>
                    </div>
                    
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" class="fas fa-sign-out-alt">
                    </asp:Button>
                </div>
            </div>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <!-- Welcome Banner -->
                <div class="welcome-banner">
                    <div class="welcome-content">
                        <h2>Welcome back, <asp:Label ID="lblWelcomeName" runat="server"></asp:Label>!</h2>
                        <p>Manage your vehicle insurance claims efficiently with AutoLens. Get instant predictions, track claims, and view analytics all in one place.</p>
                    </div>
                    <i class="fas fa-car welcome-icon"></i>
                </div>

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon purple">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Total Claims</h3>
                            <div class="stat-value">1,248</div>
                            <div class="stat-change positive">
                                <i class="fas fa-arrow-up"></i> 12% from last month
                            </div>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon blue">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Pending Claims</h3>
                            <div class="stat-value">42</div>
                            <div class="stat-change negative">
                                <i class="fas fa-arrow-down"></i> 8% from last week
                            </div>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon teal">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Approved Claims</h3>
                            <div class="stat-value">96%</div>
                            <div class="stat-change positive">
                                <i class="fas fa-arrow-up"></i> 5% from last month
                            </div>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-icon orange">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <div class="stat-info">
                            <h3>Avg. Processing Time</h3>
                            <div class="stat-value">2.4 days</div>
                            <div class="stat-change positive">
                                <i class="fas fa-arrow-down"></i> 1.2 days faster
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Feature Cards -->
                <div class="dashboard-grid">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <h3>Instant Claim Prediction</h3>
                        <p>Submit vehicle details and get an instant prediction on claim probability using our advanced AI/ML model.</p>
                        <a href="NewClaim.aspx" class="feature-link">
                            Start Prediction
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <h3>Manage Claims</h3>
                        <p>View, track, and manage all your submitted insurance claims in one organized dashboard.</p>
                        <a href="MyClaims.aspx" class="feature-link">
                            View All Claims
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                        <h3>Advanced Analytics</h3>
                        <p>Get detailed insights and visual analytics about your claims history and patterns.</p>
                        <a href="Analytics.aspx" class="feature-link">
                            View Analytics
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-cog"></i>
                        </div>
                        <h3>Account Settings</h3>
                        <p>Manage your profile, security settings, notification preferences, and account details.</p>
                        <a href="Settings.aspx" class="feature-link">
                            Go to Settings
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="quick-actions">
                    <h3 class="section-title">
                        <i class="fas fa-bolt"></i>
                        Quick Actions
                    </h3>
                    
                    <div class="actions-grid">
                        <button class="action-btn">
                            <i class="fas fa-plus"></i>
                            <span>New Claim</span>
                        </button>
                        <button class="action-btn">
                            <i class="fas fa-download"></i>
                            <span>Export Reports</span>
                        </button>
                        <button class="action-btn">
                            <i class="fas fa-bell"></i>
                            <span>Notifications</span>
                        </button>
                        <button class="action-btn">
                            <i class="fas fa-question-circle"></i>
                            <span>Help Center</span>
                        </button>
                        <button class="action-btn">
                            <i class="fas fa-file-invoice"></i>
                            <span>View Invoices</span>
                        </button>
                        <button class="action-btn">
                            <i class="fas fa-headset"></i>
                            <span>Support Ticket</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        // Add dynamic behavior
        document.addEventListener('DOMContentLoaded', function() {
            // Make cards interactive
            const featureCards = document.querySelectorAll('.feature-card');
            featureCards.forEach(card => {
                card.addEventListener('click', function(e) {
                    if (!e.target.closest('.feature-link')) {
                        const link = this.querySelector('.feature-link');
                        if (link) link.click();
                    }
                });
            });

            // Update user initial
            const userName = document.getElementById('<%= lblUserName.ClientID %>');
            const userInitial = document.getElementById('<%= lblUserInitial.ClientID %>');
            const welcomeName = document.getElementById('<%= lblWelcomeName.ClientID %>');
            
            if (userName && userName.textContent.trim()) {
                const initials = userName.textContent.trim().split(' ')
                    .map(name => name[0])
                    .join('')
                    .toUpperCase();
                
                if (userInitial) userInitial.textContent = initials.substring(0, 2);
                if (welcomeName) welcomeName.textContent = userName.textContent.split(' ')[0];
            }

            // Sidebar navigation active state
            const navItems = document.querySelectorAll('.nav-item');
            navItems.forEach(item => {
                item.addEventListener('click', function() {
                    navItems.forEach(i => i.classList.remove('active'));
                    this.classList.add('active');
                });
            });

            // Action buttons functionality
            const actionButtons = document.querySelectorAll('.action-btn');
            actionButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const text = this.querySelector('span').textContent;
                    alert(`Opening: ${text}`);
                });
            });
        });
    </script>
</body>
</html>