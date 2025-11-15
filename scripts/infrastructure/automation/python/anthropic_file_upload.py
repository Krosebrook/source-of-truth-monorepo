#!/usr/bin/env python3
import anthropic
import os
from pathlib import Path

client = anthropic.Anthropic(
    api_key=os.getenv("ANTHROPIC_API_KEY")
)

pdf_path = Path("document.pdf")

if not pdf_path.exists():
    print(f"Error: {pdf_path} not found")
    print("Please ensure you have a document.pdf file in the current directory")
    exit(1)

try:
    with open(pdf_path, "rb") as pdf_file:
        response = client.beta.files.upload(
            file=("document.pdf", pdf_file, "application/pdf"),
        )

    print(f"File uploaded successfully!")
    print(f"File ID: {response.id}")
    print(f"File name: {response.filename}")
    print(f"Purpose: {response.purpose}")
    print(f"Size: {response.bytes} bytes")

except anthropic.APIError as e:
    print(f"API Error: {e}")
except Exception as e:
    print(f"Error uploading file: {e}")