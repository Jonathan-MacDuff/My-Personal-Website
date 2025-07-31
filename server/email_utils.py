import os
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
from dotenv import load_dotenv

load_dotenv()

SENDGRID_API_KEY = os.getenv("SENDGRID_API_KEY")
EMAIL_ADDRESS = os.getenv("EMAIL_ADDRESS")

def send_contact_email(name, phone, email, message, contact_methods):
    contact_str = ', '.join([method for method, selected in contact_methods.items() if selected])

    plain_text = (
        f"Name: {name}\n"
        f"Email: {email}\n"
        f"Phone: {phone or 'Not provided'}\n"
        f"Preferred Contact Method(s): {contact_str or 'Not specified'}\n\n"
        f"Message:\n{message}"
    )

    html_content = f"""
    <html>
      <body style="font-family: Arial, sans-serif; background-color: #f9f9f9; padding: 20px;">
        <div style="max-width: 600px; margin: auto; background-color: #ffffff; border-radius: 8px; padding: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
          <h2 style="color: #333;">New Contact Form Message</h2>
          <p><strong>Name:</strong> {name}</p>
          <p><strong>Email:</strong> {email}</p>
          <p><strong>Phone:</strong> {phone or 'Not provided'}</p>
          <p><strong>Preferred Contact Method(s):</strong> {contact_str or 'Not specified'}</p>
          <hr style="margin: 20px 0;">
          <p style="white-space: pre-wrap;"><strong>Message:</strong><br>{message}</p>
        </div>
      </body>
    </html>
    """

    try:
        sg = SendGridAPIClient(SENDGRID_API_KEY)
        msg = Mail(
            from_email='noreply@autistic-insight.com',
            to_emails=EMAIL_ADDRESS,
            subject=f'New Contact Form Message from {name}',
            plain_text_content=plain_text,
            html_content=html_content
        )
        response = sg.send(msg)
        print(f"SendGrid response status: {response.status_code}")
        return response.status_code
    except Exception as e:
        print("SendGrid error:", e)
        raise