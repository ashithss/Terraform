import boto3

# Replace with your AWS access key and secret key
aws_access_key = "YOUR_ACCESS_KEY"
aws_secret_key = "YOUR_SECRET_KEY"

# Replace with your AWS SES verified sender email
sender_email = "example@gmail.com"

# Replace with the recipient email
recipient_email = "recipient@example.com"

# AWS SES region
aws_region = "us-east-1"

# Create an SES client
client = boto3.client(
    "ses",
    aws_access_key_id=aws_access_key,
    aws_secret_access_key=aws_secret_key,
    region_name=aws_region
)

# Send email
response = client.send_email(
    Source=sender_email,
    Destination={"ToAddresses": [recipient_email]},
    Message={
        "Subject": {"Data": "Test Email"},
        "Body": {"Text": {"Data": "This is a test email sent from AWS SES."}},
    }
)

print("Email sent. Message ID:", response["MessageId"])
