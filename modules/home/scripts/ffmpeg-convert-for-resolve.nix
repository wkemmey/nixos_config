{ pkgs }:

# FFmpeg conversion helper for DaVinci Resolve
# The free version of DaVinci Resolve on Linux has limited H.264/H.265 codec support
# This script converts videos to DNxHR format which is fully supported

pkgs.writeShellScriptBin "ffmpeg-convert-for-resolve" ''
  set -e

  # Colors for output
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  NC='\033[0m' # No Color

  # Show usage if no arguments provided
  if [ $# -eq 0 ]; then
    echo -e "''${GREEN}FFmpeg Video Converter for DaVinci Resolve''${NC}"
    echo ""
    echo "Usage: ffmpeg-convert-for-resolve INPUT_FILE [OUTPUT_FILE]"
    echo ""
    echo "Converts H.264/H.265 videos to DNxHR format compatible with DaVinci Resolve free version."
    echo ""
    echo "Examples:"
    echo "  ffmpeg-convert-for-resolve video.mp4"
    echo "  ffmpeg-convert-for-resolve video.mp4 output.mov"
    echo ""
    echo "If no output file is specified, it will be named INPUT_dnxhr.mov"
    exit 0
  fi

  INPUT="$1"

  # Check if input file exists
  if [ ! -f "$INPUT" ]; then
    echo -e "''${RED}Error: Input file '$INPUT' not found''${NC}"
    exit 1
  fi

  # Determine output filename
  if [ -n "$2" ]; then
    OUTPUT="$2"
  else
    # Remove extension and add _dnxhr.mov
    BASENAME="''${INPUT%.*}"
    OUTPUT="''${BASENAME}_dnxhr.mov"
  fi

  # Check if output file already exists
  if [ -f "$OUTPUT" ]; then
    echo -e "''${YELLOW}Warning: Output file '$OUTPUT' already exists''${NC}"
    read -p "Overwrite? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Conversion cancelled."
      exit 0
    fi
  fi

  echo -e "''${GREEN}Converting:''${NC} $INPUT"
  echo -e "''${GREEN}Output:''${NC} $OUTPUT"
  echo -e "''${GREEN}Profile:''${NC} DNxHR HQ (yuv422p)"
  echo ""

  # Convert video to DNxHR format
  # -vsync 1: Ensure proper sync
  # -async 1: Audio sync
  # -c:v dnxhd: Use DNxHD codec
  # -profile:v dnxhr_hq: High Quality profile (good balance of quality and size)
  # -c:a pcm_s16le: 16-bit PCM audio (widely compatible)
  # -pix_fmt yuv422p: Pixel format required for DNxHR

  ${pkgs.ffmpeg}/bin/ffmpeg -i "$INPUT" \
    -vsync 1 \
    -async 1 \
    -c:v dnxhd \
    -profile:v dnxhr_hq \
    -c:a pcm_s16le \
    -pix_fmt yuv422p \
    "$OUTPUT"

  if [ $? -eq 0 ]; then
    echo ""
    echo -e "''${GREEN}✓ Conversion complete!''${NC}"
    echo -e "Output file: $OUTPUT"

    # Show file sizes
    INPUT_SIZE=$(du -h "$INPUT" | cut -f1)
    OUTPUT_SIZE=$(du -h "$OUTPUT" | cut -f1)
    echo -e "Original size: $INPUT_SIZE"
    echo -e "Converted size: $OUTPUT_SIZE"
  else
    echo -e "''${RED}✗ Conversion failed''${NC}"
    exit 1
  fi
''
