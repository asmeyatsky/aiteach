class CourseRecommendation {
  final int id;
  final String title;
  final String description;
  final String category;
  final ProficiencyLevel recommendedLevel;
  final int estimatedHours;
  final double rating;
  final int enrolledCount;
  final List<String> skillsCovered;

  CourseRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.recommendedLevel,
    required this.estimatedHours,
    required this.rating,
    required this.enrolledCount,
    required this.skillsCovered,
  });
}

class CourseRecommendationService {
  // Mock course recommendations based on proficiency levels
  static final List<CourseRecommendation> _allCourses = [
    // Beginner courses
    CourseRecommendation(
      id: 1,
      title: 'Introduction to Artificial Intelligence',
      description: 'Learn the fundamentals of AI and its real-world applications. Perfect for beginners with no prior experience.',
      category: 'Fundamentals',
      recommendedLevel: ProficiencyLevel.beginner,
      estimatedHours: 10,
      rating: 4.8,
      enrolledCount: 15420,
      skillsCovered: ['AI Concepts', 'Problem Solving', 'Ethics'],
    ),
    CourseRecommendation(
      id: 2,
      title: 'Python for Data Science',
      description: 'Master Python programming for data analysis and manipulation. Essential foundation for AI/ML work.',
      category: 'Programming',
      recommendedLevel: ProficiencyLevel.beginner,
      estimatedHours: 15,
      rating: 4.7,
      enrolledCount: 22150,
      skillsCovered: ['Python', 'NumPy', 'Pandas', 'Data Visualization'],
    ),
    CourseRecommendation(
      id: 3,
      title: 'Mathematics for Machine Learning',
      description: 'Essential mathematical concepts for understanding machine learning algorithms.',
      category: 'Mathematics',
      recommendedLevel: ProficiencyLevel.beginner,
      estimatedHours: 12,
      rating: 4.6,
      enrolledCount: 8760,
      skillsCovered: ['Linear Algebra', 'Statistics', 'Calculus'],
    ),
    
    // Intermediate courses
    CourseRecommendation(
      id: 4,
      title: 'Machine Learning Fundamentals',
      description: 'Core concepts and algorithms in supervised and unsupervised learning.',
      category: 'Machine Learning',
      recommendedLevel: ProficiencyLevel.intermediate,
      estimatedHours: 20,
      rating: 4.9,
      enrolledCount: 9850,
      skillsCovered: ['Regression', 'Classification', 'Clustering', 'Scikit-learn'],
    ),
    CourseRecommendation(
      id: 5,
      title: 'Deep Learning with TensorFlow',
      description: 'Build and train neural networks using TensorFlow and Keras.',
      category: 'Deep Learning',
      recommendedLevel: ProficiencyLevel.intermediate,
      estimatedHours: 25,
      rating: 4.8,
      enrolledCount: 7640,
      skillsCovered: ['Neural Networks', 'TensorFlow', 'CNN', 'RNN'],
    ),
    CourseRecommendation(
      id: 6,
      title: 'Natural Language Processing',
      description: 'Process and analyze human language data using modern NLP techniques.',
      category: 'NLP',
      recommendedLevel: ProficiencyLevel.intermediate,
      estimatedHours: 18,
      rating: 4.7,
      enrolledCount: 5430,
      skillsCovered: ['Text Processing', 'Transformers', 'BERT', 'HuggingFace'],
    ),
    
    // Advanced courses
    CourseRecommendation(
      id: 7,
      title: 'Advanced Deep Learning Research',
      description: 'Cutting-edge techniques in deep learning and research methodologies.',
      category: 'Research',
      recommendedLevel: ProficiencyLevel.advanced,
      estimatedHours: 30,
      rating: 4.9,
      enrolledCount: 1250,
      skillsCovered: ['GANs', 'Reinforcement Learning', 'Autoencoders', 'Research Methods'],
    ),
    CourseRecommendation(
      id: 8,
      title: 'Computer Vision Mastery',
      description: 'Advanced computer vision techniques for image and video analysis.',
      category: 'Computer Vision',
      recommendedLevel: ProficiencyLevel.advanced,
      estimatedHours: 28,
      rating: 4.8,
      enrolledCount: 980,
      skillsCovered: ['CNN Architectures', 'Object Detection', 'Segmentation', 'YOLO'],
    ),
    CourseRecommendation(
      id: 9,
      title: 'AI Leadership and Strategy',
      description: 'Lead AI initiatives and drive organizational transformation.',
      category: 'Business',
      recommendedLevel: ProficiencyLevel.advanced,
      estimatedHours: 15,
      rating: 4.6,
      enrolledCount: 650,
      skillsCovered: ['AI Strategy', 'Change Management', 'ROI Analysis', 'Team Leadership'],
    ),
  ];

  static List<CourseRecommendation> getRecommendedCourses(ProficiencyLevel userLevel) {
    // Filter courses by proficiency level
    List<CourseRecommendation> filteredCourses = _allCourses
        .where((course) => course.recommendedLevel == userLevel)
        .toList();

    // Sort by rating and enrollment count for popularity
    filteredCourses.sort((a, b) {
      if (b.rating != a.rating) {
        return b.rating.compareTo(a.rating);
      }
      return b.enrolledCount.compareTo(a.enrolledCount);
    });

    return filteredCourses;
  }

  static List<CourseRecommendation> getPopularCourses() {
    // Return top-rated courses across all levels
    List<CourseRecommendation> popularCourses = List.from(_allCourses);
    popularCourses.sort((a, b) {
      if (b.rating != a.rating) {
        return b.rating.compareTo(a.rating);
      }
      return b.enrolledCount.compareTo(a.enrolledCount);
    });
    return popularCourses.take(6).toList();
  }

  static List<CourseRecommendation> searchCourses(String query) {
    return _allCourses
        .where((course) => 
            course.title.toLowerCase().contains(query.toLowerCase()) ||
            course.description.toLowerCase().contains(query.toLowerCase()) ||
            course.skillsCovered.any((skill) => skill.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  static List<CourseRecommendation> getCoursesByCategory(String category) {
    return _allCourses
        .where((course) => course.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}