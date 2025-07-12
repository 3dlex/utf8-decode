#!/usr/bin/env bash

# Check if the user provided an input string
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 '<encoded_string>'"
    echo "Make sure to enclose the encoded string in single quotes"
    exit 1
fi

encoded_string="$1"

# Function to decode quoted-printable
decode_quoted_printable() {
    local input="$1"
    local charset="$2"
    echo "$input" | perl -MMIME::QuotedPrint -pe '$_=MIME::QuotedPrint::decode($_);'
}

# Function to decode URL encoding
decode_url() {
    local input="$1"
    python3 -c "import urllib.parse; print(urllib.parse.unquote('$input'))"
}

# Function to decode base32
decode_base32() {
    local input="$1"
    echo "$input" | base32 -d 2>/dev/null
}

# Function to detect encoding type
detect_encoding() {
    local input="$1"
    if [[ "$input" =~ \=\?.*\?B\? ]]; then
        echo "base64"
    elif [[ "$input" =~ \=\?.*\?Q\? ]]; then
        echo "quoted-printable"
    elif [[ "$input" =~ \=\?.*\?X\? ]]; then
        echo "base32"
    elif [[ "$input" =~ %[0-9A-Fa-f]{2} ]]; then
        echo "url"
    elif [[ "$input" =~ \=ybegin ]]; then
        echo "yenc"
    else
        echo "unknown"
    fi
}

# Extract charset if present
charset=$(echo "$encoded_string" | grep -o -i '=?[^?]*' | sed 's/=?//i' || echo "UTF-8")

# Detect encoding type
encoding_type=$(detect_encoding "$encoded_string")

# Remove encoding markers based on type
case $encoding_type in
    "base64")
        cleaned_string=$(echo "$encoded_string" | sed -E 's/^=+\?[^?]+\?B\?//i' | sed -E 's/\?=$//')
        if [[ "$OSTYPE" == "darwin"* ]]; then
            decoded_string=$(echo "$cleaned_string" | base64 -D 2>/dev/null)
        else
            decoded_string=$(echo "$cleaned_string" | base64 -d 2>/dev/null)
        fi
        ;;
    "quoted-printable")
        cleaned_string=$(echo "$encoded_string" | sed -E 's/^=+\?[^?]+\?Q\?//i' | sed -E 's/\?=$//')
        decoded_string=$(decode_quoted_printable "$cleaned_string" "$charset")
        ;;
    "base32")
        cleaned_string=$(echo "$encoded_string" | sed -E 's/^=+\?[^?]+\?X\?//i' | sed -E 's/\?=$//')
        decoded_string=$(decode_base32 "$cleaned_string")
        ;;
    "url")
        decoded_string=$(decode_url "$encoded_string")
        ;;
    "yenc")
        echo "yEnc encoding detected. This requires special handling and external tools."
        exit 1
        ;;
    *)
        echo "Unknown encoding type. Trying common decodings..."
        # Try different decodings
        decoded_string=$(decode_url "$encoded_string") || \
        decoded_string=$(echo "$encoded_string" | base64 -d 2>/dev/null) || \
        decoded_string=$(decode_quoted_printable "$encoded_string" "UTF-8")
        ;;
esac

# Check if decoding was successful
if [ $? -eq 0 ] && [ ! -z "$decoded_string" ]; then
    echo "$decoded_string"
else
    echo "Error: Failed to decode the input string"
    echo "Original input: $encoded_string"
    echo "Detected encoding: $encoding_type"
    echo "Detected charset: $charset"
    exit 1
fi
