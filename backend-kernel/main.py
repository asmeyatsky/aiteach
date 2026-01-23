import os
import tempfile
import subprocess
import uuid
from fastapi import FastAPI, HTTPException, UploadFile, File
from pydantic import BaseModel
from typing import Optional
import docker

app = FastAPI(title="Code Execution Kernel Service")

class ExecuteRequest(BaseModel):
    code: str
    language: str = "python"
    timeout: int = 30

class ExecuteResponse(BaseModel):
    stdout: str
    stderr: str
    exit_code: int

@app.post("/execute", response_model=ExecuteResponse)
async def execute_code(request: ExecuteRequest):
    if request.language != "python":
        raise HTTPException(status_code=400, detail="Only Python execution is supported")
    
    # Generate a unique ID for this execution
    exec_id = str(uuid.uuid4())
    
    # Create a temporary file with the code
    with tempfile.NamedTemporaryFile(mode='w', suffix='.py', delete=False) as f:
        f.write(request.code)
        temp_file_path = f.name
    
    try:
        # Execute the code in a Docker container
        client = docker.from_env()
        
        # Run the code in a Python container with limited resources
        result = client.containers.run(
            "python:3.9-slim",
            f"python /tmp/{os.path.basename(temp_file_path)}",
            remove=True,
            volumes={os.path.dirname(temp_file_path): {'bind': '/tmp', 'mode': 'ro'}},
            working_dir="/tmp",
            environment={
                "PYTHONPATH": "/usr/local/lib/python3.9/site-packages"
            },
            # Set resource limits for security
            mem_limit='256m',
            network_disabled=False,
            timeout=request.timeout,
            stdout=True,
            stderr=True,
            detach=False
        )
        
        # Parse the result
        if isinstance(result, bytes):
            result_str = result.decode('utf-8')
        else:
            result_str = result
            
        # For simplicity, we'll assume exit code 0 means success
        # In a real implementation, we'd need to parse the actual exit code
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
        # Clean up the temporary file
        os.unlink(temp_file_path)

@app.get("/")
async def read_root():
    return {"message": "Welcome to the Code Execution Kernel Service", "status": "healthy"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "version": "1.0.0"}