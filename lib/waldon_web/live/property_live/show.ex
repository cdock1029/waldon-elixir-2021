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
    <ul>
      <%= for unit <- @property.units do %>
      <li><%= unit.name %></li>
      <% end %>
    </ul>

    <span><%= live_patch "New Unit", to: Routes.property_show_path(@socket, :new, @property) %></span>
    """
  end

  # defp page_title(:show), do: "Show Property"
  # defp page_title(:edit), do: "Edit Property"
  # defp page_title(:new), do: "New Unit for Property"

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
end
