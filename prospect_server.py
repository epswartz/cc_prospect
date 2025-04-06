"""This server recieves HTTP Posts with scanner data from computercraft turtles, and stores the results."""

import time
from typing import Annotated

from fastapi import FastAPI, Depends
from pydantic import BaseModel
from sqlmodel import Field, Session, SQLModel, create_engine
import logging
logger = logging.getLogger(__name__)

app = FastAPI()

# Data from one particular POST request with a scan.
class ScanData(BaseModel):
    probe_name: str
    chunk_x: int
    chunk_y: int
    block_counts: dict[str,int]


# SQLModel table object for scans.
class Scan(SQLModel, table=True):
    id: int | None = Field(default = None, primary_key = True)
    probe_name: str
    chunk_x: int 
    chunk_y: int 
    block: str
    count: int


# https://fastapi.tiangolo.com/tutorial/sql-databases/#create-models
SQLITE_FILE_NAME = "scans.db"
SQLITE_URL = f"sqlite:///{SQLITE_FILE_NAME}"
CONNECT_ARGS = {"check_same_thread": False}
db_engine = create_engine(SQLITE_URL, connect_args = CONNECT_ARGS)

def set_up_db():
    print("Setting up DB.")
    SQLModel.metadata.create_all(db_engine)
    print("Scans table is ready.")

@app.on_event("startup")
def on_startup():
    set_up_db()

def get_session():
    with Session(db_engine) as session:
        yield session


SessionDep = Annotated[Session, Depends(get_session)]
    


@app.post("/add_scan")
def add_scan(scan_data: ScanData, session:SessionDep):
    print("Received new scan from", scan_data.probe_name)
    
    for block in scan_data.block_counts:


        scan = Scan()
        scan.probe_name = scan_data.probe_name
        scan.chunk_x = scan_data.chunk_x
        scan.chunk_y = scan_data.chunk_y
        scan.block = block
        scan.count = scan_data.block_counts[block]

        session.add(scan)
        session.commit()
        session.refresh(scan)
    print("Added scan to DB.")



