import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/responsive_layout.dart';

class WebLayout extends StatelessWidget {
  final Widget child;

  const WebLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(child),
        tablet: _buildTabletLayout(child),
        desktop: _buildDesktopLayout(child),
      ),
    );
  }

  Widget _buildMobileLayout(Widget child) {
    return child;
  }

  Widget _buildTabletLayout(Widget child) {
    return Row(
      children: [
        // Sidebar for tablet
        Container(
          width: 200,
          color: Colors.blueGrey[50],
          child: const Column(
            children: [
              SizedBox(height: 16),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Courses'),
              ),
              ListTile(
                leading: Icon(Icons.forum),
                title: Text('Forum'),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
              ),
              Spacer(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
              ),
            ],
          ),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildDesktopLayout(Widget child) {
    return Row(
      children: [
        // Full sidebar for desktop
        Container(
          width: 250,
          color: Colors.blueGrey[50],
          child: const Column(
            children: [
              SizedBox(height: 32),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, color: Colors.white, size: 40),
              ),
              SizedBox(height: 16),
              Text(
                'AI Education Platform',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 32),
              ListTile(
                leading: Icon(Icons.book, size: 30),
                title: Text(
                  'Courses',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              ListTile(
                leading: Icon(Icons.forum, size: 30),
                title: Text(
                  'Forum',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person, size: 30),
                title: Text(
                  'Profile',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Spacer(),
              ListTile(
                leading: Icon(Icons.settings, size: 30),
                title: Text(
                  'Settings',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              ListTile(
                leading: Icon(Icons.help, size: 30),
                title: Text(
                  'Help',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: child,
          ),
        ),
      ],
    );
  }
}