

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="instent_claim.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard - Vehicle Insurance Claim System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
        }

        .header {
            background: white;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            color: #333;
            font-size: 24px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-name {
            color: #666;
            font-weight: 500;
        }

        .btn-logout {
            padding: 8px 20px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: background 0.3s;
        }

        .btn-logout:hover {
            background: #c82333;
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .welcome-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .welcome-card h2 {
            color: #333;
            margin-bottom: 10px;
        }

        .welcome-card p {
            color: #666;
            line-height: 1.6;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .card h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 20px;
        }

        .card p {
            color: #666;
            line-height: 1.6;
            margin-bottom: 15px;
        }

        .card-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            display: inline-block;
            margin-top: 10px;
        }

        .card-link:hover {
            text-decoration: underline;
        }

        .user-badge {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>🚗 Vehicle Insurance Claim System</h1>
            <div class="user-info">
                <span class="user-name">
                    Welcome, <asp:Label ID="lblUserName" runat="server"></asp:Label>
                    <asp:Label ID="lblUserBadge" runat="server" CssClass="user-badge" Visible="false"></asp:Label>
                </span>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
            </div>
        </div>

        <div class="container">
            <div class="welcome-card">
                <h2>Dashboard</h2>
                <p>Welcome to the Vehicle Insurance Claim Prediction System. This system helps you predict and manage vehicle insurance claims efficiently.</p>
            </div>

            <div class="dashboard-grid">
                <div class="card">
                    <h3>📊 New Claim Prediction</h3>
                    <p>Submit vehicle details and get an instant prediction on claim probability using our advanced ML model.</p>
                    <a href="#" class="card-link">Start Prediction →</a>
                </div>

                <div class="card">
                    <h3>📋 My Claims</h3>
                    <p>View and manage all your submitted insurance claims in one place.</p>
                    <a href="#" class="card-link">View Claims →</a>
                </div>

                <div class="card">
                    <h3>📈 Analytics</h3>
                    <p>View detailed analytics and statistics about your insurance claims history.</p>
                    <a href="#" class="card-link">View Analytics →</a>
                </div>

                <div class="card">
                    <h3>⚙️ Account Settings</h3>
                    <p>Manage your profile, security settings, and preferences.</p>
                    <a href="#" class="card-link">Go to Settings →</a>
                </div>
            </div>
        </div>
    </form>
</body>
</html>