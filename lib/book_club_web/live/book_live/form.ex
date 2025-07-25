defmodule BookClubWeb.BookLive.Form do
  use BookClubWeb, :live_view

  alias BookClub.Catalog
  alias BookClub.Catalog.Book

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage book records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="book-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:author]} type="text" label="Author" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:isbn]} type="text" label="Isbn" />
        <.input field={@form[:cover_url]} type="text" label="Cover url" />
        <.input field={@form[:publication_year]} type="number" label="Publication year" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Book</.button>
          <.button navigate={return_path(@current_scope, @return_to, @book)}>Cancel</.button>
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
    book = Catalog.get_book!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Book")
    |> assign(:book, book)
    |> assign(:form, to_form(Catalog.change_book(socket.assigns.current_scope, book)))
  end

  defp apply_action(socket, :new, _params) do
    book = %Book{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Book")
    |> assign(:book, book)
    |> assign(:form, to_form(Catalog.change_book(socket.assigns.current_scope, book)))
  end

  @impl true
  def handle_event("validate", %{"book" => book_params}, socket) do
    changeset = Catalog.change_book(socket.assigns.current_scope, socket.assigns.book, book_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"book" => book_params}, socket) do
    save_book(socket, socket.assigns.live_action, book_params)
  end

  defp save_book(socket, :edit, book_params) do
    case Catalog.update_book(socket.assigns.current_scope, socket.assigns.book, book_params) do
      {:ok, book} ->
        {:noreply,
         socket
         |> put_flash(:info, "Book updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, book)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_book(socket, :new, book_params) do
    case Catalog.create_book(socket.assigns.current_scope, book_params) do
      {:ok, book} ->
        {:noreply,
         socket
         |> put_flash(:info, "Book created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, book)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _book), do: ~p"/books"
  defp return_path(_scope, "show", book), do: ~p"/books/#{book}"
end
