from sqlalchemy import Column, Integer, String, Float, DateTime, Text, Boolean, JSON
from sqlalchemy.sql import func
from database.database import Base

class Product(Base):
    __tablename__ = "products"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    category = Column(String(50), nullable=False)
    price = Column(Float, nullable=False)
    stock_quantity = Column(Integer, default=0)
    image = Column(String(10), default="🍽️")
    description = Column(Text, nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

class Order(Base):
    __tablename__ = "orders"
    
    id = Column(Integer, primary_key=True, index=True)
    order_number = Column(String(20), unique=True, index=True)
    customer_name = Column(String(100), default="Walk-in Customer")
    total_amount = Column(Float, nullable=False)
    tax_amount = Column(Float, default=0.0)
    discount_amount = Column(Float, default=0.0)
    status = Column(String(20), default="pending")
    items = Column(JSON)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Invoice(Base):
    __tablename__ = "invoices"
    
    id = Column(Integer, primary_key=True, index=True)
    order_id = Column(Integer, index=True)
    invoice_number = Column(String(50), unique=True, index=True)
    tax_authority_id = Column(String(100), nullable=True)
    status = Column(String(20), default="draft")
    submission_attempts = Column(Integer, default=0)
    last_submission_error = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    submitted_at = Column(DateTime(timezone=True), nullable=True)

class OfflineQueue(Base):
    __tablename__ = "offline_queue"
    
    id = Column(Integer, primary_key=True, index=True)
    operation_type = Column(String(50))
    data = Column(JSON)
    status = Column(String(20), default="pending")
    retry_count = Column(Integer, default=0)
    last_attempt = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())