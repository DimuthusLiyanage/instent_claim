<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NewClaim.aspx.cs" Inherits="instent_claim.WebForm2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        
        .upload-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
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
        
        .btn-predict {
            background-color: #4CAF50;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        
        .btn-predict:hover {
            background-color: #45a049;
        }
        
        .error-message {
            background-color: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #c62828;
        }
        
        .result-panel {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .result-panel h2 {
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
        }
        
        .image-preview {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .image-preview img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .result-item {
            display: flex;
            justify-content: space-between;
            padding: 15px;
            margin-bottom: 10px;
            background-color: #f9f9f9;
            border-radius: 5px;
            border-left: 4px solid #4CAF50;
        }
        
        .result-item label {
            font-weight: 600;
            color: #555;
        }
        
        .result-item .value {
            font-size: 1.1em;
            color: #333;
        }
        
        .cost-value {
            color: #4CAF50;
            font-size: 1.5em;
            font-weight: bold;
        }
        
        .confidence-value {
            color: #2196F3;
            font-weight: 600;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h1>🚗 Vehicle Damage Cost Predictor</h1>
        
        <div class="upload-container">
            <div class="form-group">
                <label for="fileUpload">Upload Vehicle Damage Image:</label>
                <asp:FileUpload ID="fileUpload" runat="server" accept="image/*" />
            </div>
            
            <div class="form-group">
                <asp:Button ID="btnPredict" runat="server" Text="Predict Damage Cost" 
                            CssClass="btn-predict" OnClick="btnPredict_Click" />
            </div>
            
            <asp:Label ID="lblError" runat="server" CssClass="error-message" 
                       Visible="false" />
        </div>
        
        <asp:Panel ID="resultPanel" runat="server" CssClass="result-panel" Visible="false">
            <h2>Prediction Results</h2>
            
            <div class="image-preview">
                <asp:Image ID="imgPreview" runat="server" />
            </div>
            
            <div class="result-item">
                <label>Predicted Damage Type:</label>
                <span class="value">
                    <asp:Label ID="lblPredictedClass" runat="server" />
                </span>
            </div>
            
            <div class="result-item">
                <label>Estimated Repair Cost:</label>
                <span class="cost-value">
                    <asp:Label ID="lblEstimatedCost" runat="server" />
                </span>
            </div>
            
            <div class="result-item">
                <label>Confidence Level:</label>
                <span class="confidence-value">
                    <asp:Label ID="lblConfidence" runat="server" />
                </span>
            </div>
        </asp:Panel>
</asp:Content>
