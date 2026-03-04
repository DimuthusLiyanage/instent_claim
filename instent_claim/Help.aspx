<%@ Page Title="Help" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Help.aspx.cs" Inherits="instent_claim.WebForm4" %>

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
            color: #1a1b2f; /* Dark dashboard blue */
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eaeaea;
        }

        .section-title {
            color: #4361ee; /* Accent blue */
            font-size: 18px;
            font-weight: 600;
            margin-top: 25px;
            margin-bottom: 15px;
        }

        /* FAQ Styling */
        .faq-item {
            margin-bottom: 20px;
            background: #fdfdfd;
            border: 1px solid #f0f0f0;
            padding: 15px;
            border-radius: 6px;
        }

        .faq-question {
            font-weight: 600;
            color: #1a1b2f;
            margin-bottom: 8px;
            font-size: 15px;
        }

        .faq-answer {
            color: #555;
            font-size: 14px;
            line-height: 1.6;
        }

        /* Contact Cards */
        .contact-grid {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-top: 15px;
        }

        .contact-card {
            background: #ffffff;
            border: 1px solid #eaeaea;
            border-left: 4px solid #06d6a0; /* Green accent */
            border-radius: 6px;
            padding: 15px;
            flex: 1;
            min-width: 220px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.02);
        }

        .contact-name {
            font-weight: 600;
            color: #1a1b2f;
            font-size: 15px;
        }

        .contact-role {
            color: #666;
            font-size: 13px;
            margin-top: 4px;
        }

        .contact-team {
            color: #888;
            font-size: 12px;
            margin-top: 6px;
            font-style: italic;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="content-container">
        <div class="autolens-card">
            <div class="page-title">❓ Help & Support</div>

            <div class="section-title">How to Use the Claim Assessment System</div>
            <div class="faq-answer">
                <ol style="padding-left: 20px; margin-top: 5px;">
                    <li>Navigate to the <strong>New Claim</strong> page from the sidebar.</li>
                    <li>Upload clear photos of the vehicle damage. Ensure the lighting is good and the damage is clearly visible.</li>
                    <li>Click <strong>Analyze & Estimate Costs</strong>.</li>
                    <li>The AI model will detect the issue (e.g., Bumper scratch) and generate an estimated repair cost based on the visual evidence.</li>
                    <li>Your results are automatically saved and can be tracked anytime on the <strong>My Claims</strong> page.</li>
                </ol>
            </div>

            <div class="section-title">Frequently Asked Questions</div>

            <div class="faq-item">
                <div class="faq-question">How many images can I upload at once?</div>
                <div class="faq-answer">You can upload a maximum of 5 images per claim assessment. This ensures optimal processing speed and accuracy for the computer vision model.</div>
            </div>

            <div class="faq-item">
                <div class="faq-question">What currency are the estimated costs displayed in?</div>
                <div class="faq-answer">All AI-generated repair estimates are calculated and provided in Sri Lankan Rupees (LKR).</div>
            </div>

            <div class="section-title">Contact Support</div>
            <div class="faq-answer" style="margin-bottom: 15px;">If you encounter any technical issues, database errors, or need further assistance with the AutoLens platform, please reach out to the system administrators:</div>

            <div class="contact-grid">
                <div class="contact-card">
                    <div class="contact-name">Dimuthu Sandaruwan</div>
                    <div class="contact-role">Developer</div>
                    <div class="contact-team">Autolense Development Team</div>
                </div>
                <div class="contact-card">
                    <div class="contact-name">Email</div>
                    <div class="contact-role">DimuthuSliyanage@gmail.com
                        </div>
                </div>
                <div class="contact-card">
                    <div class="contact-name">Mobile</div>
                    <div class="contact-role">+94772794591</div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>
