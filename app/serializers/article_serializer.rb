class ArticleSerializer < ActiveModel::Serializer
  include JSONAPI::Serializer

  attributes :id, :title, :body, :likes, :dislikes, :status, :user_id, :image_url

end
