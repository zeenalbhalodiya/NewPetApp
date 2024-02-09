import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Us Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactUsPage(),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contact Information:',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            ContactInfoItem(label: 'Name', value: 'Hemani Bhalala', icon: Icons.person),
            ContactInfoItem(label: 'Email', value: 'hemanibhalala26@gmail.com', icon: Icons.email),
            ContactInfoItem(label: 'Phone', value: '8799136733', icon: Icons.phone, isPhoneNumber: true),
            SizedBox(height: 30),
            ContactInfoItem(label: 'Name', value: 'Zeenal Bhalodiya', icon: Icons.person),
            ContactInfoItem(label: 'Email', value: 'bhalodiyazeenal@gmail.com', icon: Icons.email),
            ContactInfoItem(label: 'Phone', value: '8799478161', icon: Icons.phone, isPhoneNumber: true),
            SizedBox(height: 30),
            ContactInfoItem(label: 'Name', value: 'Chand Desai', icon: Icons.person),
            ContactInfoItem(label: 'Email', value: 'chanddesai733@gmail.com', icon: Icons.email),
            ContactInfoItem(label: 'Phone', value: '9913311833', icon: Icons.phone, isPhoneNumber: true),
            SizedBox(height: 30),
            ContactInfoItem(label: 'Name', value: 'Jency Navadiya', icon: Icons.person),
            ContactInfoItem(label: 'Email', value: 'jencynavadiya@gmail.com', icon: Icons.email),
            ContactInfoItem(label: 'Phone', value: '8320634491', icon: Icons.phone, isPhoneNumber: true),
          ],
        ),
      ),
    );
  }
}

class ContactInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isPhoneNumber; // Add isPhoneNumber property

  const ContactInfoItem({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    this.isPhoneNumber = false, // Initialize isPhoneNumber property
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          SizedBox(width: 5),
          Text(
            '$label:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 15),
          isPhoneNumber ? GestureDetector( // Wrap with GestureDetector for phone number
            onTap: () => _launchPhone(value), // Call _launchPhone when tapped
            child: Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ) : Text(
            value,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
  // Function to launch phone app with specified phone number
  _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    try {
      // ignore: deprecated_member_use
      if (await canLaunch(url)) {
        // ignore: deprecated_member_use
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching phone call: $e');
    }
    }
}
