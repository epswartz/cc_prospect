"""This server recieves HTTP Posts with scanner data from computercraft turtles, and stores the results."""

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class ScanData(BaseModel):
    probe_name: str
    chunk_x: int
    chunk_y: int
    block_counts: dict[str,int]

    #def to_string(self):
        #rScanDatoeturn f"ScanData(probe_name: {self.probe_name}, chunk_x: {self.chunk_x}, chunk_y: {self.chunk_y}, block_counts: {self.block_counts})"

@app.post("/add_scan")
def add_scan(scan_data: ScanData):
    print(str(scan_data))
    return "Scan recieved."
