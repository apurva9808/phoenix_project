defmodule BookClubWeb.ReadingListLive.Index do
  use BookClubWeb, :live_view

  alias BookClub.Collections

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Reading lists
        <:actions>
          <.button variant="primary" navigate={~p"/reading_lists/new"}>
            <.icon name="hero-plus" /> New Reading list
          </.button>
        </:actions>
      </.header>

      <.table
        id="reading_lists"
        rows={@streams.reading_lists}
        row_click={fn {_id, reading_list} -> JS.navigate(~p"/reading_lists/#{reading_list}") end}
      >
        <:col :let={{_id, reading_list}} label="Name">{reading_list.name}</:col>
        <:col :let={{_id, reading_list}} label="Description">{reading_list.description}</:col>
        <:action :let={{_id, reading_list}}>
          <div class="sr-only">
            <.link navigate={~p"/reading_lists/#{reading_list}"}>Show</.link>
          </div>
          <.link navigate={~p"/reading_lists/#{reading_list}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, reading_list}}>
          <.link
            phx-click={JS.push("delete", value: %{id: reading_list.id}) |> hide("##{id}")}
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
      Collections.subscribe_reading_lists(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Reading lists")
     |> stream(:reading_lists, Collections.list_reading_lists(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    reading_list = Collections.get_reading_list!(socket.assigns.current_scope, id)
    {:ok, _} = Collections.delete_reading_list(socket.assigns.current_scope, reading_list)

    {:noreply, stream_delete(socket, :reading_lists, reading_list)}
  end

  @impl true
  def handle_info({type, %BookClub.Collections.ReadingList{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :reading_lists, Collections.list_reading_lists(socket.assigns.current_scope), reset: true)}
  end
end
