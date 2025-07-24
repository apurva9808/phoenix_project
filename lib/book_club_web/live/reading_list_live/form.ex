defmodule BookClubWeb.ReadingListLive.Form do
  use BookClubWeb, :live_view

  alias BookClub.Collections
  alias BookClub.Collections.ReadingList

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage reading_list records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="reading_list-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Reading list</.button>
          <.button navigate={return_path(@current_scope, @return_to, @reading_list)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    reading_list = Collections.get_reading_list!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Reading list")
    |> assign(:reading_list, reading_list)
    |> assign(:form, to_form(Collections.change_reading_list(socket.assigns.current_scope, reading_list)))
  end

  defp apply_action(socket, :new, _params) do
    reading_list = %ReadingList{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Reading list")
    |> assign(:reading_list, reading_list)
    |> assign(:form, to_form(Collections.change_reading_list(socket.assigns.current_scope, reading_list)))
  end

  @impl true
  def handle_event("validate", %{"reading_list" => reading_list_params}, socket) do
    changeset = Collections.change_reading_list(socket.assigns.current_scope, socket.assigns.reading_list, reading_list_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"reading_list" => reading_list_params}, socket) do
    save_reading_list(socket, socket.assigns.live_action, reading_list_params)
  end

  defp save_reading_list(socket, :edit, reading_list_params) do
    case Collections.update_reading_list(socket.assigns.current_scope, socket.assigns.reading_list, reading_list_params) do
      {:ok, reading_list} ->
        {:noreply,
         socket
         |> put_flash(:info, "Reading list updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, reading_list)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_reading_list(socket, :new, reading_list_params) do
    case Collections.create_reading_list(socket.assigns.current_scope, reading_list_params) do
      {:ok, reading_list} ->
        {:noreply,
         socket
         |> put_flash(:info, "Reading list created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, reading_list)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _reading_list), do: ~p"/reading_lists"
  defp return_path(_scope, "show", reading_list), do: ~p"/reading_lists/#{reading_list}"
end
