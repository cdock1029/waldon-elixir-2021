defmodule WaldonWeb.PropertyLive.Index do
  use WaldonWeb, :live_view

  alias Waldon.Properties
  alias Waldon.Properties.Property

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :properties, list_properties())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Listing Properties</h1>

    <%= if @live_action in [:new, :edit] do %>
    <%= live_modal @socket, WaldonWeb.PropertyLive.FormComponent,
    id: @property.id || :new,
    title: @page_title,
    action: @live_action,
    property: @property,
    return_to: Routes.property_index_path(@socket, :index) %>
    <% end %>

    <table>
    <thead>
    <tr>
      <th>Name</th>
      <th>Address</th>

      <th></th>
    </tr>
    </thead>
    <tbody id="properties">
    <%= for property <- @properties do %>
      <tr id="property-<%= property.id %>">
        <td><%= property.name %></td>
        <td><%= property.address %></td>

        <td>
          <span><%= live_redirect "Show", to: Routes.property_show_path(@socket, :show, property) %></span>
          <span><%= live_patch "Edit", to: Routes.property_index_path(@socket, :edit, property) %></span>
          <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: property.id, data: [confirm: "Are you sure?"] %></span>
        </td>
      </tr>
    <% end %>
    </tbody>
    </table>

    <span><%= live_patch "New Property", to: Routes.property_index_path(@socket, :new) %></span>
    """
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Property")
    |> assign(:property, Properties.get_property!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Property")
    |> assign(:property, %Property{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Properties")
    |> assign(:property, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    property = Properties.get_property!(id)
    {:ok, _} = Properties.delete_property(property)

    {:noreply, assign(socket, :properties, list_properties())}
  end

  defp list_properties do
    Properties.list_properties()
  end
end
