import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/presentation/screens/course_catalog_screen.dart';
import 'package:frontend/presentation/screens/forum_list_screen.dart';
import 'package:frontend/presentation/screens/profile_screen.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/presentation/widgets/animated_app_bar.dart';
import 'package:frontend/presentation/widgets/responsive_layout.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    CourseCatalogScreen(),
    ForumListScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);

    return ResponsiveLayout(
      mobile: _buildMobileLayout(authService),
      tablet: _buildTabletLayout(authService),
      desktop: _buildDesktopLayout(authService),
    );
  }

  Widget _buildMobileLayout(dynamic authService) {
    return Scaffold(
      appBar: AnimatedAppBar(
        title: 'AI Education Platform',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              // Clear current user state
              ref.read(currentUserProvider.notifier).state = null;
              if (mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildTabletLayout(dynamic authService) {
    return Scaffold(
      appBar: AnimatedAppBar(
        title: 'AI Education Platform',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              // Clear current user state
              ref.read(currentUserProvider.notifier).state = null;
              if (mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.book),
                label: Text('Courses'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.forum),
                label: Text('Forum'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(dynamic authService) {
    return Scaffold(
      appBar: AnimatedAppBar(
        title: 'AI Education Platform',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              // Clear current user state
              ref.read(currentUserProvider.notifier).state = null;
              if (mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.book),
                label: Text('Courses'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.forum),
                label: Text('Forum'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
            extended: true, // Extended navigation rail for desktop
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
