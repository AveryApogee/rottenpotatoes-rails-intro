class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    # Initialize
    @all_ratings = Movie.all_ratings

    # Check new connection
    if session[:rating] == nil and session[:sort] == nil
      session[:rating] = {'G'=>1,'PG'=>1,'PG-13'=>1,'R'=>1}
      session[:sort] = "title"
    end
    
    # Check if the user is filtering movies
    if params[:ratings].present?
      @selected = params[:ratings].keys
      session[:rating] = params[:ratings]
    end

    # Check if the user is sorting movies
    if params[:sort].present?
      session[:sort] = params[:sort]
    end

    # Filter and sort
    @movies = Movie.where(rating: @selected).order(params[:sort])

    # Reload page
    if params[:sort] == nil or params[:ratings] == nil
      params[:ratings] = session[:rating]
      params[:sort] = session[:sort]
      flash.keep
      redirect_to movies_path(params.to_unsafe_h)
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
