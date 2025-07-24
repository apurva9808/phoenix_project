defmodule BookClub.Repo.Migrations.CreateReadingLists do
  use Ecto.Migration

  def change do
    create table(:reading_lists) do
      add :name, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)
     

      timestamps(type: :utc_datetime)
    end

    create index(:reading_lists, [:user_id])

    
  end
end
