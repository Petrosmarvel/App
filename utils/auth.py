# Authentication utilities (for future use)
from fastapi import HTTPException, status

def verify_token(token: str):
    # Simple token verification - extend as needed
    if not token:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Not authenticated"
        )
    return {"user_id": 1}  # Mock user