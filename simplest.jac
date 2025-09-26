import os
import google.generativeai as genai

def main():
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("ERROR: GEMINI_API_KEY not set.")
        return

    genai.configure(api_key=api_key)

    model = genai.GenerativeModel("gemini-1.5-flash")

    prompt = "Generate one simple quiz question about algebra."
    try:
        resp = model.generate_content(prompt)
        print("=== Gemini RESPONSE ===")
        print(resp.text.strip())
        print("=======================")
    except Exception as e:
        print("Request failed:", e)

if __name__ == "__main__":
    main()
