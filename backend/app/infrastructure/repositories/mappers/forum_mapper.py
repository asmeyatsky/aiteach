from app.domain.entities.forum import ForumPost as ForumPostDomain, ForumComment as ForumCommentDomain
from app.infrastructure.repositories.orm.forum import ForumPost as ForumPostORM, ForumComment as ForumCommentORM

def to_post_domain(orm_post: ForumPostORM) -> ForumPostDomain:
    return ForumPostDomain(
        id=orm_post.id,
        user_id=orm_post.user_id,
        title=orm_post.title,
        body=orm_post.body,
        created_at=orm_post.created_at
    )

def to_comment_domain(orm_comment: ForumCommentORM) -> ForumCommentDomain:
    return ForumCommentDomain(
        id=orm_comment.id,
        post_id=orm_comment.post_id,
        user_id=orm_comment.user_id,
        body=orm_comment.body,
        created_at=orm_comment.created_at
    )
