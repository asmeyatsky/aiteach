import os
import tempfile
import subprocess
import uuid
from fastapi import FastAPI, HTTPException, UploadFile, File, Depends, Header
from pydantic import BaseModel
from typing import Optional
import docker

app = FastAPI(title="Code Execution Kernel Service")

API_KEY = os.getenv("KERNEL_API_KEY", "CHANGE-ME-IN-PRODUCTION")

def verify_api_key(x_api_key: str = Header(...)):
    if x_api_key != API_KEY:
        raise HTTPException(status_code=403, detail="Invalid API key")

class ExecuteRequest(BaseModel):
    code: str
    language: str = "python"
    timeout: int = 30

class ExecuteResponse(BaseModel):
    stdout: str
    stderr: str
    exit_code: int

@app.post("/execute", response_model=ExecuteResponse, dependencies=[Depends(verify_api_key)])
async def execute_code(request: ExecuteRequest):
    if request.language != "python":
        raise HTTPException(status_code=400, detail="Only Python execution is supported")

    exec_id = str(uuid.uuid4())

    with tempfile.NamedTemporaryFile(mode='w', suffix='.py', delete=False) as f:
        f.write(request.code)
        temp_file_path = f.name

    try:
        client = docker.from_env()

        result = client.containers.run(
            "python:3.11-slim",
            f"python /tmp/{os.path.basename(temp_file_path)}",
            remove=True,
            volumes={os.path.dirname(temp_file_path): {'bind': '/tmp', 'mode': 'ro'}},
            working_dir="/tmp",
            environment={
                "PYTHONPATH": "/usr/local/lib/python3.11/site-packages"
            },
            mem_limit='256m',
            network_disabled=True,
            timeout=request.timeout,
            stdout=True,
            stderr=True,
            detach=False
        )

        if isinstance(result, bytes):
            result_str = result.decode('utf-8')
        else:
            result_str = result

        return ExecuteResponse(
            stdout=result_str,
            stderr="",
            exit_code=0
        )
    except docker.errors.ContainerError as e:
        return ExecuteResponse(
            stdout=e.stderr.decode() if e.stderr else "",
            stderr=e.stderr.decode() if e.stderr else str(e),
            exit_code=e.exit_status
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Execution error: {str(e)}")
    finally:
        os.unlink(temp_file_path)

@app.get("/")
async def read_root():
    return {"message": "Welcome to the Code Execution Kernel Service", "status": "healthy"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "version": "1.0.0"}
