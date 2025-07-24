defmodule BookClub.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :rating, :integer
      add :content, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :book_id, references(:books, on_delete: :nothing)
      

      timestamps(type: :utc_datetime)
    end

    create index(:reviews, [:user_id])

    
    create index(:reviews, [:book_id])
  end
end
