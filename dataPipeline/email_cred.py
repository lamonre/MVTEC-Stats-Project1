import smtplib, ssl
import os

EMAIL_USERNAME = os.environ.get('EMAIL_USERNAME')
EMAIL_PASSWORD = os.environ.get('EMAIL_PASSWORD')

def send_mail(to_addr, subject, body):
    message = f'Subject: {subject}\n\n{body}'
    context = ssl.create_default_context() #create the connection
    with smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context) as server:
        server.login(EMAIL_USERNAME, EMAIL_PASSWORD) #login/authenticate
        server.sendmail(EMAIL_USERNAME, to_addr, message) #send the email