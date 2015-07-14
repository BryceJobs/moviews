class ChangeRatingFromReview < ActiveRecord::Migration
  def change
  	change_column :reviews, :rating, :decimal
  end
end
