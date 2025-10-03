from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class InvoiceCreate(BaseModel):
    order_id: int

class InvoiceResponse(BaseModel):
    id: int
    order_id: int
    invoice_number: str
    tax_authority_id: Optional[str]
    status: str
    submission_attempts: int
    created_at: datetime
    submitted_at: Optional[datetime]
    
    class Config:
        from_attributes = True