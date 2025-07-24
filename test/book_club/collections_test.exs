defmodule BookClub.CollectionsTest do
  use BookClub.DataCase

  alias BookClub.Collections

  describe "reading_lists" do
    alias BookClub.Collections.ReadingList

    import BookClub.AccountsFixtures, only: [user_scope_fixture: 0]
    import BookClub.CollectionsFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_reading_lists/1 returns all scoped reading_lists" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)
      other_reading_list = reading_list_fixture(other_scope)
      assert Collections.list_reading_lists(scope) == [reading_list]
      assert Collections.list_reading_lists(other_scope) == [other_reading_list]
    end

    test "get_reading_list!/2 returns the reading_list with given id" do
      scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)
      other_scope = user_scope_fixture()
      assert Collections.get_reading_list!(scope, reading_list.id) == reading_list
      assert_raise Ecto.NoResultsError, fn -> Collections.get_reading_list!(other_scope, reading_list.id) end
    end

    test "create_reading_list/2 with valid data creates a reading_list" do
      valid_attrs = %{name: "some name", description: "some description"}
      scope = user_scope_fixture()

      assert {:ok, %ReadingList{} = reading_list} = Collections.create_reading_list(scope, valid_attrs)
      assert reading_list.name == "some name"
      assert reading_list.description == "some description"
      assert reading_list.user_id == scope.user.id
    end

    test "create_reading_list/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Collections.create_reading_list(scope, @invalid_attrs)
    end

    test "update_reading_list/3 with valid data updates the reading_list" do
      scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %ReadingList{} = reading_list} = Collections.update_reading_list(scope, reading_list, update_attrs)
      assert reading_list.name == "some updated name"
      assert reading_list.description == "some updated description"
    end

    test "update_reading_list/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)

      assert_raise MatchError, fn ->
        Collections.update_reading_list(other_scope, reading_list, %{})
      end
    end

    test "update_reading_list/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Collections.update_reading_list(scope, reading_list, @invalid_attrs)
      assert reading_list == Collections.get_reading_list!(scope, reading_list.id)
    end

    test "delete_reading_list/2 deletes the reading_list" do
      scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)
      assert {:ok, %ReadingList{}} = Collections.delete_reading_list(scope, reading_list)
      assert_raise Ecto.NoResultsError, fn -> Collections.get_reading_list!(scope, reading_list.id) end
    end

    test "delete_reading_list/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)
      assert_raise MatchError, fn -> Collections.delete_reading_list(other_scope, reading_list) end
    end

    test "change_reading_list/2 returns a reading_list changeset" do
      scope = user_scope_fixture()
      reading_list = reading_list_fixture(scope)
      assert %Ecto.Changeset{} = Collections.change_reading_list(scope, reading_list)
    end
  end
end
