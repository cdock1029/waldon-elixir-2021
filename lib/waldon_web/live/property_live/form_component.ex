defmodule WaldonWeb.PropertyLive.FormComponent do
  use WaldonWeb, :live_component

  alias Waldon.Properties

  @impl true
  def render(assigns) do
    ~L"""
    <h2><%= @title %></h2>

    <%= f = form_for @changeset, "#",
    id: "property-form",
    phx_target: @myself,
    phx_change: "validate",
    phx_submit: "save" %>

    <%= label f, :name %>
    <%= text_input f, :name %>
    <%= error_tag f, :name %>

    <%= label f, :address %>
    <%= textarea f, :address %>
    <%= error_tag f, :address %>

    <div class="my-4">
      <label class="font-bold">Units</label>
      <%= inputs_for f, :units, fn i -> %>
        <div>
          <%= label i, :name %>
          <%= text_input i, :name %>
          <%= error_tag i, :name %>
        </div>
      <% end %>
    </div>

    <%= submit "Save", phx_disable_with: "Saving...", class: "btn" %>
    </form>
    """
  end

  @impl true
  def update(%{property: property} = assigns, socket) do
    changeset = Properties.change_property(property)

    IO.inspect(changeset)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"property" => property_params}, socket) do
    changeset =
      socket.assigns.property
      |> Properties.change_property(property_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"property" => property_params}, socket) do
    save_property(socket, socket.assigns.action, property_params)
  end

  defp save_property(socket, :edit, property_params) do
    case Properties.update_property(socket.assigns.property, property_params) do
      {:ok, _property} ->
        {:noreply,
         socket
         |> put_flash(:info, "Property updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_property(socket, :new, property_params) do
    case Properties.create_property(property_params) do
      {:ok, _property} ->
        {:noreply,
         socket
         |> put_flash(:info, "Property created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
