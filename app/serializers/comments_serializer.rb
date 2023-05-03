class CommentsSerializer < ActiveModel::Serializer
  attributes :id, :content, :parent_id, :user_id, :article_id
end
