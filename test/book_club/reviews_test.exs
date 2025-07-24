defmodule BookClub.ReviewsTest do
  use BookClub.DataCase

  alias BookClub.Reviews

  describe "reviews" do
    alias BookClub.Reviews.Review

    import BookClub.AccountsFixtures, only: [user_scope_fixture: 0]
    import BookClub.ReviewsFixtures

    @invalid_attrs %{rating: nil, content: nil}

    test "list_reviews/1 returns all scoped reviews" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      review = review_fixture(scope)
      other_review = review_fixture(other_scope)
      assert Reviews.list_reviews(scope) == [review]
      assert Reviews.list_reviews(other_scope) == [other_review]
    end

    test "get_review!/2 returns the review with given id" do
      scope = user_scope_fixture()
      review = review_fixture(scope)
      other_scope = user_scope_fixture()
      assert Reviews.get_review!(scope, review.id) == review
      assert_raise Ecto.NoResultsError, fn -> Reviews.get_review!(other_scope, review.id) end
    end

    test "create_review/2 with valid data creates a review" do
      valid_attrs = %{rating: 42, content: "some content"}
      scope = user_scope_fixture()

      assert {:ok, %Review{} = review} = Reviews.create_review(scope, valid_attrs)
      assert review.rating == 42
      assert review.content == "some content"
      assert review.user_id == scope.user.id
    end

    test "create_review/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Reviews.create_review(scope, @invalid_attrs)
    end

    test "update_review/3 with valid data updates the review" do
      scope = user_scope_fixture()
      review = review_fixture(scope)
      update_attrs = %{rating: 43, content: "some updated content"}

      assert {:ok, %Review{} = review} = Reviews.update_review(scope, review, update_attrs)
      assert review.rating == 43
      assert review.content == "some updated content"
    end

    test "update_review/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      review = review_fixture(scope)

      assert_raise MatchError, fn ->
        Reviews.update_review(other_scope, review, %{})
      end
    end

    test "update_review/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      review = review_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Reviews.update_review(scope, review, @invalid_attrs)
      assert review == Reviews.get_review!(scope, review.id)
    end

    test "delete_review/2 deletes the review" do
      scope = user_scope_fixture()
      review = review_fixture(scope)
      assert {:ok, %Review{}} = Reviews.delete_review(scope, review)
      assert_raise Ecto.NoResultsError, fn -> Reviews.get_review!(scope, review.id) end
    end

    test "delete_review/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      review = review_fixture(scope)
      assert_raise MatchError, fn -> Reviews.delete_review(other_scope, review) end
    end

    test "change_review/2 returns a review changeset" do
      scope = user_scope_fixture()
      review = review_fixture(scope)
      assert %Ecto.Changeset{} = Reviews.change_review(scope, review)
    end
  end
end
