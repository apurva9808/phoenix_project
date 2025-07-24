defmodule BookClub.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :rating, :integer
    field :content, :string
    
    # These associations will automatically handle the user_id and book_id fields
    belongs_to :user, BookClub.Accounts.User
    belongs_to :book, BookClub.Catalog.Book

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(review, attrs, user_scope) do
    review
    |> cast(attrs, [:rating, :content, :book_id])
    |> validate_required([:rating, :content, :book_id])
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> put_change(:user_id, user_scope.user.id)
  end
end