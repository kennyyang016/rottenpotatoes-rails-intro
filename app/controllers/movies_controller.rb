class MoviesController < ApplicationController

    def show
      session[:active] = true
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end

    def index
      # byebug
      @all_ratings = Movie.all_ratings
      @selected = params[:order]
      if params[:ratings].nil? && params[:order].nil?
        if session[:active]
          if session[:ratings]
            @movies = Movie.with_order(Movie.with_ratings(
              session[:ratings].keys), session[:order])
            @ratings_to_show = session[:ratings]
            @selected = session[:order]
          else
            @movies = Movie.with_order(Movie.with_ratings(
              nil), session[:order])
            @ratings_to_show = @all_ratings
            @selected = session[:order]
          end
        else
          @movies = Movie.with_order(Movie.with_ratings(nil), nil)
          @ratings_to_show = @all_ratings
          session[:rating] = nil
          session[:order] = nil
        end
        session[:active] = false
      elsif params[:ratings].nil?
        @movies = Movie.with_order(Movie.with_ratings(nil),
          params[:order])
        @ratings_to_show = @all_ratings
        session[:ratings] = @ratings_to_show
        session[:order] = params[:order]
        # redirect_to movies_path({:ratings => 
        # @ratings_to_show, :order => 'title'})
      else
        if params[:ratings].kind_of?(Array)
          @movies = Movie.with_order(Movie.with_ratings(
            params[:ratings]), params[:order])
        else
          @movies = Movie.with_order(Movie.with_ratings(
            params[:ratings].keys), params[:order])
        end
        @ratings_to_show = params[:ratings]
        session[:ratings] = @ratings_to_show
        session[:order] = params[:order]
        # redirect_to movies_path({:ratings => 
        # @ratings_to_show, :order => 'title'})
      end
    end
  
    def new
      # default: render 'new' template
      session[:active] = true
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