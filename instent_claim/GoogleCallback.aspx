
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GoogleCallback.aspx.cs" Inherits="instent_claim.GoogleCallback" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Processing Google Login...</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: #f5f5f5;
        }
        .loading {
            text-align: center;
        }
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="loading">
            <div class="spinner"></div>
            <p>Processing your login...</p>
        </div>
    </form>
</body>
</html>