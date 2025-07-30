import os
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail

SENDGRID_API_KEY = os.getenv("SENDGRID_API_KEY")
EMAIL_ADDRESS = os.getenv("EMAIL_ADDRESS")

def send_contact_email(name, phone, email, message, contact_methods):
    contact_str = ', '.join([method for method, selected in contact_methods.items() if selected])
    content = (
        f"Name: {name}\n"
        f"Email: {email}\n"
        f"Phone: {phone}\n"
        f"Preferred Contact: {contact_str or 'Not specified'}\n\n"
        f"Message:\n{message}"
    )

    msg = Mail(
        from_email=EMAIL_ADDRESS,
        to_emails=EMAIL_ADDRESS,
        subject=f'New Contact Form Message from {name}',
        plain_text_content=content,
    )
    sg = SendGridAPIClient(SENDGRID_API_KEY)
    sg.send(msg)