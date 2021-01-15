defmodule WaldonWeb.PropertyLive.Show do
  use WaldonWeb, :live_view

  alias Waldon.Properties
  alias Waldon.Properties.Unit

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     # |> assign(:page_title, page_title(socket.assigns.live_action))
     |> apply_action(socket.assigns.live_action)
     |> assign(:property, Properties.get_property!(id))}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Show Property</h1>

    <%= if @live_action in [:edit] do %>
    <%= live_modal @socket, WaldonWeb.PropertyLive.FormComponent,
    id: @property.id,
    title: @page_title,
    action: @live_action,
    property: @property,
    return_to: Routes.property_show_path(@socket, :show, @property) %>
    <% end %>

    <%= if @live_action in [:new] do %>
    <%= live_modal @socket, WaldonWeb.PropertyLive.UnitFormComponent,
    id: @property.id,
    title: @page_title,
    action: @live_action,
    property: @property,
    unit: @unit,
    return_to: Routes.property_show_path(@socket, :show, @property) %>
    <% end %>


    <ul>

    <li>
    <strong>Name:</strong>
    <%= @property.name %>
    </li>

    <li>
    <strong>Address:</strong>
    <%= @property.address %>
    </li>

    </ul>

    <span><%= live_patch "Edit", to: Routes.property_show_path(@socket, :edit, @property), class: "button" %></span>
    <span><%= live_redirect "Back", to: Routes.property_index_path(@socket, :index) %></span>

    <hr/>


    <h3>Units</h3>
    <table>
    <thead>
    <tr>
      <th>Name</th>
      <th></th>
    </tr>
    </thead>
    <tbody id="units">
    <%= for unit <- @property.units do %>
      <tr id="unit-<%= unit.id %>">
        <td><%= unit.name %></td>
        <td>
          <span><%= live_redirect "Show", to: Routes.property_unit_show_path(@socket, :show, @property, unit) %></span>
          <span><%= # live_patch "Edit", to: Routes.property_index_path(@socket, :edit, property) %></span>
          <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: unit.id, data: [confirm: "Are you sure?"] %></span>
        </td>
      </tr>
    <% end %>
    </tbody>
    </table>

    <span><%= live_patch "New Unit", to: Routes.property_show_path(@socket, :new, @property) %></span>
    """
  end

  defp apply_action(socket, :new) do
    socket
    |> assign(:page_title, "New Unit for Property")
    |> assign(:unit, %Unit{})
  end

  defp apply_action(socket, :show) do
    socket
    |> assign(:page_title, "Show Property")
  end

  defp apply_action(socket, :edit) do
    socket
    |> assign(:page_title, "Edit Property")
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    unit = Properties.get_unit!(id)
    {:ok, _} = Properties.delete_unit(unit)
    {:noreply, assign(socket, :property, Properties.get_property!(socket.assigns.property.id))}
  end
end
