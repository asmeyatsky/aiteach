from fastapi import APIRouter
from pydantic import BaseModel

class ChatPrompt(BaseModel):
    prompt: str

router = APIRouter()

@router.post("/playground/chat")
async def chat_playground(prompt: ChatPrompt):
    # Mock response simulating a call to an LLM
    # In a real implementation, this would call the Gemini API
    # and stream the response.
    # For now, just returning a simple message.
    return {"response": f"This is a mock response to your prompt: '{prompt.prompt}'"}
