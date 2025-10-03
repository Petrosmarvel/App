from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database.database import get_db
from database import models
from schemas.order import OrderCreate, OrderResponse
from typing import List
import uuid
from datetime import datetime

router = APIRouter()

def calculate_order_totals(items: List[dict], tax_rate: float, discount_percentage: float):
    subtotal = sum(item['price'] * item['quantity'] for item in items)
    discount_amount = subtotal * (discount_percentage / 100)
    taxable_amount = subtotal - discount_amount
    tax_amount = taxable_amount * tax_rate
    total_amount = taxable_amount + tax_amount
    
    return {
        "subtotal": subtotal,
        "discount_amount": discount_amount,
        "tax_amount": tax_amount,
        "total_amount": total_amount
    }

@router.post("/orders", response_model=OrderResponse)
def create_order(order: OrderCreate, db: Session = Depends(get_db)):
    totals = calculate_order_totals([item.dict() for item in order.items], order.tax_rate, order.discount_percentage)
    
    order_number = f"MPO-{datetime.now().strftime('%Y%m%d')}-{str(uuid.uuid4())[:8].upper()}"
    
    db_order = models.Order(
        order_number=order_number,
        customer_name=order.customer_name,
        total_amount=totals["total_amount"],
        tax_amount=totals["tax_amount"],
        discount_amount=totals["discount_amount"],
        items=[item.dict() for item in order.items],
        status="completed"
    )
    
    db.add(db_order)
    db.commit()
    db.refresh(db_order)
    
    return db_order

@router.get("/orders", response_model=List[OrderResponse])
def get_orders(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    orders = db.query(models.Order).order_by(models.Order.created_at.desc()).offset(skip).limit(limit).all()
    return orders

@router.get("/orders/{order_id}", response_model=OrderResponse)
def get_order(order_id: int, db: Session = Depends(get_db)):
    order = db.query(models.Order).filter(models.Order.id == order_id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return order