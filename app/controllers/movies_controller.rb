class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  # def index
  #   @movies = Movie.all
  # end
  
  def index
    @all_ratings = Movie.all_ratings
    
    # current setting from params or session
    sort = params[:sort] || session[:sort]
    @ratings_to_show = params[:ratings] || session[:ratings] || Hash[@all_ratings.map { |r| [r, 1] }]
    
    # redirect_to
    if !params[:commit].nil? or params[:ratings].nil? or (params[:sort].nil? && !session[:sort].nil?)
      flash.keep
      redirect_to movies_path :sort => sort, :ratings => @ratings_to_show
    end
    
    toggle() 
    remember()
    
  end
  
  def toggle
    # the toggled column
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering, @title_class = {:title => :asc}, 'hilite'
    when 'release_date'
      ordering, @release_class = {:release_date => :asc}, 'hilite'
    end
    
    # movies from Movie
    @movies = Movie.with_ratings(@ratings_to_show.keys).order(ordering)
  end
  
  def remember
    # current setting to session
    sort = params[:sort] || session[:sort]
    session[:sort] = sort
    session[:ratings] = @ratings_to_show
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
