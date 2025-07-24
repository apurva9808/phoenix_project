defmodule BookClubWeb.ReviewLiveTest do
  use BookClubWeb.ConnCase

  import Phoenix.LiveViewTest
  import BookClub.ReviewsFixtures

  @create_attrs %{rating: 42, content: "some content"}
  @update_attrs %{rating: 43, content: "some updated content"}
  @invalid_attrs %{rating: nil, content: nil}

  setup :register_and_log_in_user

  defp create_review(%{scope: scope}) do
    review = review_fixture(scope)

    %{review: review}
  end

  describe "Index" do
    setup [:create_review]

    test "lists all reviews", %{conn: conn, review: review} do
      {:ok, _index_live, html} = live(conn, ~p"/reviews")

      assert html =~ "Listing Reviews"
      assert html =~ review.content
    end

    test "saves new review", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/reviews")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Review")
               |> render_click()
               |> follow_redirect(conn, ~p"/reviews/new")

      assert render(form_live) =~ "New Review"

      assert form_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#review-form", review: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/reviews")

      html = render(index_live)
      assert html =~ "Review created successfully"
      assert html =~ "some content"
    end

    test "updates review in listing", %{conn: conn, review: review} do
      {:ok, index_live, _html} = live(conn, ~p"/reviews")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#reviews-#{review.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/reviews/#{review}/edit")

      assert render(form_live) =~ "Edit Review"

      assert form_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#review-form", review: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/reviews")

      html = render(index_live)
      assert html =~ "Review updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes review in listing", %{conn: conn, review: review} do
      {:ok, index_live, _html} = live(conn, ~p"/reviews")

      assert index_live |> element("#reviews-#{review.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#reviews-#{review.id}")
    end
  end

  describe "Show" do
    setup [:create_review]

    test "displays review", %{conn: conn, review: review} do
      {:ok, _show_live, html} = live(conn, ~p"/reviews/#{review}")

      assert html =~ "Show Review"
      assert html =~ review.content
    end

    test "updates review and returns to show", %{conn: conn, review: review} do
      {:ok, show_live, _html} = live(conn, ~p"/reviews/#{review}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/reviews/#{review}/edit?return_to=show")

      assert render(form_live) =~ "Edit Review"

      assert form_live
             |> form("#review-form", review: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#review-form", review: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/reviews/#{review}")

      html = render(show_live)
      assert html =~ "Review updated successfully"
      assert html =~ "some updated content"
    end
  end
end
