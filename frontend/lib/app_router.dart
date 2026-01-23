import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import 'package:frontend/models/lesson.dart';
import 'package:frontend/models/forum_post.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
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
        final lesson = state.extra as Lesson; // Assuming lesson object is passed as extra
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
        final post = state.extra as ForumPost; // Assuming post object is passed as extra
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
