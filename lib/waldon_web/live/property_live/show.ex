defmodule WaldonWeb.PropertyLive.Show do
  use WaldonWeb, :live_view

  alias Waldon.Properties

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
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

    """
  end

  defp page_title(:show), do: "Show Property"
  defp page_title(:edit), do: "Edit Property"
end
