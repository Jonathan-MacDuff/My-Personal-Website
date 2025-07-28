import smtplib
from email.message import EmailMessage
import os

EMAIL_ADDRESS = os.getenv("EMAIL_ADDRESS")
EMAIL_PASSWORD = os.getenv("EMAIL_PASSWORD")

def send_contact_email(name, phone, email, message, contact_methods):
    contact_str = ', '.join([method for method, selected in contact_methods.items() if selected])
    msg = EmailMessage()
    msg['Subject'] = f'New Contact Form Message from {name}'
    msg['From'] = EMAIL_ADDRESS
    msg['To'] = EMAIL_ADDRESS

    msg.set_content(
        f"Name: {name}\n"
        f"Email: {email}\n"
        f"Phone: {phone}\n"
        f"Preferred Contact: {contact_str or 'Not specified'}\n\n"
        f"Message:\n{message}"
    )

    with smtplib.SMTP_SSL('smtp.office365.com', 465) as smtp:
        smtp.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
        smtp.send_message(msg)