#!/usr/bin/env python3
"""
Secure Anthropic File Upload Script
Implements security best practices for file uploads
"""

import os
import sys
import logging
import hashlib
import mimetypes
from pathlib import Path
from typing import Optional, Tuple
from datetime import datetime
import anthropic
from anthropic import APIError, AuthenticationError, PermissionDeniedError

MAX_FILE_SIZE = 100 * 1024 * 1024  # 100MB limit
ALLOWED_MIME_TYPES = {
    'application/pdf',
    'text/plain',
    'text/markdown',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/msword'
}
ALLOWED_EXTENSIONS = {'.pdf', '.txt', '.md', '.docx', '.doc'}

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('file_upload.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class SecureFileUploader:
    """Secure file upload handler for Anthropic API"""

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

            cwd = Path.cwd()
            try:
                path.relative_to(cwd)
            except ValueError:
                if not self._is_safe_path(path):
                    raise ValueError(f"File path outside safe directory: {file_path}")

            return path
        except Exception as e:
            logger.error(f"Path validation failed: {e}")
            raise

    def _is_safe_path(self, path: Path) -> bool:
        """Check if path is in a safe location"""
        safe_dirs = [
            Path.home(),
            Path('/tmp'),
            Path('/var/tmp')
        ]

        for safe_dir in safe_dirs:
            try:
                path.relative_to(safe_dir)
                return True
            except ValueError:
                continue

        return False

    def validate_file(self, file_path: Path) -> Tuple[str, int]:
        """Validate file type, size, and content"""
        file_size = file_path.stat().st_size
        if file_size == 0:
            raise ValueError("File is empty")

        if file_size > MAX_FILE_SIZE:
            raise ValueError(f"File size ({file_size} bytes) exceeds maximum allowed size ({MAX_FILE_SIZE} bytes)")

        extension = file_path.suffix.lower()
        if extension not in ALLOWED_EXTENSIONS:
            raise ValueError(f"File extension '{extension}' not allowed. Allowed: {ALLOWED_EXTENSIONS}")

        mime_type, _ = mimetypes.guess_type(str(file_path))
        if mime_type and mime_type not in ALLOWED_MIME_TYPES:
            raise ValueError(f"MIME type '{mime_type}' not allowed. Allowed: {ALLOWED_MIME_TYPES}")

        if not mime_type:
            mime_type = self._detect_mime_type(file_path, extension)

        file_hash = self._calculate_file_hash(file_path)
        logger.info(f"File validated - Size: {file_size}, Type: {mime_type}, SHA256: {file_hash}")

        return mime_type or 'application/octet-stream', file_size

    def _detect_mime_type(self, file_path: Path, extension: str) -> str:
        """Detect MIME type based on extension"""
        mime_map = {
            '.pdf': 'application/pdf',
            '.txt': 'text/plain',
            '.md': 'text/markdown',
            '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            '.doc': 'application/msword'
        }
        return mime_map.get(extension, 'application/octet-stream')

    def _calculate_file_hash(self, file_path: Path) -> str:
        """Calculate SHA256 hash of file for integrity verification"""
        sha256_hash = hashlib.sha256()
        with open(file_path, 'rb') as f:
            for byte_block in iter(lambda: f.read(4096), b""):
                sha256_hash.update(byte_block)
        return sha256_hash.hexdigest()

    def upload_file(self, file_path: str) -> dict:
        """Securely upload file to Anthropic API"""
        logger.info(f"Starting upload process for: {file_path}")

        try:
            validated_path = self.validate_file_path(file_path)
            mime_type, file_size = self.validate_file(validated_path)

            filename = validated_path.name

            logger.info(f"Uploading file: {filename} ({file_size} bytes)")

            with open(validated_path, 'rb') as file_handle:
                response = self.client.beta.files.upload(
                    file=(filename, file_handle, mime_type)
                )

            result = {
                'id': response.id,
                'filename': response.filename,
                'purpose': response.purpose,
                'bytes': response.bytes,
                'created_at': datetime.fromtimestamp(response.created_at).isoformat(),
                'status': 'success'
            }

            logger.info(f"Upload successful - File ID: {response.id}")
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
            logger.error(f"Unexpected error during upload: {e}")
            raise


def main():
    """Main entry point"""
    if len(sys.argv) != 2:
        print("Usage: python secure_anthropic_upload.py <file_path>")
        sys.exit(1)

    file_path = sys.argv[1]

    try:
        uploader = SecureFileUploader()
        result = uploader.upload_file(file_path)

        print("\n✓ File uploaded successfully!")
        print(f"  File ID: {result['id']}")
        print(f"  Filename: {result['filename']}")
        print(f"  Size: {result['bytes']:,} bytes")
        print(f"  Created: {result['created_at']}")

    except Exception as e:
        print(f"\n✗ Upload failed: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()