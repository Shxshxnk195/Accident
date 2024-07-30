from flask import Flask, request, jsonify
from flask_mail import Mail, Message

app = Flask(__name__)

app.config['MAIL_SERVER'] = 'smtp.office365.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USERNAME'] = 'rnc.ars@outlook.com'
app.config['MAIL_PASSWORD'] = 'ars@12345'
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USE_SSL'] = False

mail = Mail(app)

@app.route('/send-email', methods=['POST'])
def send_email():
    data = request.get_json()
    receiver_email = data['receiver_email']
    name = data['name']
    coordinates = data['coordinates']
    latitude = coordinates.get('latitude')
    longitude = coordinates.get('longitude')

    try:
        msg = Message('EMERGENCY ALERT', sender='rnc.ars@outlook.com', recipients=[receiver_email])
        msg.body = f"EMERGENCY ALERT\nAmbulance assistance required at the current location:\nLatitude: {latitude}, Longitude: {longitude}\n\nGoogle Maps: https://maps.google.com/?q={latitude},{longitude}"
        mail.send(msg)
        return jsonify({'message': 'Email sent successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run("0.0.0.0" ,port =5000, debug=True)
