class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
  session[:page_views] ||= 0  # Set initial value to 0 if session[:page_views] is nil
  session[:page_views] += 1   # Increment page_views by 1 for each request

  if session[:page_views] <= 3
    # User has viewed 3 or fewer pages, render the article data
    article = Article.find(params[:id])
    render json: article
  else
    # User has viewed more than 3 pages, render an error message and unauthorized status
    render json: { error: "You have reached the maximum page views limit." }, status: :unauthorized
  end
end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
