defmodule BookClub.CatalogTest do
  use BookClub.DataCase

  alias BookClub.Catalog

  describe "books" do
    alias BookClub.Catalog.Book

    import BookClub.AccountsFixtures, only: [user_scope_fixture: 0]
    import BookClub.CatalogFixtures

    @invalid_attrs %{description: nil, author: nil, title: nil, isbn: nil, cover_url: nil, publication_year: nil}

    test "list_books/1 returns all scoped books" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      book = book_fixture(scope)
      other_book = book_fixture(other_scope)
      assert Catalog.list_books(scope) == [book]
      assert Catalog.list_books(other_scope) == [other_book]
    end

    test "get_book!/2 returns the book with given id" do
      scope = user_scope_fixture()
      book = book_fixture(scope)
      other_scope = user_scope_fixture()
      assert Catalog.get_book!(scope, book.id) == book
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_book!(other_scope, book.id) end
    end

    test "create_book/2 with valid data creates a book" do
      valid_attrs = %{description: "some description", author: "some author", title: "some title", isbn: "some isbn", cover_url: "some cover_url", publication_year: 42}
      scope = user_scope_fixture()

      assert {:ok, %Book{} = book} = Catalog.create_book(scope, valid_attrs)
      assert book.description == "some description"
      assert book.author == "some author"
      assert book.title == "some title"
      assert book.isbn == "some isbn"
      assert book.cover_url == "some cover_url"
      assert book.publication_year == 42
      assert book.user_id == scope.user.id
    end

    test "create_book/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.create_book(scope, @invalid_attrs)
    end

    test "update_book/3 with valid data updates the book" do
      scope = user_scope_fixture()
      book = book_fixture(scope)
      update_attrs = %{description: "some updated description", author: "some updated author", title: "some updated title", isbn: "some updated isbn", cover_url: "some updated cover_url", publication_year: 43}

      assert {:ok, %Book{} = book} = Catalog.update_book(scope, book, update_attrs)
      assert book.description == "some updated description"
      assert book.author == "some updated author"
      assert book.title == "some updated title"
      assert book.isbn == "some updated isbn"
      assert book.cover_url == "some updated cover_url"
      assert book.publication_year == 43
    end

    test "update_book/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      book = book_fixture(scope)

      assert_raise MatchError, fn ->
        Catalog.update_book(other_scope, book, %{})
      end
    end

    test "update_book/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      book = book_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Catalog.update_book(scope, book, @invalid_attrs)
      assert book == Catalog.get_book!(scope, book.id)
    end

    test "delete_book/2 deletes the book" do
      scope = user_scope_fixture()
      book = book_fixture(scope)
      assert {:ok, %Book{}} = Catalog.delete_book(scope, book)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_book!(scope, book.id) end
    end

    test "delete_book/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      book = book_fixture(scope)
      assert_raise MatchError, fn -> Catalog.delete_book(other_scope, book) end
    end

    test "change_book/2 returns a book changeset" do
      scope = user_scope_fixture()
      book = book_fixture(scope)
      assert %Ecto.Changeset{} = Catalog.change_book(scope, book)
    end
  end
end
