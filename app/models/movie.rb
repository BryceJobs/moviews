class Movie < ActiveRecord::Base
	
	has_many :reviews
	has_attached_file :image,  :styles => { :standard => "400x600>", :medium => "325x500>", :thumb => "200x300>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/


  def self.rating
  	%w(G PG PG-13 R NC-17)
  end

  def average_rating
    reviews.average(:rating) || 0.00
  end
  
  def rating_from_imdb
  	imdb_rating || 0.00
  end
  
end
