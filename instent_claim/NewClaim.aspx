<%@ Page Title="New Claim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NewClaim.aspx.cs" Inherits="instent_claim.WebForm2" Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Modern Dashboard Theme synced with your Sidebar */
        :root {
            --sidebar-dark: #1a1c2e;
            --accent-blue: #4e73df;
            --success-green: #1cc88a;
            --bg-gray: #f8f9fc;
            --text-muted: #858796;
        }

        .page-container {
            padding: 2rem;
            background-color: var(--bg-gray);
            min-height: 100vh;
            font-family: 'Nunito', 'Segoe UI', Tahoma, sans-serif;
        }

        .claim-card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            padding: 2rem;
            max-width: 1000px;
            margin: 0 auto;
        }

        .header-section {
            border-bottom: 1px solid #e3e6f0;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
        }

        .header-section h1 {
            color: var(--sidebar-dark);
            font-weight: 700;
            font-size: 1.75rem;
            margin: 0;
        }

        /* Upload Area */
        .upload-zone {
            border: 2px dashed #d1d3e2;
            background: #fbfbfb;
            padding: 2rem;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 1.5rem;
            transition: 0.3s;
        }

        .upload-zone:hover {
            border-color: var(--accent-blue);
        }

        .btn-predict {
            background-color: var(--sidebar-dark);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 5px;
            font-weight: 700;
            width: 100%;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-predict:hover {
            background-color: #2e325a;
            transform: translateY(-1px);
        }

        /* Summary Stats */
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .stat-card {
            padding: 1.25rem;
            border-radius: 8px;
            border-left: 0.25rem solid var(--accent-blue);
            background: #fff;
            box-shadow: 0 0.125rem 0.25rem 0 rgba(58, 59, 69, 0.05);
        }

        .stat-card.cost { border-left-color: var(--success-green); }

        .stat-label {
            font-size: 0.7rem;
            font-weight: 800;
            color: var(--accent-blue);
            text-transform: uppercase;
            margin-bottom: 0.25rem;
        }

        .stat-value {
            font-size: 1.25rem;
            font-weight: 700;
            color: #5a5c69;
        }

        /* Image Gallery */
        .gallery-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
        }

        .gallery-item {
            background: #fff;
            border: 1px solid #e3e6f0;
            border-radius: 8px;
            overflow: hidden;
            transition: 0.2s;
        }

        .gallery-item:hover {
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.1);
        }

        .gallery-img {
            width: 100%;
            height: 140px;
            object-fit: cover;
        }

        .gallery-info {
            padding: 0.75rem;
        }

        .gallery-info .class-tag {
            display: block;
            font-weight: 800;
            font-size: 0.8rem;
            color: var(--sidebar-dark);
        }

        .gallery-info .cost-tag {
            color: var(--success-green);
            font-weight: 700;
            font-size: 0.9rem;
        }

        .error-msg {
            color: #e74a3b;
            background: #fff5f5;
            padding: 1rem;
            border-radius: 5px;
            margin-top: 1rem;
            display: block;
            border: 1px solid #ffdada;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="page-container">
        <div class="claim-card">
            <div class="header-section">
                <h1>🚗 New Vehicle Claim Assessment</h1>
            </div>

            <div class="upload-zone">
                <p style="color: var(--text-muted); font-weight: 600;">Drag & drop or click to upload damage photos</p>
                <asp:FileUpload ID="fileUpload" runat="server" AllowMultiple="true" accept="image/*" CssClass="form-control" />
                <p style="font-size: 0.8rem; color: #999; margin-top: 5px;">* Max 5 images allowed for processing</p>
            </div>

            <asp:Button ID="btnPredict" runat="server" Text="Analyze & Estimate Costs" CssClass="btn-predict" OnClick="btnPredict_Click" />
            
            <asp:Label ID="lblError" runat="server" CssClass="error-msg" Visible="false" />

            <asp:Panel ID="resultPanel" runat="server" Visible="false">
                <div class="summary-grid">
                    <div class="stat-card">
                        <div class="stat-label">Detected Issues</div>
                        <div class="stat-value"><asp:Label ID="lblPredictedClass" runat="server" /></div>
                    </div>
                    <div class="stat-card cost">
                        <div class="stat-label">Total Repair Cost (LKR)</div>
                        <div class="stat-value" style="color: var(--success-green);"><asp:Label ID="lblEstimatedCost" runat="server" /></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-label">System Confidence</div>
                        <div class="stat-value"><asp:Label ID="lblConfidence" runat="server" /></div>
                    </div>
                </div>

                <h3 style="margin-top: 2.5rem; color: var(--sidebar-dark); font-size: 1.2rem;">Detailed Image Gallery</h3>
                <div class="gallery-container">
                    <asp:Repeater ID="rptImages" runat="server">
                        <ItemTemplate>
                            <div class="gallery-item">
                                <img src='<%# Eval("ImageUrl") %>' class="gallery-img" alt="Damage Preview" />
                                <div class="gallery-info">
                                    <span class="class-tag"><%# Eval("Class") %></span>
                                    <span class="cost-tag">Rs. <%# Eval("Cost", "{0:N0}") %></span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>