import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/presentation/screens/main_screen.dart';
import 'package:frontend/presentation/screens/course_details_screen.dart';
import 'package:frontend/presentation/screens/lesson_view_screen.dart';
import 'package:frontend/presentation/screens/login_screen.dart';
import 'package:frontend/presentation/screens/registration_screen.dart';
import 'package:frontend/presentation/screens/forum_list_screen.dart';
import 'package:frontend/presentation/screens/create_post_screen.dart';
import 'package:frontend/presentation/screens/forum_post_details_screen.dart';
import 'package:frontend/presentation/screens/splash_screen.dart';
import 'package:frontend/presentation/screens/proficiency_assessment_screen.dart';
import 'package:frontend/presentation/screens/playground_screen.dart';
import 'package:frontend/presentation/screens/project_list_screen.dart';
import 'package:frontend/presentation/screens/feed_screen.dart';
import 'package:frontend/presentation/screens/suggestion_screen.dart';
import 'package:frontend/data/models/lesson_model.dart';
import 'package:frontend/data/models/forum_post_model.dart';
import 'package:frontend/data/mappers/forum_post_mapper.dart';

const _publicRoutes = {'/splash', '/login', '/register'};
const _storage = FlutterSecureStorage();

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  redirect: (BuildContext context, GoRouterState state) async {
    final location = state.matchedLocation;
    if (_publicRoutes.contains(location)) {
      return null;
    }
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      return '/login';
    }
    return null;
  },
  errorBuilder: (BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Page not found', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },
  routes: <GoRoute>[
    GoRoute(
      path: '/splash',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegistrationScreen();
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MainScreen();
      },
    ),
    GoRoute(
      path: '/courses/:courseId',
      builder: (BuildContext context, GoRouterState state) {
        final courseId = int.parse(state.pathParameters['courseId']!);
        return CourseDetailsScreen(courseId: courseId);
      },
    ),
    GoRoute(
      path: '/lessons/:lessonId',
      builder: (BuildContext context, GoRouterState state) {
        final lesson = state.extra as LessonModel?;
        if (lesson == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Lesson data not available')),
          );
        }
        return LessonViewScreen(lesson: lesson);
      },
    ),
    GoRoute(
      path: '/forum',
      builder: (BuildContext context, GoRouterState state) {
        return const ForumListScreen();
      },
    ),
    GoRoute(
      path: '/forum/create',
      builder: (BuildContext context, GoRouterState state) {
        return const CreatePostScreen();
      },
    ),
    GoRoute(
      path: '/forum/posts/:postId',
      builder: (BuildContext context, GoRouterState state) {
        final postModel = state.extra as ForumPostModel?;
        if (postModel == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Post data not available')),
          );
        }
        final post = ForumPostMapper.fromModel(postModel);
        return ForumPostDetailsScreen(post: post);
      },
    ),
    GoRoute(
      path: '/proficiency-assessment',
      builder: (BuildContext context, GoRouterState state) {
        return const ProficiencyAssessmentScreen();
      },
    ),
    GoRoute(
      path: '/playground',
      builder: (BuildContext context, GoRouterState state) {
        return const PlaygroundScreen();
      },
    ),
    GoRoute(
      path: '/projects',
      builder: (BuildContext context, GoRouterState state) {
        return const ProjectListScreen();
      },
    ),
    GoRoute(
      path: '/feed',
      builder: (BuildContext context, GoRouterState state) {
        return const FeedScreen();
      },
    ),
    GoRoute(
      path: '/suggest-content',
      builder: (BuildContext context, GoRouterState state) {
        return const SuggestionScreen();
      },
    ),
  ],
);
