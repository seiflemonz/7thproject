import 'package:flutter/material.dart';
import 'search_and_results_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Book Finder',
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.cyan.shade700,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the image with rounded corners
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // Adjust radius for smoother edges
              child: Image.asset(
                'assets/icon.png', // Path to your icon image
                width: 300,        // Adjust width as needed
                height: 300,       // Adjust height as needed
                fit: BoxFit.cover, // Ensures the image fits within the rounded container
              ),
            ),
            SizedBox(height: 24.0), // Space between image and buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchAndResultsScreen()),
                );
              },
              child: Text('Find a Book',
              style: TextStyle(color: Colors.cyan.shade700),),
            ),
            SizedBox(height: 16.0), // Space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(100, 40),
              ),
              child: Text('Logout',
              style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
