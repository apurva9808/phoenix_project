defmodule BookClubWeb.ReadingListLive.Show do
  use BookClubWeb, :live_view

  alias BookClub.Collections

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Reading list {@reading_list.id}
        <:subtitle>This is a reading_list record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/reading_lists"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/reading_lists/#{@reading_list}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit reading_list
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@reading_list.name}</:item>
        <:item title="Description">{@reading_list.description}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Collections.subscribe_reading_lists(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Reading list")
     |> assign(:reading_list, Collections.get_reading_list!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %BookClub.Collections.ReadingList{id: id} = reading_list},
        %{assigns: %{reading_list: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :reading_list, reading_list)}
  end

  def handle_info(
        {:deleted, %BookClub.Collections.ReadingList{id: id}},
        %{assigns: %{reading_list: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current reading_list was deleted.")
     |> push_navigate(to: ~p"/reading_lists")}
  end

  def handle_info({type, %BookClub.Collections.ReadingList{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
