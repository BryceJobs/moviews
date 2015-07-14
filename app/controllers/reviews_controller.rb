class ReviewsController < ApplicationController

	before_action :set_movie
	
	def create
		@review = @movie.reviews.build(review_params)
		@review.user = current_user
		@review.save
		redirect_to @movie,  notice: "Thank you for Reviewing"
	end

	def destroy
		@movie.reviews.find(params[:id]).destroy
		redirect_to @movie, notice: "Your review was deleted, Plz help us by reviewing movies whenever possible"
	end

	private

	def set_movie
		@movie = Movie.find(params[:movie_id])
	end

	def review_params
		params[:review].permit(:rating, :comment)
	end
end
