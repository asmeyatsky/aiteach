// frontend/lib/data/mappers/forum_post_mapper.dart
import 'package:frontend/data/models/forum_post_model.dart';
import 'package:frontend/domain/entities/forum_post.dart';
import 'package:frontend/data/mappers/user_mapper.dart';
import 'package:frontend/data/mappers/forum_comment_mapper.dart';

class ForumPostMapper {
  static ForumPost fromModel(ForumPostModel model) {
    return ForumPost(
      id: model.id,
      userId: model.userId,
      title: model.title,
      body: model.body,
      createdAt: model.createdAt,
      owner: UserMapper.fromModel(model.owner),
      comments: model.comments.map((comment) => ForumCommentMapper.fromModel(comment)).toList(),
    );
  }

  static ForumPostModel toModel(ForumPost entity) {
    return ForumPostModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      body: entity.body,
      createdAt: entity.createdAt,
      owner: UserMapper.toModel(entity.owner),
      comments: entity.comments.map((comment) => ForumCommentMapper.toModel(comment)).toList(),
    );
  }
}
