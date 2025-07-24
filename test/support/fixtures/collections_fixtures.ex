defmodule BookClub.CollectionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BookClub.Collections` context.
  """

  @doc """
  Generate a reading_list.
  """
  def reading_list_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        name: "some name"
      })

    {:ok, reading_list} = BookClub.Collections.create_reading_list(scope, attrs)
    reading_list
  end
end
