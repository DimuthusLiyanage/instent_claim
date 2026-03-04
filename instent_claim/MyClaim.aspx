<%@ Page Title="My Claims" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyClaim.aspx.cs" Inherits="instent_claim.WebForm3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* AutoLens Theme Styling */
        .content-container {
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .autolens-card {
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 25px;
            margin-bottom: 20px;
            border: 1px solid #eaeaea;
        }
        .page-title {
            color: #1a1b2f;
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 25px;
        }
        .filter-row {
            display: flex;
            gap: 20px;
            align-items: flex-end;
            flex-wrap: wrap;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px dashed #dcdcdc;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            color: #666;
            margin-bottom: 6px;
            font-weight: 600;
        }
        .form-control {
            padding: 10px 14px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 14px;
            min-width: 160px;
            color: #333;
        }
        .btn-dark {
            background-color: #1a1b2f; /* Matches your dashboard button */
            color: white;
            border: none;
            padding: 11px 24px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: background-color 0.2s;
        }
        .btn-dark:hover {
            background-color: #2a2c4a;
        }
        /* GridView Styling */
        .custom-grid {
            width: 100%;
            border-collapse: collapse;
        }
        .custom-grid th {
            background-color: #ffffff;
            color: #888;
            text-align: left;
            padding: 12px 15px;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #f0f0f0;
        }
        .custom-grid td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
            color: #333;
            font-weight: 500;
        }
        .custom-grid tr:hover {
            background-color: #fcfcfc;
        }
        .text-green { color: #06d6a0; font-weight: 700; font-size: 15px; } /* Matches your Rs. 60,000 text */
        .text-blue { color: #4361ee; font-weight: 600; } /* Matches Detected Issues text */
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="content-container">
        <div class="autolens-card">
            <div class="page-title">🚗 My Claims History</div>

            <div class="filter-row">
                <div class="form-group">
                    <label>From Date</label>
                    <asp:TextBox ID="txtFromDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>To Date</label>
                    <asp:TextBox ID="txtToDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Min. Confidence (%)</label>
                    <asp:TextBox ID="txtConfidence" runat="server" CssClass="form-control" TextMode="Number" step="0.1" placeholder="e.g., 85.0"></asp:TextBox>
                </div>
                <div class="form-group">
                    <asp:Button ID="btnFilter" runat="server" Text="Apply Filters" CssClass="btn-dark" OnClick="btnFilter_Click" />
                </div>
            </div>

            <asp:GridView ID="gvClaims" runat="server" AutoGenerateColumns="False" CssClass="custom-grid" GridLines="None" EmptyDataText="No claims found matching your criteria.">
                <Columns>
                    <asp:BoundField DataField="CreatedDateTime" HeaderText="Date & Time" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                    <asp:BoundField DataField="PredictedClass" HeaderText="Detected Issue" ItemStyle-CssClass="text-blue" />
                    <asp:BoundField DataField="EstimatedCost" HeaderText="Estimated Cost (LKR)" DataFormatString="Rs. {0:N0}" ItemStyle-CssClass="text-green" />
                    <asp:BoundField DataField="Confidence" HeaderText="System Confidence" DataFormatString="{0:F1}%" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>