import 'package:frontend/data/models/course_model.dart';

class CourseRecommendationApiDataSource {
  // Mock course recommendations based on proficiency levels
  static final List<CourseModel> _allCourses = [
    // Beginner courses
    CourseModel(
      id: 1,
      title: 'Introduction to Artificial Intelligence',
      description: 'Learn the fundamentals of AI and its real-world applications. Perfect for beginners with no prior experience.',
      tier: 'beginner',
      thumbnailUrl: '',
    ),
    CourseModel(
      id: 2,
      title: 'Python for Data Science',
      description: 'Master Python programming for data analysis and manipulation. Essential foundation for AI/ML work.',
      tier: 'beginner',
      thumbnailUrl: '',
    ),
    CourseModel(
      id: 3,
      title: 'Mathematics for Machine Learning',
      description: 'Essential mathematical concepts for understanding machine learning algorithms.',
      tier: 'beginner',
      thumbnailUrl: '',
    ),

    // Intermediate courses
    CourseModel(
      id: 4,
      title: 'Machine Learning Fundamentals',
      description: 'Core concepts and algorithms in supervised and unsupervised learning.',
      tier: 'intermediate',
      thumbnailUrl: '',
    ),
    CourseModel(
      id: 5,
      title: 'Deep Learning with TensorFlow',
      description: 'Build and train neural networks using TensorFlow and Keras.',
      tier: 'intermediate',
      thumbnailUrl: '',
    ),
    CourseModel(
      id: 6,
      title: 'Natural Language Processing',
      description: 'Process and analyze human language data using modern NLP techniques.',
      tier: 'intermediate',
      thumbnailUrl: '',
    ),

    // Advanced courses
    CourseModel(
      id: 7,
      title: 'Advanced Deep Learning Research',
      description: 'Cutting-edge techniques in deep learning and research methodologies.',
      tier: 'advanced',
      thumbnailUrl: '',
    ),
    CourseModel(
      id: 8,
      title: 'Computer Vision Mastery',
      description: 'Advanced computer vision techniques for image and video analysis.',
      tier: 'advanced',
      thumbnailUrl: '',
    ),
    CourseModel(
      id: 9,
      title: 'AI Leadership and Strategy',
      description: 'Lead AI initiatives and drive organizational transformation.',
      tier: 'advanced',
      thumbnailUrl: '',
    ),
  ];

  Future<List<CourseModel>> getRecommendedCourses(int userId) async {
    // For now, this is a mock implementation. In a real scenario, this would be an API call.
    // The userId would be used to fetch the user's proficiency and then filter/sort courses.
    // For demonstration, we'll just return all courses.
    return Future.value(_allCourses);
  }
}
