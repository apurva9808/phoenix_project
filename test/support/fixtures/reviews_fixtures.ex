defmodule BookClub.ReviewsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BookClub.Reviews` context.
  """

  @doc """
  Generate a review.
  """
  def review_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        content: "some content",
        rating: 42
      })

    {:ok, review} = BookClub.Reviews.create_review(scope, attrs)
    review
  end
end
