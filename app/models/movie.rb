class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
    if ratings_list.nil?
      Movie.all
    else
      Movie.all.where(rating: ratings_list)
    end
  end

  def self.all_ratings()
    Movie.uniq.pluck(:rating)
  end

  def self.with_order(movie, type)
    if type.nil?
      movie
    else
      movie.order(type)
    end
  end

  df
end