from .products import router as products_router
from .orders import router as orders_router
from .invoices import router as invoices_router
from .reports import router as reports_router

__all__ = ["products_router", "orders_router", "invoices_router", "reports_router"]