# Secure Anthropic API Implementation

## Security Features Implemented

### 1. API Key Security
- **Environment Variables**: API key loaded from environment or `.env` file
- **No Hardcoding**: Keys never stored in source code
- **File Permissions**: `.env` file restricted to 600 (owner read/write only)
- **Gitignore**: Sensitive files excluded from version control

### 2. Input Validation
- **Path Traversal Prevention**: Absolute path resolution and symlink handling
- **File Type Validation**: Whitelist of allowed MIME types and extensions
- **Size Limits**: Maximum file size enforcement (25MB)
- **Content Verification**: SHA256 hash calculation for integrity

### 3. Error Handling
- **Granular Exception Handling**: Specific handling for authentication, permission, and API errors
- **Comprehensive Logging**: Audit trail with timestamps and severity levels
- **Safe Error Messages**: No sensitive information in user-facing errors

### 4. Access Controls
- **Directory Restrictions**: Files limited to safe directories
- **Permission Checks**: Validates file accessibility before processing
- **Secure File Reading**: Binary mode for images, UTF-8 for text

## Usage

### Setup
```bash
# 1. Install dependencies
pip install anthropic

# 2. Set API key (choose one method)
# Method A: Environment variable
export ANTHROPIC_API_KEY="your-key-here"

# Method B: Create .env file
cp .env.example .env
# Edit .env and add your key

# 3. Set proper permissions
chmod 600 .env
chmod +x secure_anthropic_client.py
```

### Running the Client
```bash
# Process text file
python3 secure_anthropic_client.py document.txt

# Process with custom prompt
python3 secure_anthropic_client.py document.pdf "Extract key points"

# Process image
python3 secure_anthropic_client.py image.png "Describe this image"
```

## File Structure
```
.
├── secure_anthropic_client.py  # Main secure client
├── secure_anthropic_upload.py  # File upload handler (beta API)
├── .env.example                 # Environment template
├── .env                         # Actual credentials (git-ignored)
├── .gitignore                   # Version control exclusions
└── anthropic_client.log         # Audit log
```

## Security Best Practices Applied

1. **Principle of Least Privilege**: Only necessary permissions granted
2. **Defense in Depth**: Multiple validation layers
3. **Secure by Default**: Restrictive settings unless explicitly overridden
4. **Audit Trail**: All operations logged for monitoring
5. **Input Sanitization**: All user inputs validated before use
6. **Error Handling**: Graceful failure without information disclosure

## Supported File Types
- Documents: PDF, TXT, MD, DOC, DOCX
- Images: PNG, JPG, JPEG, GIF, WEBP

## Monitoring
Logs are written to `anthropic_client.log` with rotation support. Monitor for:
- Authentication failures
- Invalid file attempts
- API rate limits
- Unusual access patterns

## Important Notes
- Never commit `.env` file to version control
- Rotate API keys regularly
- Monitor usage through Anthropic dashboard
- Keep dependencies updated
- Review logs for suspicious activity