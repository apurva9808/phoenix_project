defmodule BookClub.Catalog.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    field :author, :string
    field :description, :string
    field :isbn, :string
    field :cover_url, :string
    field :publication_year, :integer
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(book, attrs, user_scope) do
    book
    |> cast(attrs, [:title, :author, :description, :isbn, :cover_url, :publication_year])
    |> validate_required([:title, :author, :description, :isbn, :cover_url, :publication_year])
    |> put_change(:user_id, user_scope.user.id)
  end
end
