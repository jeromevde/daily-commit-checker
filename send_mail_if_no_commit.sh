TODAY=$(date +%Y-%m-%d)

echo "[INFO] Checking commits for GitHub user: $GITHUB_USER on $TODAY"
echo "[INFO] Using email: $EMAIL_USER"

EVENTS=$(curl -s "https://api.github.com/users/${GITHUB_USER}/events?per_page=30")
 
echo "date of today: $TODAY"
echo $EVENTS

COMMIT_FOUND=$(echo "$EVENTS" | jq --arg TODAY "$TODAY" '
any(.[]; .type == "PushEvent" and (.created_at | split("T")[0] == $TODAY))')

echo "Commit found ? $COMMIT_FOUND"

if [ "$COMMIT_FOUND" = "true" ]; then
    echo "Email not sent"
else
    echo "[INFO] Sending email notification via Gmail SMTP for user $GITHUB_USER to/from $EMAIL_USER"
    RESPONSE=$(curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
        --mail-from "$EMAIL_USER" \
        --mail-rcpt "$EMAIL_USER" \
        --upload-file <(echo -e "Subject: Daily Commit Checker\n\n$GITHUB_USER did not commit to a public repo today.") \
        --user "$EMAIL_USER:$GMAIL_TOKEN" 2>&1)
    CURL_EXIT_CODE=$?
    if [ $CURL_EXIT_CODE -eq 0 ]; then
        echo "[INFO] Email sent successfully"
    else
        echo "[ERROR] Failed to send email. Curl exit code: $CURL_EXIT_CODE"
    fi
fi
