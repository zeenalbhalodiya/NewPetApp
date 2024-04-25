import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/colors.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: appColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            ContactCard(
              name: 'Hemani Bhalala',
              email: 'hemanibhalala26@gmail.com',
              phone: '8799136733',
            ),
            SizedBox(height: 20),
            ContactCard(
              name: 'Zeenal Bhalodiya',
              email: 'bhalodiyazeenal@gmail.com',
              phone: '8799478161',
            ),
            SizedBox(height: 20),
            ContactCard(
              name: 'Chand Desai',
              email: 'chanddesai733@gmail.com',
              phone: '9913311833',
            ),
            SizedBox(height: 20),
            ContactCard(
              name: 'Jency Navadiya',
              email: 'jencynavadiya@gmail.com',
              phone: '8320634491',
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;

  const ContactCard({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _launchEmail(email),
                  child: Text(
                    email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.green),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _launchPhone(phone),
                  child: Text(
                    phone,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchEmail(String email) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    final String uri = _emailLaunchUri.toString();

    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
