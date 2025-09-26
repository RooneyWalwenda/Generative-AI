"""AI Study Assistant - Full Gemini AI Version"""

import http;
import json;

# Your new Gemini API key
glob gemini_api_key = "AIzaSyBrSq4GCh-BdnG95SIPPqcJVL6xYGA4zN8";

"""Call Gemini AI"""
def call_gemini(prompt: str) -> str {
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key={gemini_api_key}";
    
    response = http.post(
        url,
        headers={"Content-Type": "application/json"},
        body=json.dumps({
            "contents": [{
                "parts": [{"text": prompt}]
            }],
            "generationConfig": {
                "maxOutputTokens": 500,
                "temperature": 0.7
            }
        })
    );
    
    if response.status_code == 200 {
        data = json.loads(response.text);
        return data.candidates[0].content.parts[0].text;
    } else {
        return "AI service temporarily unavailable. Please try again.";
    }
}

"""Generate AI quiz question"""
def generate_quiz_ai(subject: str, topic: str) -> str {
    prompt = f"""Create an engaging educational quiz question about {topic} in {subject}. 
    Make it clear, challenging but fair, and suitable for a student. 
    Return only the question without any additional text.""";
    return call_gemini(prompt);
}

"""Generate AI explanation"""
def explain_concept_ai(concept: str) -> str {
    prompt = f"""Explain the concept of '{concept}' in simple, easy-to-understand terms for a student. 
    Use analogies or examples if helpful. Keep it under 150 words. 
    Return only the explanation without any introductory text.""";
    return call_gemini(prompt);
}

"""Generate AI study plan"""
def study_recommendation_ai(subject: str, topics: list) -> str {
    prompt = f"""Create a personalized study plan for {subject} focusing on these topics: {', '.join(topics)}. 
    Provide 3-4 practical, actionable study tips. Make it encouraging and specific.
    Return only the study tips without any introductory text.""";
    return call_gemini(prompt);
}

walker StudySession {
    has subject: str;
    has duration: int;
    
    can start with root entry {
        print("🚀 AI Study Assistant Starting...");
        print(f"📚 Subject: {self.subject}");
        print(f"⏱️ Duration: {self.duration} minutes");
        print(f"🎯 Topics: {', '.join(here.topics)}");
        
        # AI Study Recommendation
        print("\n💡 Generating AI study plan...");
        recommendation = study_recommendation_ai(self.subject, here.topics);
        print(f"📖 AI STUDY PLAN:\n{recommendation}");
        
        # Interactive AI Q&A Session
        questions_count = 3;
        for i in range(questions_count) {
            print(f"\n{'='*50}");
            print(f"🎯 QUESTION {i + 1}/{questions_count}");
            print(f"📝 Topic: {here.current_topic}");
            print(f"{'='*50}");
            
            # AI-generated question
            print("\n🤔 Generating AI question...");
            question = generate_quiz_ai(self.subject, here.current_topic);
            print(f"❓ {question}");
            
            answer = input("\n💭 Your answer: ");
            
            # AI explanation
            print("\n💡 Getting AI explanation...");
            explanation = explain_concept_ai(here.current_topic);
            print(f"📚 AI EXPLANATION:\n{explanation}");
            
            # Rotate through topics
            if i < questions_count - 1 {
                here.current_topic = here.topics[(i + 1) % here.topics.length];
            }
        }
        
        print(f"\n{'🎉'*10}");
        print("STUDY SESSION COMPLETED!");
        print("Great work! You've completed an AI-powered learning session.");
        print(f"{'🎉'*10}");
    }
}

node subject_node {
    has name: str;
    has topics: list;
    has current_topic: str;
}

with entry {
    # Create Mathematics subject
    math_node = spawn here --> node::subject_node;
    math_node.name = "Mathematics";
    math_node.topics = ["algebra", "geometry", "calculus", "statistics"];
    math_node.current_topic = "algebra";
    
    # Create Science subject
    science_node = spawn here --> node::subject_node;
    science_node.name = "Science";
    science_node.topics = ["physics", "chemistry", "biology", "earth-science"];
    science_node.current_topic = "physics";
    
    print("🤖 AI Study Assistant Initialized with Gemini!");
    print("Starting Mathematics session...\n");
    
    # Start AI-powered study session
    spawn math_node walker::StudySession("Mathematics", 45);
}