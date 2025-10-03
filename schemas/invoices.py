# routes/invoices.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal
from models.invoice import Invoice
from schemas.invoice import Invoice as InvoiceSchema, InvoiceCreate
import requests
import json

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Mock tax authority endpoint (using a Postman mock server or similar)
MOCK_TAX_AUTHORITY_URL = "https://your-mock-server.com/submit"

@router.post("/", response_model=InvoiceSchema)
def create_invoice(invoice: InvoiceCreate, db: Session = Depends(get_db)):
    db_invoice = Invoice(**invoice.dict())
    db.add(db_invoice)
    db.commit()
    db.refresh(db_invoice)
    
    # Try to submit to tax authority
    try:
        response = requests.post(MOCK_TAX_AUTHORITY_URL, json=json.loads(invoice.items))
        if response.status_code == 200:
            db_invoice.status = "submitted"
            db_invoice.authority_response = response.text
        else:
            db_invoice.status = "failed"
            db_invoice.authority_response = response.text
    except Exception as e:
        db_invoice.status = "failed"
        db_invoice.authority_response = str(e)
    
    db.commit()
    db.refresh(db_invoice)
    return db_invoice

@router.get("/{invoice_id}", response_model=InvoiceSchema)
def get_invoice(invoice_id: int, db: Session = Depends(get_db)):
    invoice = db.query(Invoice).filter(Invoice.id == invoice_id).first()
    if invoice is None:
        raise HTTPException(status_code=404, detail="Invoice not found")
    return invoice