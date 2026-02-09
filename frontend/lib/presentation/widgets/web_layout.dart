import 'package:flutter/material.dart';
import 'package:frontend/config/app_colors.dart';
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
          color: AppColors.surface,
          child: Column(
            children: [
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.neonCyan,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const ListTile(
                leading: Icon(Icons.book),
                title: Text('Courses'),
              ),
              const ListTile(
                leading: Icon(Icons.forum),
                title: Text('Forum'),
              ),
              const ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
              ),
              const Spacer(),
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              const ListTile(
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
          color: AppColors.surface,
          child: Column(
            children: [
              const SizedBox(height: 32),
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.neonCyan,
                child: const Icon(Icons.person, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'AI Education Platform',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonCyan,
                ),
              ),
              const SizedBox(height: 32),
              const ListTile(
                leading: Icon(Icons.book, size: 30),
                title: Text(
                  'Courses',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.forum, size: 30),
                title: Text(
                  'Forum',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.person, size: 30),
                title: Text(
                  'Profile',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Spacer(),
              const ListTile(
                leading: Icon(Icons.settings, size: 30),
                title: Text(
                  'Settings',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.help, size: 30),
                title: Text(
                  'Help',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 32),
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