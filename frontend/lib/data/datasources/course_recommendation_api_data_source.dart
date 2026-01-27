// frontend/lib/data/datasources/course_recommendation_api_data_source.dart
import 'package:frontend/data/models/course_recommendation_model.dart';
import 'package:frontend/domain/value_objects/proficiency_level.dart';

class CourseRecommendationApiDataSource {
  // Mock course recommendations based on proficiency levels
  static final List<CourseRecommendationModel> _allCourses = [
    // Beginner courses
    CourseRecommendationModel(
      id: 1,
      title: 'Introduction to Artificial Intelligence',
      description:
          'Learn the fundamentals of AI and its real-world applications. Perfect for beginners with no prior experience.',
      category: 'Fundamentals',
      recommendedLevel: ProficiencyLevel.beginner,
      estimatedHours: 10,
      rating: 4.8,
      enrolledCount: 15420,
      skillsCovered: ['AI Concepts', 'Problem Solving', 'Ethics'],
    ),
    CourseRecommendationModel(
      id: 2,
      title: 'Python for Data Science',
      description:
          'Master Python programming for data analysis and manipulation. Essential foundation for AI/ML work.',
      category: 'Programming',
      recommendedLevel: ProficiencyLevel.beginner,
      estimatedHours: 15,
      rating: 4.7,
      enrolledCount: 22150,
      skillsCovered: ['Python', 'NumPy', 'Pandas', 'Data Visualization'],
    ),
    CourseRecommendationModel(
      id: 3,
      title: 'Mathematics for Machine Learning',
      description:
          'Essential mathematical concepts for understanding machine learning algorithms.',
      category: 'Mathematics',
      recommendedLevel: ProficiencyLevel.beginner,
      estimatedHours: 12,
      rating: 4.6,
      enrolledCount: 8760,
      skillsCovered: ['Linear Algebra', 'Statistics', 'Calculus'],
    ),

    // Intermediate courses
    CourseRecommendationModel(
      id: 4,
      title: 'Machine Learning Fundamentals',
      description:
          'Core concepts and algorithms in supervised and unsupervised learning.',
      category: 'Machine Learning',
      recommendedLevel: ProficiencyLevel.intermediate,
      estimatedHours: 20,
      rating: 4.9,
      enrolledCount: 9850,
      skillsCovered: [
        'Regression',
        'Classification',
        'Clustering',
        'Scikit-learn',
      ],
    ),
    CourseRecommendationModel(
      id: 5,
      title: 'Deep Learning with TensorFlow',
      description:
          'Build and train neural networks using TensorFlow and Keras.',
      category: 'Deep Learning',
      recommendedLevel: ProficiencyLevel.intermediate,
      estimatedHours: 25,
      rating: 4.8,
      enrolledCount: 7640,
      skillsCovered: ['Neural Networks', 'TensorFlow', 'CNN', 'RNN'],
    ),
    CourseRecommendationModel(
      id: 6,
      title: 'Natural Language Processing',
      description:
          'Process and analyze human language data using modern NLP techniques.',
      category: 'NLP',
      recommendedLevel: ProficiencyLevel.intermediate,
      estimatedHours: 18,
      rating: 4.7,
      enrolledCount: 5430,
      skillsCovered: ['Text Processing', 'Transformers', 'BERT', 'HuggingFace'],
    ),

    // Advanced courses
    CourseRecommendationModel(
      id: 7,
      title: 'Advanced Deep Learning Research',
      description:
          'Cutting-edge techniques in deep learning and research methodologies.',
      category: 'Research',
      recommendedLevel: ProficiencyLevel.advanced,
      estimatedHours: 30,
      rating: 4.9,
      enrolledCount: 1250,
      skillsCovered: [
        'GANs',
        'Reinforcement Learning',
        'Autoencoders',
        'Research Methods',
      ],
    ),
    CourseRecommendationModel(
      id: 8,
      title: 'Computer Vision Mastery',
      description:
          'Advanced computer vision techniques for image and video analysis.',
      category: 'Computer Vision',
      recommendedLevel: ProficiencyLevel.advanced,
      estimatedHours: 28,
      rating: 4.8,
      enrolledCount: 980,
      skillsCovered: [
        'CNN Architectures',
        'Object Detection',
        'Segmentation',
        'YOLO',
      ],
    ),
    CourseRecommendationModel(
      id: 9,
      title: 'AI Leadership and Strategy',
      description:
          'Lead AI initiatives and drive organizational transformation.',
      category: 'Business',
      recommendedLevel: ProficiencyLevel.advanced,
      estimatedHours: 15,
      rating: 4.6,
      enrolledCount: 650,
      skillsCovered: [
        'AI Strategy',
        'Change Management',
        'ROI Analysis',
        'Team Leadership',
      ],
    ),
  ];

  Future<List<CourseRecommendationModel>> getRecommendedCourses(
    int userId,
  ) async {
    // For now, this is a mock implementation. In a real scenario, this would be an API call.
    // The userId would be used to fetch the user's proficiency and then filter/sort courses.
    // For demonstration, we'll just return all courses.
    return Future.value(_allCourses);
  }
}
