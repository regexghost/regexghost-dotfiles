#!/bin/sh

TEMP_FILE="/tmp/teen_vogue_article.html"
OUTPUT_FILE="/tmp/teen_vogue_article.md"

curl -s "$1" > "$TEMP_FILE"

title="$(cat "$TEMP_FILE" | pup 'meta[property="og:title"] attr{content}' | xmlstarlet unesc)"
description="$(cat "$TEMP_FILE" | pup 'meta[name="description"] attr{content}' | xmlstarlet unesc)"
picture="$(cat "$TEMP_FILE" | pup 'img attr{src}' | head -n 2 | tail -n 1)"
picture_desc="$(cat "$TEMP_FILE" | pup 'div [class*="CaptionWrapper"]:nth-of-type(1) text{}' | xmlstarlet unesc)"

echo "# $title" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "> $description" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "![${picture_desc}](${picture})" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "## Article" >> "$OUTPUT_FILE"

end="$(cat "$TEMP_FILE" | sed 's/<\/h2>/<\/h2>\n/g' | grep -n "Want more great .* stories" | head -n 1 | cut -d ":" -f 1)"
content="$(cat "$TEMP_FILE" | sed 's/<\/h2>/<\/h2>\n/g' | head -n "$end" | sed 's/<b[^>]*>[^<]*<\/b>//g' |\
sed 's/<!-- -->external//g' |\
sed 's/<span[^>]*>[^<]*<\/span>//g' |\
sed 's/<em[^>]*>[^<]*<\/em>//g' |\
sed 's/<strong[^>]*>[^<]*<\/strong>//g' |\
sed 's/<a[^>]*>/ /g' | \
sed 's/<\/a>//g' |\
 pup | pup 'p text{}' | sed 's/^[ ]*//g' | xmlstarlet unesc | awk 'NF > 0 {blank=0} NF == 0 {blank++} blank < 2')"

echo "$content" | fold -s >> "$OUTPUT_FILE"

${PAGER:-less} "$OUTPUT_FILE"
