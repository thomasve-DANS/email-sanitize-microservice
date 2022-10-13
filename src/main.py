import re

from fastapi import FastAPI, Response
from pydantic import BaseModel, version

from version import get_version
app = FastAPI()

class Data(BaseModel):
    data: str
    replacement_email: str = ""

@app.get("/version")
async def info():
    result = get_version()
    return {"version": result}

@app.post("/sanitize")
async def sanitize(input_data: Data, response: Response):
    """Simple function to strip email addresses from file. """
    email_regex = '([A-Za-z0-9]+[.-_])*[A-Za-z0-9]+@[A-Za-z0-9-]+(\.[A-Z|a-z]{2,})+'
    if not input_data.data:
        response.status_code = 400
        return Data(data="Data field cannot be empty")
    response_data = re.sub(email_regex, input_data.replacement_email, input_data.data)
    return Data(data=response_data)
    
