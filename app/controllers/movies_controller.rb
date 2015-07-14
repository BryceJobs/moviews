class MoviesController < ApplicationController
	before_action :set_movie, except: [:index, :new, :create, :search_imdb, :save_imdb]
  rescue_from    ActiveRecord::RecordNotFound, with: :invalid_movie
  def index
  	@movies = Movie.all
  end

  def show
    response = HTTParty.get("http://trailersapi.com/trailers.json?movie="+ CGI.escape(@movie.title) + "&limit=1&width=570")
    @movie.trailer_url = response[0]["code"] unless response.empty?
  end

  def edit
  end

  def new
  	@movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
  	if @movie.save
  		redirect_to @movie, notice: "movie successfully created"
  	else
  		render 'new' , alert: "Something went wrong try again Plz"
  	end
  end

  def update
  	if @movie.update_attributes(movie_params)
  	  redirect_to @movie, notice: "movie successfully updated"
    else
      render 'edit' , alert: "Something went wrong try again Plz"
    end
  end

  def destroy
  	movie = @movie
  	@movie.destroy
  	redirect_to movies_path, notice: "the movie #{movie.name} was deleted"
  end

  #imdb method

  def search_imdb
    imdb = ImdbParty::Imdb.new(:anonymize => true)
    title = params[:imdb_search][:title]
    @imdb_movies = imdb.find_by_title(title)
    flash.now[:notice] = "The search returned #{@imdb_movies.size} movies"
    render 'imdb_create'
  end

  def save_imdb
    imdb_id = params[:imdb_id].remove('tt')
    film = Imdb::Movie.new(imdb_id)
    @movie = Movie.new
    @movie.title = film.title
    @movie.description = film.plot
    @movie.director = film.director.join(', ')
    @movie.duration = film.length
    @movie.release = film.release_date
    @movie.imdb_id = imdb_id
    @movie.imdb_rating = film.rating
    @movie.trailer_url = film.trailer_url
    @movie.image = URI.parse(film.poster)
    if @movie.save
      redirect_to @movie, notice: "movie successfully created"
    else
      render 'new' , alert: "Something went wrong try again Plz"
    end
  end

 	private

 	def set_movie
 		@movie = Movie.find(params[:id])
 	end

 	def movie_params
 		params[:movie].permit(:title, :description, :rating, :director, :duration, :release, :image)
    params[:search_imdb].permit(:title)
 	end

  def invalid_movie
    @movie = nil
    redirect_to root_path, alert: 'Sorry That movie doesn\'t exist in our database you may check later on or just look
    for another movie'
  end
end
