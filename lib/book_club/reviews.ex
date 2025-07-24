defmodule BookClub.Reviews do
  @moduledoc """
  The Reviews context.
  """

  import Ecto.Query, warn: false
  alias BookClub.Repo

  alias BookClub.Reviews.Review
  alias BookClub.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any review changes.

  The broadcasted messages match the pattern:

    * {:created, %Review{}}
    * {:updated, %Review{}}
    * {:deleted, %Review{}}

  """
  def subscribe_reviews(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BookClub.PubSub, "user:#{key}:reviews")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BookClub.PubSub, "user:#{key}:reviews", message)
  end

  @doc """
  Returns the list of reviews.

  ## Examples

      iex> list_reviews(scope)
      [%Review{}, ...]

  """
  def list_reviews(%Scope{} = scope) do
    Repo.all(from review in Review, where: review.user_id == ^scope.user.id)
  end

  @doc """
  Gets a single review.

  Raises `Ecto.NoResultsError` if the Review does not exist.

  ## Examples

      iex> get_review!(123)
      %Review{}

      iex> get_review!(456)
      ** (Ecto.NoResultsError)

  """
  def get_review!(%Scope{} = scope, id) do
    Repo.get_by!(Review, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a review.

  ## Examples

      iex> create_review(%{field: value})
      {:ok, %Review{}}

      iex> create_review(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_review(%Scope{} = scope, attrs) do
    with {:ok, review = %Review{}} <-
           %Review{}
           |> Review.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, review})
      {:ok, review}
    end
  end

  @doc """
  Updates a review.

  ## Examples

      iex> update_review(review, %{field: new_value})
      {:ok, %Review{}}

      iex> update_review(review, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_review(%Scope{} = scope, %Review{} = review, attrs) do
    true = review.user_id == scope.user.id

    with {:ok, review = %Review{}} <-
           review
           |> Review.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, review})
      {:ok, review}
    end
  end

  @doc """
  Deletes a review.

  ## Examples

      iex> delete_review(review)
      {:ok, %Review{}}

      iex> delete_review(review)
      {:error, %Ecto.Changeset{}}

  """
  def delete_review(%Scope{} = scope, %Review{} = review) do
    true = review.user_id == scope.user.id

    with {:ok, review = %Review{}} <-
           Repo.delete(review) do
      broadcast(scope, {:deleted, review})
      {:ok, review}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking review changes.

  ## Examples

      iex> change_review(review)
      %Ecto.Changeset{data: %Review{}}

  """
  def change_review(%Scope{} = scope, %Review{} = review, attrs \\ %{}) do
    true = review.user_id == scope.user.id

    Review.changeset(review, attrs, scope)
  end
end
