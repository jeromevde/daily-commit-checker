TODAY=$(date +%Y-%m-%d)

echo "[INFO] Checking commits for GitHub user: $GITHUB_USER on $TODAY"
echo "[INFO] Using email: $EMAIL_USER"

# Check recent commits directly from repositories
echo "[INFO] Checking recent commits from repositories..."
RECENT_COMMITS=$(curl -s "https://api.github.com/users/${GITHUB_USER}/repos?per_page=10&sort=pushed" | jq -r '.[] | select(.pushed_at | startswith("'$TODAY'")) | .full_name')

if [ -n "$RECENT_COMMITS" ]; then
    echo "[DEBUG] Found repositories with commits today: $RECENT_COMMITS"
    COMMIT_FOUND="true"
else
    echo "[DEBUG] No repositories found with commits today"
    COMMIT_FOUND="false"
fi


if [ "$COMMIT_FOUND" = "true" ]; then
    echo "Email not sent"
else
    echo "[INFO] Sending email notification via Gmail SMTP for user $GITHUB_USER to/from $EMAIL_USER"
    RESPONSE=$(curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
        --mail-from "$EMAIL_USER" \
        --mail-rcpt "$EMAIL_USER" \
        --upload-file <(echo -e "Subject: Commit every day \n\n$GITHUB_USER did not commit to a public repo today") \
        --user "$EMAIL_USER:$GMAIL_TOKEN" 2>&1)
    CURL_EXIT_CODE=$?
    if [ $CURL_EXIT_CODE -eq 0 ]; then
        echo "[INFO] Email sent successfully"
    else
        echo "[ERROR] Failed to send email. Curl exit code: $CURL_EXIT_CODE"
    fi
fi
