class Movie < ActiveRecord::Base
    # all_ratings method
    def self.all_ratings
        pluck(:rating).uniq
    end
    # with_ratings method 
    def self.with_ratings(ratings)
        where("LOWER(rating) IN (?)", ratings.map(&:downcase))
    end
    # ratings method
    def self.ratings
        Movie.select(:rating).distinct.inject([]) { |a, m| a.push m.rating }
    end
end
