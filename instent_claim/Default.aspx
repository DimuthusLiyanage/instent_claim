<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="instent_claim.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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

        <div class="dashboard-grid">
            <div class="feature-card" onclick="window.location='NewClaim.aspx';">
                <div class="feature-icon">
                    <i class="fas fa-bolt"></i>
                </div>
                <h3>Instant Claim Prediction</h3>
                <p>Submit vehicle details and get an instant prediction on claim probability using our advanced AI/ML model.</p>
                <a href="NewClaim.aspx" class="feature-link">
                    Start Prediction <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            
            <div class="feature-card" onclick="window.location='MyClaims.aspx';">
                <div class="feature-icon">
                    <i class="fas fa-file-alt"></i>
                </div>
                <h3>Manage Claims</h3>
                <p>View, track, and manage all your submitted insurance claims in one organized dashboard.</p>
                <a href="MyClaims.aspx" class="feature-link">
                    View All Claims <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            
             <div class="feature-card" onclick="window.location='Analytics.aspx';">
                <div class="feature-icon">
                    <i class="fas fa-chart-bar"></i>
                </div>
                <h3>Advanced Analytics</h3>
                <p>Get detailed insights and visual analytics about your claims history and patterns.</p>
                <a href="Analytics.aspx" class="feature-link">
                    View Analytics <i class="fas fa-arrow-right"></i>
                </a>
            </div>
            
            <div class="feature-card" onclick="window.location='Settings.aspx';">
                <div class="feature-icon">
                    <i class="fas fa-cog"></i>
                </div>
                <h3>Account Settings</h3>
                <p>Manage your profile, security settings, notification preferences, and account details.</p>
                <a href="Settings.aspx" class="feature-link">
                    Go to Settings <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
        
        <div class="quick-actions">
            <h3 class="section-title">
                <i class="fas fa-bolt"></i> Quick Actions
            </h3>
            <div class="actions-grid">
                <button class="action-btn" type="button"><i class="fas fa-plus"></i> <span>New Claim</span></button>
                <button class="action-btn" type="button"><i class="fas fa-download"></i> <span>Export Reports</span></button>
                <button class="action-btn" type="button"><i class="fas fa-bell"></i> <span>Notifications</span></button>
                <button class="action-btn" type="button"><i class="fas fa-question-circle"></i> <span>Help Center</span></button>
                <button class="action-btn" type="button"><i class="fas fa-file-invoice"></i> <span>View Invoices</span></button>
                <button class="action-btn" type="button"><i class="fas fa-headset"></i> <span>Support Ticket</span></button>
            </div>
        </div>
    </div>
</asp:Content>
