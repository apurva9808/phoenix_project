defmodule BookClub.Collections.ReadingListItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reading_list_items" do
    field :read, :boolean, default: false
    field :added_on, :date, default: Date.utc_today()
    
    belongs_to :reading_list, BookClub.Collections.ReadingList
    belongs_to :book, BookClub.Catalog.Book

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reading_list_item, attrs) do
    reading_list_item
    |> cast(attrs, [:reading_list_id, :book_id, :read, :added_on])
    |> validate_required([:reading_list_id, :book_id])
    |> unique_constraint([:reading_list_id, :book_id], name: :reading_list_book_unique_index)
  end
end