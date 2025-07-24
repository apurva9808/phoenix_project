defmodule BookClub.Repo.Migrations.CreateReadingListItems do
  use Ecto.Migration

  def change do
    create table(:reading_list_items) do
      add :reading_list_id, references(:reading_lists, on_delete: :delete_all), null: false
      add :book_id, references(:books, on_delete: :delete_all), null: false
      add :read, :boolean, default: false, null: false
      add :added_on, :date, null: false, default: fragment("CURRENT_DATE")

      timestamps()
    end

    create index(:reading_list_items, [:reading_list_id])
    create index(:reading_list_items, [:book_id])
    create unique_index(:reading_list_items, [:reading_list_id, :book_id], name: :reading_list_book_unique_index)
  end
end