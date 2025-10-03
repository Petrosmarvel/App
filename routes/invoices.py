from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks
from sqlalchemy.orm import Session
from database.database import get_db
from database import models
from schemas.invoice import InvoiceCreate, InvoiceResponse
from services.tax_authority import submit_to_tax_authority
import uuid
from datetime import datetime

router = APIRouter()

@router.post("/invoices", response_model=InvoiceResponse)
async def create_invoice(invoice: InvoiceCreate, background_tasks: BackgroundTasks, db: Session = Depends(get_db)):
    order = db.query(models.Order).filter(models.Order.id == invoice.order_id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    
    invoice_number = f"INV-{datetime.now().strftime('%Y%m%d')}-{str(uuid.uuid4())[:8].upper()}"
    
    db_invoice = models.Invoice(
        order_id=invoice.order_id,
        invoice_number=invoice_number,
        status="draft"
    )
    
    db.add(db_invoice)
    db.commit()
    db.refresh(db_invoice)
    
    background_tasks.add_task(submit_invoice_to_tax_authority, db_invoice.id, db)
    
    return db_invoice

async def submit_invoice_to_tax_authority(invoice_id: int, db: Session):
    invoice = db.query(models.Invoice).filter(models.Invoice.id == invoice_id).first()
    if not invoice:
        return
    
    order = db.query(models.Order).filter(models.Order.id == invoice.order_id).first()
    if not order:
        return
    
    try:
        response = await submit_to_tax_authority({
            "invoice_number": invoice.invoice_number,
            "order_data": order.items,
            "total_amount": order.total_amount,
            "tax_amount": order.tax_amount,
            "timestamp": datetime.now().isoformat()
        })
        
        if response.get("success"):
            invoice.status = "approved"
            invoice.tax_authority_id = response.get("authority_id")
            invoice.submitted_at = datetime.now()
        else:
            invoice.status = "rejected"
            invoice.last_submission_error = response.get("error", "Unknown error")
        
    except Exception as e:
        invoice.status = "rejected"
        invoice.last_submission_error = str(e)
        invoice.submission_attempts += 1
    
    db.commit()

@router.get("/invoices/{invoice_id}", response_model=InvoiceResponse)
def get_invoice(invoice_id: int, db: Session = Depends(get_db)):
    invoice = db.query(models.Invoice).filter(models.Invoice.id == invoice_id).first()
    if not invoice:
        raise HTTPException(status_code=404, detail="Invoice not found")
    return invoice

@router.post("/invoices/{invoice_id}/retry")
async def retry_invoice_submission(invoice_id: int, background_tasks: BackgroundTasks, db: Session = Depends(get_db)):
    invoice = db.query(models.Invoice).filter(models.Invoice.id == invoice_id).first()
    if not invoice:
        raise HTTPException(status_code=404, detail="Invoice not found")
    
    background_tasks.add_task(submit_invoice_to_tax_authority, invoice_id, db)
    
    return {"message": "Invoice submission retry initiated"}