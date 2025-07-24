defmodule BookClubWeb.ReviewLive.Index do
  use BookClubWeb, :live_view

  alias BookClub.Reviews

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Reviews
        <:actions>
          <.button variant="primary" navigate={~p"/reviews/new"}>
            <.icon name="hero-plus" /> New Review
          </.button>
        </:actions>
      </.header>

      <.table
        id="reviews"
        rows={@streams.reviews}
        row_click={fn {_id, review} -> JS.navigate(~p"/reviews/#{review}") end}
      >
        <:col :let={{_id, review}} label="Rating">{review.rating}</:col>
        <:col :let={{_id, review}} label="Content">{review.content}</:col>
        <:action :let={{_id, review}}>
          <div class="sr-only">
            <.link navigate={~p"/reviews/#{review}"}>Show</.link>
          </div>
          <.link navigate={~p"/reviews/#{review}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, review}}>
          <.link
            phx-click={JS.push("delete", value: %{id: review.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Reviews.subscribe_reviews(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Reviews")
     |> stream(:reviews, Reviews.list_reviews(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    review = Reviews.get_review!(socket.assigns.current_scope, id)
    {:ok, _} = Reviews.delete_review(socket.assigns.current_scope, review)

    {:noreply, stream_delete(socket, :reviews, review)}
  end

  @impl true
  def handle_info({type, %BookClub.Reviews.Review{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :reviews, Reviews.list_reviews(socket.assigns.current_scope), reset: true)}
  end
end
