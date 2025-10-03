from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class OrderItem(BaseModel):
    product_id: int
    quantity: int
    price: float
    modifications: List[str] = []
    notes: Optional[str] = None

class OrderCreate(BaseModel):
    customer_name: str = "Walk-in Customer"
    items: List[OrderItem]
    tax_rate: float = 0.16
    discount_percentage: float = 0.0

class OrderResponse(BaseModel):
    id: int
    order_number: str
    customer_name: str
    total_amount: float
    tax_amount: float
    discount_amount: float
    status: str
    items: List[dict]
    created_at: datetime
    
    class Config:
        from_attributes = True