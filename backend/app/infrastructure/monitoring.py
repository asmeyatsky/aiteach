import os
import logging
import time
from typing import Dict, Any
from fastapi import Request, Response
import json

try:
    from google.cloud import logging as cloud_logging
except Exception:
    cloud_logging = None

class CloudLogger:
    """Google Cloud Logging integration"""

    def __init__(self):
        if cloud_logging and not os.getenv("DEBUG", "False").lower() == "true":
            try:
                self.client = cloud_logging.Client()
                self.client.setup_logging()
                self.logger = logging.getLogger("aiteach-backend")
            except Exception as e:
                logging.warning(f"Failed to setup Cloud Logging: {e}")
                self.client = None
                self.logger = logging.getLogger("aiteach-backend")
        else:
            self.client = None
            self.logger = logging.getLogger("aiteach-backend")

    def log(self, message: str, severity: str = "INFO", extra: Dict[str, Any] = None):
        """Log message with optional structured data"""
        log_entry = {
            "message": message,
            "severity": severity,
            "timestamp": time.time()
        }

        if extra:
            log_entry.update(extra)

        if self.client:
            self.logger.log(getattr(logging, severity), json.dumps(log_entry))
        else:
            self.logger.log(getattr(logging, severity), message)

class MetricsCollector:
    """Collect application metrics"""

    def __init__(self):
        self.metrics = {
            "requests_total": 0,
            "requests_by_endpoint": {},
            "response_times": [],
            "errors_total": 0,
            "active_users": set(),
            "database_queries": 0
        }

    def record_request(self, request: Request, response: Response, response_time: float):
        """Record request metrics"""
        self.metrics["requests_total"] += 1

        endpoint = f"{request.method} {request.url.path}"
        self.metrics["requests_by_endpoint"][endpoint] = (
            self.metrics["requests_by_endpoint"].get(endpoint, 0) + 1
        )

        self.metrics["response_times"].append(response_time)

        # Keep only last 1000 response times for memory efficiency
        if len(self.metrics["response_times"]) > 1000:
            self.metrics["response_times"] = self.metrics["response_times"][-1000:]

        if response.status_code >= 400:
            self.metrics["errors_total"] += 1

    def record_user_activity(self, user_id: str):
        """Record active user"""
        self.metrics["active_users"].add(user_id)

    def record_database_query(self):
        """Record database query"""
        self.metrics["database_queries"] += 1

    def get_metrics_summary(self) -> Dict[str, Any]:
        """Get metrics summary"""
        response_times = self.metrics["response_times"]
        avg_response_time = sum(response_times) / len(response_times) if response_times else 0

        return {
            "requests_total": self.metrics["requests_total"],
            "errors_total": self.metrics["errors_total"],
            "error_rate": (
                self.metrics["errors_total"] / self.metrics["requests_total"]
                if self.metrics["requests_total"] > 0 else 0
            ),
            "average_response_time": avg_response_time,
            "active_users_count": len(self.metrics["active_users"]),
            "database_queries": self.metrics["database_queries"],
            "top_endpoints": dict(
                sorted(
                    self.metrics["requests_by_endpoint"].items(),
                    key=lambda x: x[1],
                    reverse=True
                )[:10]
            )
        }

    def reset_metrics(self):
        """Reset metrics (useful for periodic reporting)"""
        self.metrics["active_users"].clear()
        # Keep cumulative counters, reset only session-based metrics

# Global instances
cloud_logger = CloudLogger()
metrics_collector = MetricsCollector()

async def monitoring_middleware(request: Request, call_next):
    """Middleware to collect metrics and logs"""
    start_time = time.time()

    # Log request
    cloud_logger.log(
        f"Request: {request.method} {request.url.path}",
        "INFO",
        {
            "method": request.method,
            "path": request.url.path,
            "query_params": str(request.query_params),
            "user_agent": request.headers.get("user-agent"),
            "ip": request.client.host if request.client else None
        }
    )

    try:
        response = await call_next(request)
        response_time = time.time() - start_time

        # Record metrics
        metrics_collector.record_request(request, response, response_time)

        # Log response
        cloud_logger.log(
            f"Response: {request.method} {request.url.path} - "
            f"Status: {response.status_code} - Time: {response_time:.3f}s",
            "INFO",
            {
                "method": request.method,
                "path": request.url.path,
                "status_code": response.status_code,
                "response_time": response_time
            }
        )

        return response

    except Exception as e:
        response_time = time.time() - start_time

        # Log error
        cloud_logger.log(
            f"Error: {request.method} {request.url.path} - {str(e)}",
            "ERROR",
            {
                "method": request.method,
                "path": request.url.path,
                "error": str(e),
                "response_time": response_time
            }
        )

        raise

def setup_monitoring():
    """Setup monitoring and alerting"""
    # This could be expanded to setup alerting rules, dashboards, etc.
    cloud_logger.log("Monitoring system initialized", "INFO")

def log_application_event(event_type: str, details: Dict[str, Any]):
    """Log application-specific events"""
    cloud_logger.log(
        f"Application event: {event_type}",
        "INFO",
        {
            "event_type": event_type,
            "details": details
        }
    )