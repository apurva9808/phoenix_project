defmodule BookClubWeb.ReviewLive.Show do
  use BookClubWeb, :live_view

  alias BookClub.Reviews

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Review {@review.id}
        <:subtitle>This is a review record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/reviews"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/reviews/#{@review}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit review
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Rating">{@review.rating}</:item>
        <:item title="Content">{@review.content}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Reviews.subscribe_reviews(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Review")
     |> assign(:review, Reviews.get_review!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %BookClub.Reviews.Review{id: id} = review},
        %{assigns: %{review: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :review, review)}
  end

  def handle_info(
        {:deleted, %BookClub.Reviews.Review{id: id}},
        %{assigns: %{review: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current review was deleted.")
     |> push_navigate(to: ~p"/reviews")}
  end

  def handle_info({type, %BookClub.Reviews.Review{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
