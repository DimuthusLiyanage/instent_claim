using System;
using System.Threading.Tasks;
using Microsoft.Playwright.NUnit;
using NUnit.Framework;

namespace Predict_Test
{
    [TestFixture]
    public class WebForm3Tests : PageTest
    {
        // Update this URL to match your local development environment
        private readonly string ClaimsGridUrl = "https://localhost:44300/WebForm3.aspx";

        [Test]
        public async Task PageLoad_ShouldSetDefaultDateFilters()
        {
            // Act: Navigate to the page (this triggers Page_Load and BindGrid)
            await Page.GotoAsync(ClaimsGridUrl);

            // Assert: Read the values that your C# code injected into the textboxes
            var fromDateValue = await Page.InputValueAsync("#txtFromDate");
            var toDateValue = await Page.InputValueAsync("#txtToDate");

            // Verify the textboxes are not empty
            Assert.IsNotEmpty(fromDateValue, "From Date should be populated by default.");
            Assert.IsNotEmpty(toDateValue, "To Date should be populated by default.");

            // Verify the ToDate is actually today's date (formatted as yyyy-MM-dd)
            string expectedToDate = DateTime.Now.ToString("yyyy-MM-dd");
            Assert.AreEqual(expectedToDate, toDateValue);
        }

        [Test]
        public async Task FilterButton_Click_ShouldReloadGridWithData()
        {
            // Arrange: Go to the page and enter a confidence filter
            await Page.GotoAsync(ClaimsGridUrl);
            await Page.FillAsync("#txtConfidence", "85.5");

            // Act: Click the filter button and wait for the page to postback/reload
            await Page.RunAndWaitForNavigationAsync(async () =>
            {
                await Page.ClickAsync("#btnFilter");
            });

            // Assert: Verify the GridView (rendered as an HTML table) exists.
            // In Web Forms, an empty grid often doesn't render at all, or renders just headers.
            // We check that the table exists and count the rows.
            var gridRowLocator = Page.Locator("#gvClaims tr");
            int rowCount = await gridRowLocator.CountAsync();

            // Assuming the grid renders at least a header row when the button is clicked
            Assert.GreaterOrEqual(rowCount, 1, "The GridView should render at least one row (the header).");
        }
    }
}