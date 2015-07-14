class AddColumnsToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :imdb_id, :string
    add_column :movies, :imdb_rating, :decimal, precision: 2, scale: 2
    add_column :movies, :trailer_url, :string
  end
end
