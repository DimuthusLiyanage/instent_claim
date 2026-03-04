<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="instent_claim.WebForm1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* AutoLens Dashboard Theme */
        .dashboard-content {
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        /* Welcome Banner */
        .welcome-banner {
            background: linear-gradient(135deg, #1a1b2f 0%, #2a2c4a 100%);
            border-radius: 10px;
            padding: 30px;
            color: #ffffff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            box-shadow: 0 4px 15px rgba(26, 27, 47, 0.15);
            position: relative;
            overflow: hidden;
        }
        .welcome-content {
            z-index: 2;
        }
        .welcome-content h2 {
            margin: 0 0 10px 0;
            font-size: 26px;
            font-weight: 600;
        }
        .welcome-content p {
            margin: 0;
            font-size: 15px;
            opacity: 0.85;
            max-width: 600px;
            line-height: 1.5;
        }
        .welcome-icon {
            font-size: 80px;
            opacity: 0.1;
            position: absolute;
            right: 40px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 1;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        .stat-card {
            background: #ffffff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border: 1px solid #eaeaea;
            display: flex;
            align-items: center;
        }
        .stat-icon {
            width: 55px;
            height: 55px;
            border-radius: 12px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 24px;
            margin-right: 18px;
            flex-shrink: 0;
        }
        /* Icon Colors */
        .stat-icon.purple { background-color: #f3e8ff; color: #9333ea; }
        .stat-icon.blue { background-color: #e0e7ff; color: #4f46e5; }
        .stat-icon.teal { background-color: #ccfbf1; color: #0d9488; }
        
        .stat-info h3 {
            margin: 0 0 5px 0;
            font-size: 14px;
            color: #666;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: #1a1b2f;
            margin-bottom: 5px;
        }
        .stat-change {
            font-size: 13px;
            font-weight: 500;
        }
        .stat-change.positive { color: #06d6a0; } /* AutoLens Green */
        .stat-change.negative { color: #ef476f; }

        /* Quick Actions */
        .quick-actions {
            background: #ffffff;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border: 1px solid #eaeaea;
        }
        .section-title {
            color: #1a1b2f;
            font-size: 18px;
            font-weight: 600;
            margin: 0 0 20px 0;
            padding-bottom: 15px;
            border-bottom: 1px solid #eaeaea;
        }
        .section-title i {
            color: #4361ee;
            margin-right: 8px;
        }
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 15px;
        }
        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            padding: 14px;
            border-radius: 6px;
            text-decoration: none;
            color: #1a1b2f;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .action-btn i {
            color: #4361ee;
            font-size: 16px;
            transition: color 0.2s ease;
        }
        .action-btn:hover {
            background: #1a1b2f;
            border-color: #1a1b2f;
            color: #ffffff;
            box-shadow: 0 4px 10px rgba(26, 27, 47, 0.2);
            transform: translateY(-2px);
        }
        .action-btn:hover i {
            color: #ffffff;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="dashboard-content">
        
        <div class="welcome-banner">
            <div class="welcome-content">
                <h2>Welcome back, <asp:Label ID="lblWelcomeName" runat="server"></asp:Label>!</h2>
                <p>Manage your vehicle insurance claims efficiently with AutoLens. Get instant predictions, track claims, and view analytics all in one place.</p>
            </div>
            <i class="fas fa-car welcome-icon"></i>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon purple">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="stat-info">
                    <h3>Total Claim Value</h3>
                    <div class="stat-value">
                        <asp:Label ID="lblTotalCost" runat="server">Rs. 0</asp:Label>
                    </div>
                    <div class="stat-change positive">
                        <i class="fas fa-arrow-up"></i> Updated just now
                    </div>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon blue">
                    <i class="fas fa-clock"></i>
                </div>
                <div class="stat-info">
                    <h3>No Of Claims</h3>
                    <div class="stat-value">
                        <asp:Label ID="lblNoOfClaims" runat="server">0</asp:Label>
                    </div>
                    <div class="stat-change positive">
                        <i class="fas fa-check"></i> All time
                    </div>
                </div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon teal">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3>Max Confidant Claim</h3>
                    <div class="stat-value">
                        <asp:Label ID="lblMaxConfidence" runat="server">0%</asp:Label>
                    </div>
                    <div class="stat-change positive">
                        <i class="fas fa-star"></i> Highest accuracy
                    </div>
                </div>
            </div>
        </div>

        <div class="quick-actions">
            <h3 class="section-title">
                <i class="fas fa-bolt"></i> Quick Actions
            </h3>
            <div class="actions-grid">
                <a href="WebForm2.aspx" class="action-btn"><i class="fas fa-plus"></i> <span>New Claim</span></a>
                <a href="MyClaim.aspx" class="action-btn"><i class="fas fa-file-invoice"></i> <span>View Claims</span></a>
                <a href="#" class="action-btn"><i class="fas fa-chart-pie"></i> <span>Analytics</span></a>
                <a href="#" class="action-btn"><i class="fas fa-download"></i> <span>Export Reports</span></a>
                <a href="#" class="action-btn"><i class="fas fa-bell"></i> <span>Notifications</span></a>
                <a href="Help.aspx" class="action-btn"><i class="fas fa-question-circle"></i> <span>Help Center</span></a>
            </div>
        </div>
        
    </div>
</asp:Content>