defmodule WaldonWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers
  import Phoenix.HTML
  import Phoenix.HTML.Form, only: [datetime_select: 3]

  def live_modal(s, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(s, WaldonWeb.ModalComponent, modal_opts)
  end

  def datetime_compact(form, field, opts \\ []) do
    builder = fn b ->
      ~e"""
      <div class="grid grid-cols-6 gap-6">
        <div class="col-span-2">
          <%= b.(:year, []) %>
        </div>
        <div class="col-span-2">
          <%= b.(:month, []) %>
        </div>
        <div class="col-span-2">
          <%= b.(:day, []) %>
        </div>
      </div>
      <div class="hidden"><%= b.(:hour, []) %><%= b.(:minute, []) %></div>
      """
    end

    datetime_select(form, field, [builder: builder] ++ opts)
  end
end
