defmodule WaldonWeb.PropertyLive.UnitShow do
  use WaldonWeb, :live_view

  alias Waldon.Properties
  alias Waldon.Properties.Property

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"uid" => uid}, _, socket) do
    unit = Properties.get_unit!(uid)

    {:noreply,
     socket
     # |> assign(:page_title, page_title(socket.assigns.live_action))
     |> apply_action(socket.assigns.live_action)
     |> assign(:unit, unit)
     |> assign(:property, %Property{id: unit.property_id})}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Show Unit</h1>

    <!--
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

    -->


    <ul>

    <li>
    <strong>Name:</strong>
    <%= @unit.name %>
    </li>

    </ul>

    <span>Edit<%= # live_patch "Edit", to: Routes.property_show_path(@socket, :edit, @property), class: "button" %></span>
    <span><%= live_redirect "Back", to: Routes.property_show_path(@socket, :show, @property) %></span>
    """
  end

  defp apply_action(socket, :show) do
    socket
    |> assign(:page_title, "Show Unit")
  end

  defp apply_action(socket, :edit) do
    socket
    |> assign(:page_title, "Edit Unit")
  end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   unit = Properties.get_unit!(id)
  #   {:ok, _} = Properties.delete_unit(unit)
  #   {:noreply, assign(socket, :property, Properties.get_property!(socket.assigns.property.id))}
  # end
end
