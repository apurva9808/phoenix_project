defmodule BookClub.Collections.ReadingList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reading_lists" do
    field :name, :string
    field :description, :string
    belongs_to :user, BookClub.Accounts.User
    
    has_many :reading_list_items, BookClub.Collections.ReadingListItem
    has_many :books, through: [:reading_list_items, :book]
    
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reading_list, attrs, user_scope) do
    reading_list
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> put_change(:user_id, user_scope.user.id)
  end
end