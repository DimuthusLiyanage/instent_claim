<%@ Page Title="New Claim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NewClaim.aspx.cs" Inherits="instent_claim.WebForm2" Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Color Theme Variables based on your Sidebar */
        :root {
            --primary-dark: #1a1c2e; /* Sidebar background */
            --accent-blue: #4e73df;  /* Primary button/link color */
            --bg-light: #f8f9fc;    /* Main content background */
            --text-main: #333;
            --white: #ffffff;
        }

        .page-container {
            padding: 30px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-light);
            min-height: 100vh;
        }

        .page-header {
            margin-bottom: 25px;
            border-bottom: 2px solid #e3e6f0;
            padding-bottom: 10px;
        }

        .page-header h1 {
            color: var(--primary-dark);
            font-weight: 700;
            font-size: 1.8rem;
        }

        /* Card Layout */
        .claim-card {
            background: var(--white);
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 25px;
            max-width: 800px;
        }

        .upload-container {
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #555;
        }

        /* Styling the File Upload */
        input[type="file"] {
            display: block;
            width: 100%;
            padding: 10px;
            border: 1px dashed #d1d3e2;
            border-radius: 5px;
            background: #fbfbfb;
        }

        /* Matching Button Styles */
        .btn-predict {
            background-color: var(--primary-dark);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s;
        }

        .btn-predict:hover {
            background-color: #2e325a;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        /* Results Panel */
        .result-panel {
            margin-top: 30px;
            border-top: 2px solid #eee;
            padding-top: 20px;
        }

        .result-grid {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .image-preview img {
            max-width: 300px;
            border-radius: 8px;
            border: 3px solid #eee;
        }

        .result-details {
            flex: 1;
            min-width: 250px;
        }

        .result-item {
            margin-bottom: 15px;
            padding: 10px;
            background: #fdfdfd;
            border-left: 4px solid var(--accent-blue);
        }

        .result-item label {
            font-weight: bold;
            display: block;
            font-size: 0.9rem;
            color: #888;
        }

        .value, .cost-value, .confidence-value {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary-dark);
        }

        .cost-value { color: #2ecc71; } /* Green for money */

        .error-message {
            color: #e74a3b;
            background: #fff5f5;
            padding: 10px;
            border-radius: 5px;
            display: block;
            margin-top: 10px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="page-container">
        <div class="page-header">
            <h1>🚗 Vehicle Damage Cost Predictor</h1>
        </div>
        
        <div class="claim-card">
            <div class="upload-container">
                <div class="form-group">
                    <label for="fileUpload">Upload Vehicle Damage Image</label>
                    <asp:FileUpload ID="fileUpload" runat="server" accept="image/*" CssClass="file-input" />
                </div>
                
                <div class="form-group">
                    <asp:Button ID="btnPredict" runat="server" Text="Analyze & Predict Cost" 
                                CssClass="btn-predict" OnClick="btnPredict_Click" />
                </div>
                
                <asp:Label ID="lblError" runat="server" CssClass="error-message" 
                           Visible="false" />
            </div>
            
            <asp:Panel ID="resultPanel" runat="server" CssClass="result-panel" Visible="false">
                <h3>Prediction Results</h3>
                
                <div class="result-grid">
                    <div class="image-preview">
                        <asp:Image ID="imgPreview" runat="server" />
                    </div>
                    
                    <div class="result-details">
                        <div class="result-item">
                            <label>Predicted Damage Type</label>
                            <span class="value">
                                <asp:Label ID="lblPredictedClass" runat="server" />
                            </span>
                        </div>
                        
                        <div class="result-item">
                            <label>Estimated Repair Cost</label>
                            <span class="cost-value">
                                <asp:Label ID="lblEstimatedCost" runat="server" />
                            </span>
                        </div>
                        
                        <div class="result-item">
                            <label>Confidence Level</label>
                            <span class="confidence-value">
                                <asp:Label ID="lblConfidence" runat="server" />
                            </span>
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>