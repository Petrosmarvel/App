import os
from typing import Dict, Any
import logging

logger = logging.getLogger(__name__)

async def submit_to_tax_authority(invoice_data: Dict[str, Any]) -> Dict[str, Any]:
    api_url = os.getenv("TAX_AUTHORITY_API_URL", "https://mock-tax-api.com/submit")
    api_key = os.getenv("TAX_AUTHORITY_API_KEY", "mock-key")
    
    try:
        submission_data = {
            "invoice_number": invoice_data["invoice_number"],
            "transaction_date": invoice_data["timestamp"],
            "total_amount": invoice_data["total_amount"],
            "tax_amount": invoice_data["tax_amount"],
            "items": invoice_data["order_data"]
        }
        
        import random
        if random.random() < 0.8:
            mock_response = {
                "success": True,
                "authority_id": f"KRA-{invoice_data['invoice_number']}",
                "message": "Invoice successfully submitted to tax authority",
                "timestamp": invoice_data["timestamp"]
            }
        else:
            mock_response = {
                "success": False,
                "error": "Tax authority service temporarily unavailable",
                "timestamp": invoice_data["timestamp"]
            }
        
        logger.info(f"Tax authority submission for {invoice_data['invoice_number']}: {mock_response}")
        return mock_response
        
    except Exception as e:
        logger.error(f"Error submitting to tax authority: {str(e)}")
        return {
            "success": False,
            "error": f"Submission failed: {str(e)}"
        }