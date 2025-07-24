defmodule BookClub.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BookClub.Catalog` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        author: "some author",
        cover_url: "some cover_url",
        description: "some description",
        isbn: "some isbn",
        publication_year: 42,
        title: "some title"
      })

    {:ok, book} = BookClub.Catalog.create_book(scope, attrs)
    book
  end
end
