// frontend/lib/data/mappers/forum_comment_mapper.dart
import 'package:frontend/data/models/forum_comment_model.dart';
import 'package:frontend/domain/entities/forum_comment.dart';
import 'package:frontend/data/mappers/user_mapper.dart'; // Assuming UserMapper exists

class ForumCommentMapper {
  static ForumComment fromModel(ForumCommentModel model) {
    return ForumComment(
      id: model.id,
      postId: model.postId,
      userId: model.userId,
      body: model.body,
      createdAt: model.createdAt,
      owner: UserMapper.fromModel(model.owner), // Map nested User
    );
  }

  static ForumCommentModel toModel(ForumComment entity) {
    return ForumCommentModel(
      id: entity.id,
      postId: entity.postId,
      userId: entity.userId,
      body: entity.body,
      createdAt: entity.createdAt,
      owner: UserMapper.toModel(entity.owner), // Map nested User
    );
  }
}
