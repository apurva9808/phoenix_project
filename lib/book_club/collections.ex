defmodule BookClub.Collections do
  @moduledoc """
  The Collections context.
  """

  import Ecto.Query, warn: false
  alias BookClub.Repo

  alias BookClub.Collections.ReadingList
  alias BookClub.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any reading_list changes.

  The broadcasted messages match the pattern:
    * {:created, %BookClub.Collections.ReadingList{}}
    * {:updated, %BookClub.Collections.ReadingList{}}
    * {:deleted, %BookClub.Collections.ReadingList{}}
  """
  def subscribe_reading_lists(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(BookClub.PubSub, "user:#{key}:reading_lists")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(BookClub.PubSub, "user:#{key}:reading_lists", message)
  end

  @doc """
  Returns the list of reading_lists.

  ## Examples

      iex> list_reading_lists(scope)
      [%BookClub.Collections.ReadingList{}, ...]

  """
  def list_reading_lists(%Scope{} = scope) do
    Repo.all(from reading_list in ReadingList, where: reading_list.user_id == ^scope.user.id)
  end

  @doc """
  Gets a single reading_list.

  Raises `Ecto.NoResultsError` if the Reading list does not exist.

  ## Examples

      iex> get_reading_list!(123)
      %BookClub.Collections.ReadingList{}

      iex> get_reading_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reading_list!(%Scope{} = scope, id) do
    Repo.get_by!(ReadingList, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a reading_list.

  ## Examples

      iex> create_reading_list(%{field: value})
      {:ok, %BookClub.Collections.ReadingList{}}

      iex> create_reading_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reading_list(%Scope{} = scope, attrs) do
    with {:ok, reading_list} <-
           %BookClub.Collections.ReadingList{}
           |> BookClub.Collections.ReadingList.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, reading_list})
      {:ok, reading_list}
    end
  end

  @doc """
  Updates a reading_list.

  ## Examples

      iex> update_reading_list(reading_list, %{field: new_value})
      {:ok, %BookClub.Collections.ReadingList{}}

      iex> update_reading_list(reading_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reading_list(%Scope{} = scope, %ReadingList{} = reading_list, attrs) do
    true = reading_list.user_id == scope.user.id

    with {:ok, reading_list} <-
           reading_list
           |> BookClub.Collections.ReadingList.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, reading_list})
      {:ok, reading_list}
    end
  end

  @doc """
  Deletes a reading_list.

  ## Examples

      iex> delete_reading_list(reading_list)
      {:ok, %BookClub.Collections.ReadingList{}}

      iex> delete_reading_list(reading_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reading_list(%Scope{} = scope, %ReadingList{} = reading_list) do
    true = reading_list.user_id == scope.user.id

    with {:ok, reading_list} <-
           Repo.delete(reading_list) do
      broadcast(scope, {:deleted, reading_list})
      {:ok, reading_list}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reading_list changes.

  ## Examples

      iex> change_reading_list(reading_list)
      %Ecto.Changeset{data: %BookClub.Collections.ReadingList{}}

  """
  def change_reading_list(%Scope{} = scope, %ReadingList{} = reading_list, attrs \\ %{}) do
    true = reading_list.user_id == scope.user.id

    BookClub.Collections.ReadingList.changeset(reading_list, attrs, scope)
  end
end