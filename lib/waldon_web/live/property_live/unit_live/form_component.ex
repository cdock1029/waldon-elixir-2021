defmodule WaldonWeb.PropertyLive.UnitFormComponent do
  use WaldonWeb, :live_component

  alias Waldon.Properties

  @impl true
  def render(assigns) do
    ~L"""
    <h2><%= @title %></h2>

    <%= f = form_for @changeset, "#",
    id: "unit-form",
    phx_target: @myself,
    phx_change: "validate",
    phx_submit: "save" %>

    <%= label f, :name %>
    <%= text_input f, :name %>
    <%= error_tag f, :name %>

    <%= submit "Save", phx_disable_with: "Saving..." %>
    </form>
    """
  end

  @impl true
  def update(%{unit: unit} = assigns, socket) do
    changeset = Properties.change_unit(unit)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"unit" => unit_params}, socket) do
    changeset =
      socket.assigns.unit
      |> Properties.change_unit(unit_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"unit" => unit_params}, socket) do
    save_unit(socket, socket.assigns.action, unit_params)
  end

  defp save_unit(socket, :edit_unit, unit_params) do
    case Properties.update_unit(socket.assigns.unit, unit_params) do
      {:ok, _property} ->
        {:noreply,
         socket
         |> put_flash(:info, "Unit updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_unit(socket, :new, unit_params) do
    case Properties.create_unit(socket.assigns.property, unit_params) do
      {:ok, _property} ->
        {:noreply,
         socket
         |> put_flash(:info, "Unit created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
