#!/usr/bin/env python3
"""
Secure Anthropic API Client with File Processing
Implements security best practices for API interactions
"""

import os
import sys
import logging
import hashlib
import base64
import mimetypes
from pathlib import Path
from typing import Optional, Dict, Any
from datetime import datetime
import anthropic
from anthropic import APIError, AuthenticationError, PermissionDeniedError

MAX_FILE_SIZE = 25 * 1024 * 1024  # 25MB limit for base64 encoded content
ALLOWED_MIME_TYPES = {
    'application/pdf',
    'text/plain',
    'text/markdown',
    'image/jpeg',
    'image/png',
    'image/gif',
    'image/webp'
}
ALLOWED_EXTENSIONS = {'.pdf', '.txt', '.md', '.jpg', '.jpeg', '.png', '.gif', '.webp'}

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('anthropic_client.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class SecureAnthropicClient:
    """Secure Anthropic API client with file processing capabilities"""

    def __init__(self):
        self.client = None
        self._initialize_client()

    def _initialize_client(self) -> None:
        """Initialize Anthropic client with secure API key retrieval"""
        api_key = self._get_api_key()
        if not api_key:
            logger.error("API key not found")
            raise ValueError("ANTHROPIC_API_KEY environment variable not set")

        try:
            self.client = anthropic.Anthropic(api_key=api_key)
            logger.info("Anthropic client initialized successfully")
        except Exception as e:
            logger.error(f"Failed to initialize client: {e}")
            raise

    def _get_api_key(self) -> Optional[str]:
        """Securely retrieve API key from environment"""
        api_key = os.environ.get('ANTHROPIC_API_KEY')
        if api_key and api_key.strip():
            return api_key.strip()

        env_file = Path('.env')
        if env_file.exists():
            try:
                with open(env_file, 'r') as f:
                    for line in f:
                        if line.startswith('ANTHROPIC_API_KEY='):
                            key = line.split('=', 1)[1].strip().strip('"\'')
                            if key:
                                return key
            except Exception as e:
                logger.warning(f"Could not read .env file: {e}")

        return None

    def validate_file_path(self, file_path: str) -> Path:
        """Validate and sanitize file path"""
        try:
            path = Path(file_path).resolve()

            if not path.exists():
                raise FileNotFoundError(f"File not found: {file_path}")

            if not path.is_file():
                raise ValueError(f"Path is not a file: {file_path}")

            if path.is_symlink():
                logger.warning(f"File is a symbolic link: {file_path}")
                real_path = path.resolve()
                if not real_path.exists():
                    raise ValueError(f"Symbolic link points to non-existent file")
                path = real_path

            return path
        except Exception as e:
            logger.error(f"Path validation failed: {e}")
            raise

    def validate_file(self, file_path: Path) -> Dict[str, Any]:
        """Validate file type, size, and prepare for API"""
        file_size = file_path.stat().st_size
        if file_size == 0:
            raise ValueError("File is empty")

        if file_size > MAX_FILE_SIZE:
            raise ValueError(f"File size ({file_size} bytes) exceeds maximum allowed size ({MAX_FILE_SIZE} bytes)")

        extension = file_path.suffix.lower()
        if extension not in ALLOWED_EXTENSIONS:
            raise ValueError(f"File extension '{extension}' not allowed. Allowed: {ALLOWED_EXTENSIONS}")

        mime_type, _ = mimetypes.guess_type(str(file_path))
        if not mime_type:
            mime_type = self._detect_mime_type(extension)

        if mime_type not in ALLOWED_MIME_TYPES:
            raise ValueError(f"MIME type '{mime_type}' not allowed. Allowed: {ALLOWED_MIME_TYPES}")

        file_hash = self._calculate_file_hash(file_path)
        logger.info(f"File validated - Size: {file_size}, Type: {mime_type}, SHA256: {file_hash}")

        return {
            'mime_type': mime_type,
            'size': file_size,
            'hash': file_hash,
            'is_image': mime_type.startswith('image/')
        }

    def _detect_mime_type(self, extension: str) -> str:
        """Detect MIME type based on extension"""
        mime_map = {
            '.pdf': 'application/pdf',
            '.txt': 'text/plain',
            '.md': 'text/markdown',
            '.jpg': 'image/jpeg',
            '.jpeg': 'image/jpeg',
            '.png': 'image/png',
            '.gif': 'image/gif',
            '.webp': 'image/webp'
        }
        return mime_map.get(extension, 'application/octet-stream')

    def _calculate_file_hash(self, file_path: Path) -> str:
        """Calculate SHA256 hash of file for integrity verification"""
        sha256_hash = hashlib.sha256()
        with open(file_path, 'rb') as f:
            for byte_block in iter(lambda: f.read(4096), b""):
                sha256_hash.update(byte_block)
        return sha256_hash.hexdigest()

    def process_file_with_claude(self, file_path: str, prompt: str = None) -> str:
        """Process file with Claude API"""
        logger.info(f"Starting file processing for: {file_path}")

        try:
            validated_path = self.validate_file_path(file_path)
            file_info = self.validate_file(validated_path)

            if prompt is None:
                prompt = "Please analyze this file and provide a summary of its contents."

            messages = []

            if file_info['is_image']:
                with open(validated_path, 'rb') as f:
                    image_data = base64.b64encode(f.read()).decode('utf-8')

                messages = [{
                    "role": "user",
                    "content": [
                        {
                            "type": "image",
                            "source": {
                                "type": "base64",
                                "media_type": file_info['mime_type'],
                                "data": image_data
                            }
                        },
                        {
                            "type": "text",
                            "text": prompt
                        }
                    ]
                }]
            else:
                with open(validated_path, 'r', encoding='utf-8') as f:
                    content = f.read()

                messages = [{
                    "role": "user",
                    "content": f"{prompt}\n\nFile content:\n{content}"
                }]

            logger.info("Sending request to Claude API")
            response = self.client.messages.create(
                model="claude-3-5-sonnet-20241022",
                max_tokens=1000,
                messages=messages
            )

            result = response.content[0].text
            logger.info("Successfully processed file with Claude")
            return result

        except AuthenticationError as e:
            logger.error(f"Authentication failed: {e}")
            raise
        except PermissionDeniedError as e:
            logger.error(f"Permission denied: {e}")
            raise
        except APIError as e:
            logger.error(f"API error: {e}")
            raise
        except Exception as e:
            logger.error(f"Unexpected error: {e}")
            raise

    def test_connection(self) -> bool:
        """Test API connection with a simple request"""
        try:
            response = self.client.messages.create(
                model="claude-3-haiku-20240307",
                max_tokens=50,
                messages=[{"role": "user", "content": "Say 'Connection successful' and nothing else."}]
            )
            result = response.content[0].text.strip()
            logger.info(f"Connection test result: {result}")
            return "successful" in result.lower()
        except Exception as e:
            logger.error(f"Connection test failed: {e}")
            return False


def main():
    """Main entry point"""
    if len(sys.argv) < 2:
        print("Usage: python secure_anthropic_client.py <file_path> [prompt]")
        print("\nExample:")
        print("  python secure_anthropic_client.py document.pdf")
        print("  python secure_anthropic_client.py image.png 'What is in this image?'")
        sys.exit(1)

    file_path = sys.argv[1]
    prompt = ' '.join(sys.argv[2:]) if len(sys.argv) > 2 else None

    try:
        client = SecureAnthropicClient()

        print("Testing API connection...")
        if not client.test_connection():
            print("✗ Failed to connect to Anthropic API")
            sys.exit(1)

        print("✓ Connection successful\n")
        print(f"Processing file: {file_path}")

        result = client.process_file_with_claude(file_path, prompt)

        print("\n--- Claude's Response ---")
        print(result)
        print("-------------------------\n")

    except Exception as e:
        print(f"\n✗ Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()