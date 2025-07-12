# Universal UTF-8 Decoder

## Overview
The Universal UTF-8 Decoder script is a robust solution designed to handle multiple text encoding formats. It automatically detects the encoding type and applies the appropriate decoding algorithm, making it ideal for processing email headers, URLs, and other encoded text data.

---

## Features
- Automatic encoding detection (Base64, Quoted-Printable, Base32, URL encoding, yEnc, etc.)
- Support for multiple character sets, including UTF-8, WINDOWS-1252, and ISO-8859-1
- Fallback mechanisms for unknown encodings
- Detailed error reporting for improved debugging

---

## Supported Encodings

1. **Base64 Encoding**
   - Example: `=?utf-8?B?U29tZSBuZXcgdGV4dCB3aXRoIGEgZGlmZmVyZW50IGVuY29kaW5nIHN0eWxlLg==?=`

2. **Quoted-Printable (QP) Encoding**
   - Example: `=?UTF-8?Q?Mail_REMINDER=F0=9F=94=95?=`

3. **Base32 Encoding**
   - Example: `=?UTF-8?X?JRXXEZLNEBUXA43VNUQGI33MN5ZCA43JOQQGC3LFOQWCAY3PNZZXI4Y=?=`

4. **URL Encoding (Percent Encoding)**
   - Example: `Hello%20World%21`

5. **yEnc Encoding**
   - Example: `=ybegin line=128 size=123456 name=file.jpg`

---

## Usage

### 1. Base64 Decoding
```bash
./decode-script.sh '=?UTF-8?B?SGVsbG8gV29ybGQ=?='
```

### 2. Quoted-Printable Decoding
```bash
./decode-script.sh '=?UTF-8?Q?Mail_REMINDER=F0=9F=94=95?='
```

### 3. URL Decoding
```bash
python3 -c "import urllib.parse; print(urllib.parse.unquote('$input'))"
```

### 4. General Decoding
The script detects encoding markers and automatically applies the correct decoding logic based on the input string.

---

## Dependencies

1. **Base64 Utilities**
   - Built into most systems.
   - Linux: `base64 -d`
   - macOS: `base64 -D`

2. **Perl**
   - Required for Quoted-Printable decoding.
   - Install MIME::QuotedPrint module if not available.

3. **Python 3**
   - Used for URL decoding.

4. **Base32 Utilities**
   - May need to be installed separately.

---

## Technical Details

### Detection Logic
The script uses regular expressions to identify encoding markers in the input string, such as `=?UTF-8?B?` for Base64 or `=?UTF-8?Q?` for Quoted-Printable.

### Charset Handling
- Default charset is UTF-8.
- Automatically extracts charset from the input string when available.

### Error Handling
- Validates input format before processing.
- Provides detailed error messages for unsupported or invalid input.

---

## Best Practices

1. Enclose input strings in single quotes to prevent shell interpretation.
2. Regularly test with various encoding types and character sets.
3. Update the script as new encoding patterns emerge.
4. Consider enabling logging for production use.

---

## Future Enhancements

1. Support for additional encoding schemes.
2. Improved handling of nested encodings.
3. Integration with email parsing systems.
4. Performance optimizations for large-scale processing.
5. Web interface for user-friendly access.

---

## License
This project is licensed under the MIT License.

---
