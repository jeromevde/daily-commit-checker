TODAY=$(date +%Y-%m-%d)

EVENTS=$(curl -s "https://api.github.com/users/${GITHUB_USER}/events?per_page=10")

echo $EVENTS
echo ""

COMMIT_FOUND=$(echo "$EVENTS" | jq -r --arg TODAY "$TODAY" '
.[] | select(.type == "PushEvent") | 
.created_at | startswith($TODAY)')

if [ "$COMMIT_FOUND" = "true" ]; then
    echo "Email not sent"
else
    curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
        --mail-from $EMAIL_USER \
        --mail-rcpt $EMAIL_USER \
        --upload-file <(echo -e "Subject: Daily Commit Checker\n\n$GITHUB_USER did not commit to a public repo today.") \
        --user "$EMAIL_USER:$GMAIL_TOKEN"
    echo "Email sent"
fi
