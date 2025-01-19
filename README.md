


# Daily User Commit Checker

This script checks if a specific GitHub user has committed today and sends an email if not. It can be run daily via GitHub Actions or locally for debugging.

## Run Locally

```bash
export GITHUB_USER="your_target_user" TARGET_MAIL="your_email@gmail.com" GMAIL_TOKEN="your_gmail_app_password_or_oauth_token" && ./send_mail_if_no_commit.sh
```

Your GMAIL_TOKEN can be found [here](https://myaccount.google.com/apppasswords)

## Run using github actions

Setup the two following secrets 
- EMAIL_USER
- GMAIL_TOKEN

at the following adderess after substituting your username: 
```
[YOUR_REPO_LINK]/settings/secrets/actions
```