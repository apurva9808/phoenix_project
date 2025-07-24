defmodule BookClubWeb.ReadingListLiveTest do
  use BookClubWeb.ConnCase

  import Phoenix.LiveViewTest
  import BookClub.CollectionsFixtures

  @create_attrs %{name: "some name", description: "some description"}
  @update_attrs %{name: "some updated name", description: "some updated description"}
  @invalid_attrs %{name: nil, description: nil}

  setup :register_and_log_in_user

  defp create_reading_list(%{scope: scope}) do
    reading_list = reading_list_fixture(scope)

    %{reading_list: reading_list}
  end

  describe "Index" do
    setup [:create_reading_list]

    test "lists all reading_lists", %{conn: conn, reading_list: reading_list} do
      {:ok, _index_live, html} = live(conn, ~p"/reading_lists")

      assert html =~ "Listing Reading lists"
      assert html =~ reading_list.name
    end

    test "saves new reading_list", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/reading_lists")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Reading list")
               |> render_click()
               |> follow_redirect(conn, ~p"/reading_lists/new")

      assert render(form_live) =~ "New Reading list"

      assert form_live
             |> form("#reading_list-form", reading_list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#reading_list-form", reading_list: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/reading_lists")

      html = render(index_live)
      assert html =~ "Reading list created successfully"
      assert html =~ "some name"
    end

    test "updates reading_list in listing", %{conn: conn, reading_list: reading_list} do
      {:ok, index_live, _html} = live(conn, ~p"/reading_lists")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#reading_lists-#{reading_list.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/reading_lists/#{reading_list}/edit")

      assert render(form_live) =~ "Edit Reading list"

      assert form_live
             |> form("#reading_list-form", reading_list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#reading_list-form", reading_list: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/reading_lists")

      html = render(index_live)
      assert html =~ "Reading list updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes reading_list in listing", %{conn: conn, reading_list: reading_list} do
      {:ok, index_live, _html} = live(conn, ~p"/reading_lists")

      assert index_live |> element("#reading_lists-#{reading_list.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#reading_lists-#{reading_list.id}")
    end
  end

  describe "Show" do
    setup [:create_reading_list]

    test "displays reading_list", %{conn: conn, reading_list: reading_list} do
      {:ok, _show_live, html} = live(conn, ~p"/reading_lists/#{reading_list}")

      assert html =~ "Show Reading list"
      assert html =~ reading_list.name
    end

    test "updates reading_list and returns to show", %{conn: conn, reading_list: reading_list} do
      {:ok, show_live, _html} = live(conn, ~p"/reading_lists/#{reading_list}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/reading_lists/#{reading_list}/edit?return_to=show")

      assert render(form_live) =~ "Edit Reading list"

      assert form_live
             |> form("#reading_list-form", reading_list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#reading_list-form", reading_list: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/reading_lists/#{reading_list}")

      html = render(show_live)
      assert html =~ "Reading list updated successfully"
      assert html =~ "some updated name"
    end
  end
end
