from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database.database import get_db
from database import models
from pydantic import BaseModel
from typing import List, Dict, Any
from datetime import datetime, timedelta
from sqlalchemy import func

router = APIRouter()

class DailySalesReport(BaseModel):
    date: str
    total_orders: int
    total_revenue: float
    total_tax: float
    average_order_value: float

class TaxReport(BaseModel):
    period: str
    total_tax_collected: float
    total_transactions: int
    taxable_sales: float

@router.get("/reports/daily-sales")
def get_daily_sales_report(days: int = 7, db: Session = Depends(get_db)) -> List[DailySalesReport]:
    end_date = datetime.now()
    start_date = end_date - timedelta(days=days)
    
    results = db.query(
        func.date(models.Order.created_at).label('date'),
        func.count(models.Order.id).label('total_orders'),
        func.sum(models.Order.total_amount).label('total_revenue'),
        func.sum(models.Order.tax_amount).label('total_tax'),
        func.avg(models.Order.total_amount).label('average_order_value')
    ).filter(
        models.Order.created_at >= start_date,
        models.Order.status == 'completed'
    ).group_by(
        func.date(models.Order.created_at)
    ).order_by(
        func.date(models.Order.created_at).desc()
    ).all()
    
    report = []
    for result in results:
        report.append(DailySalesReport(
            date=result.date.strftime('%Y-%m-%d'),
            total_orders=result.total_orders,
            total_revenue=float(result.total_revenue or 0),
            total_tax=float(result.total_tax or 0),
            average_order_value=float(result.average_order_value or 0)
        ))
    
    return report

@router.get("/reports/tax")
def get_tax_report(start_date: str = None, end_date: str = None, db: Session = Depends(get_db)) -> TaxReport:
    if not start_date:
        start_date = datetime.now().replace(day=1).strftime('%Y-%m-%d')
    if not end_date:
        end_date = datetime.now().strftime('%Y-%m-%d')
    
    start_dt = datetime.strptime(start_date, '%Y-%m-%d')
    end_dt = datetime.strptime(end_date, '%Y-%m-%d') + timedelta(days=1)
    
    result = db.query(
        func.count(models.Order.id).label('total_transactions'),
        func.sum(models.Order.total_amount).label('total_sales'),
        func.sum(models.Order.tax_amount).label('total_tax_collected')
    ).filter(
        models.Order.created_at >= start_dt,
        models.Order.created_at < end_dt,
        models.Order.status == 'completed'
    ).first()
    
    taxable_sales = float(result.total_sales or 0) - float(result.total_tax_collected or 0)
    
    return TaxReport(
        period=f"{start_date} to {end_date}",
        total_tax_collected=float(result.total_tax_collected or 0),
        total_transactions=result.total_transactions or 0,
        taxable_sales=taxable_sales
    )

@router.get("/reports/summary")
def get_dashboard_summary(db: Session = Depends(get_db)) -> Dict[str, Any]:
    today = datetime.now().date()
    
    today_sales = db.query(
        func.count(models.Order.id).label('orders_count'),
        func.sum(models.Order.total_amount).label('revenue')
    ).filter(
        func.date(models.Order.created_at) == today,
        models.Order.status == 'completed'
    ).first()
    
    total_products = db.query(models.Product).filter(models.Product.is_active == True).count()
    
    low_stock_products = db.query(models.Product).filter(
        models.Product.stock_quantity < 10,
        models.Product.is_active == True
    ).count()
    
    pending_invoices = db.query(models.Invoice).filter(
        models.Invoice.status.in_(['draft', 'rejected'])
    ).count()
    
    return {
        "today_orders": today_sales.orders_count or 0,
        "today_revenue": float(today_sales.revenue or 0),
        "total_products": total_products,
        "low_stock_products": low_stock_products,
        "pending_invoices": pending_invoices
    }