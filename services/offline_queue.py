from sqlalchemy.orm import Session
from database import models
from typing import Dict, Any
import logging
from datetime import datetime

logger = logging.getLogger(__name__)

def add_to_offline_queue(db: Session, operation_type: str, data: Dict[str, Any]):
    queue_item = models.OfflineQueue(
        operation_type=operation_type,
        data=data,
        status="pending"
    )
    db.add(queue_item)
    db.commit()
    logger.info(f"Added {operation_type} to offline queue")
    return queue_item

def process_offline_queue(db: Session):
    pending_items = db.query(models.OfflineQueue).filter(
        models.OfflineQueue.status == "pending"
    ).all()
    
    for item in pending_items:
        try:
            item.status = "processing"
            item.last_attempt = datetime.now()
            db.commit()
            
            if item.operation_type == "submit_invoice":
                logger.info(f"Retrying invoice submission for queue item {item.id}")
            elif item.operation_type == "create_order":
                logger.info(f"Retrying order creation for queue item {item.id}")
            
            item.status = "completed"
            db.commit()
            
        except Exception as e:
            logger.error(f"Failed to process queue item {item.id}: {str(e)}")
            item.status = "failed"
            item.retry_count += 1
            db.commit()