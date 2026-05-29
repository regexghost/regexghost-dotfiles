#!/bin/sh

TEMP_FILE="/tmp/bbc_article.html"
OUTPUT_FILE="/tmp/bbc_article.md"

curl -s "$1" > "$TEMP_FILE"

title="$(cat "$TEMP_FILE" | pup 'meta[property="og:title"] attr{content}')"
description="$(cat "$TEMP_FILE" | pup 'meta[property="og:description"] attr{content}' | xmlstarlet unesc)"
picture="$(cat "$TEMP_FILE" | pup 'img attr{src}' | head -n 1 | xmlstarlet unesc)"
picture_desc_json="$(cat "$TEMP_FILE" | pup 'figcaption json{}' | jq -r .[0])"
picture_desc="$(echo "$picture_desc_json" | jq -r .children[1].children[0].text | xmlstarlet unesc)"
if [ "$picture_desc" = "null" ]; then
	picture_desc="$(echo "$picture_desc_json" | jq -r .text | xmlstarlet unesc)"
fi

echo "# $title" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "> $description" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "![${picture_desc}](${picture})" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "## Article" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

cat "$TEMP_FILE" | pup -i 0 'p[class*="Paragraph"],p[class*="HooNV"]' | tr -d "\n" | \
sed 's/<b[^>]*>[^<]*<\/b>//g' |\
sed 's/<!-- -->external//g' |\
sed 's/<span[^>]*>[^<]*<\/span>//g' |\
sed 's/<a[^>]*>/ /g' | \
sed 's/<\/a>//g' |\
sed 's/<p class="[^"]*">/PPSTART/g; s/<\/p>/PPEND/g; s/PPEND/\n/g; s/PPSTART/\n/g' |\
xmlstarlet unesc | grep -v "$picture_desc" | fold -s >> "$OUTPUT_FILE"

${PAGER:-less} "$OUTPUT_FILE"
