// Visitor counter: calls the API Gateway endpoint (which invokes the Lambda,
// which increments the DynamoDB counter) and shows the returned number.

// TODO: replace with your real endpoint:
// https://<api-id>.execute-api.<region>.amazonaws.com/visitor-count/count
const API_URL = "https://wdkpo9pie6.execute-api.eu-central-1.amazonaws.com/count";

async function updateVisitorCount() {
    const el = document.getElementById("visitor-count");
    if (!el) return;

    try {
        const response = await fetch(API_URL, { method: "GET" });
        if (!response.ok) {
            throw new Error(`API returned status ${response.status}`);
        }

        const data = await response.json();

        // Accepts either {"count": 42} or a bare number like 42,
        // depending on what the Lambda puts in the response body.
        const count = typeof data === "object" ? data.count : data;

        if (count === undefined || count === null) {
            throw new Error("Response did not contain a count");
        }

        el.textContent = count;
    } catch (error) {
        // Leave the placeholder dash in place: a broken counter shouldn't break the page.
        console.error("Could not load visitor count:", error);
    }
}

document.addEventListener("DOMContentLoaded", updateVisitorCount);