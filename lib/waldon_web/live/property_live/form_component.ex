defmodule WaldonWeb.PropertyLive.FormComponent do
  use WaldonWeb, :live_component

  alias Waldon.Properties

  @impl true
  def render(assigns) do
    ~L"""
    <%= f = form_for @changeset,
    "#",
    id: "property-form",
    phx_target: @myself,
    phx_change: "validate",
    phx_submit: "save" %>

    <div>
      <h3 class="text-lg font-medium leading-6 text-gray-900"><%= @title %></h3>
      <p class="mt-2 text-sm text-gray-500">
        Save Property
      </p>
    </div>
    <div class="grid grid-cols-1 mt-5 gap-y-6 gap-x-4">
      <div>
        <%= label f, :name, class: "block text-sm font-medium text-gray-700" %>
        <div class="relative mt-1">
          <%= text_input f, :name, autofocus: true, class: "shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
        </div>
        <%= error_tag f, :name %>
      </div>

      <div>
        <%= label f, :address, class: "block text-sm font-medium text-gray-700" %>
        <div class="relative mt-1">
          <%= textarea f, :address, rows: 3, class: "shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
        </div>
        <%= error_tag f, :address %>
      </div>
    </div>

    <!--
    <div class="my-4">
      <label class="font-bold">Units</label>
      <%= inputs_for f, :units, fn ip -> %>
        <div>
          <div>
          <%= label ip, :name %>
          <%= text_input ip, :name %>
          <%= error_tag ip, :name %>
          </div>
        </div>
      <% end %>
    </div>
    -->

    <div class="pt-5">
    <div class="flex items-center justify-end">
      <button phx-click="close" phx-target="#modal" type="button" class="px-6 py-1 font-medium text-gray-700 bg-white border border-gray-300 rounded shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
        Cancel
      </button>
      <%= submit "Save", phx_disable_with: "Saving...", class: "btn ml-4" %>
    </div>
    </div>
    </form>
    """
  end

  @impl true
  def update(%{property: property} = assigns, socket) do
    changeset = Properties.change_property(property)

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

    # IO.inspect(changeset)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
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
