import os
import smtplib
from email.message import EmailMessage

EMAIL_ADDRESS = os.getenv("EMAIL_ADDRESS")  # e.g., noreply@autistic-insight.com
EMAIL_PASSWORD = os.getenv("EMAIL_PASSWORD")  # SMTP2GO SMTP password
TO_EMAIL = "jonathan.macduff@outlook.com"  # where you want to receive messages

def send_contact_email(name, phone, email, message, contact_methods):
    contact_str = ', '.join([m for m, selected in contact_methods.items() if selected])
    msg = EmailMessage()
    msg["Subject"] = f"New Contact Form Message from {name}"
    msg["From"] = EMAIL_ADDRESS
    msg["To"] = TO_EMAIL
    msg.set_content(
        f"Name: {name}\n"
        f"Email: {email}\n"
        f"Phone: {phone or 'Not provided'}\n"
        f"Preferred Contact: {contact_str or 'Not specified'}\n\n"
        f"Message:\n{message}"
    )

    with smtplib.SMTP("mail.smtp2go.com", 587) as smtp:
        smtp.starttls()
        smtp.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
        smtp.send_message(msg)