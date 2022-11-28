defmodule RmsWeb.MultiSelectComponent do
  use RmsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="occupation">
      <div class="select"
        id={"#{@id}-selected-occupation-container"}>
          <%= for occ <- @selected_occupation do %>
            <div class="selected_occupation">
              <%= occ.fos %>
            </div>
          <% end %>

        <div class="icon">

          <svg id={"#{@id}-down-icon"}>
            phx-click={
              JS.toggle()
              |> JS.toggle(to: "##{@id}-up-icon")
              |> JS.toggle(to: "##{@id}-options-container")
            }>
            <path .../>
          </svg>
          <svg id={"#{@id}-down-icon"}>
            phx-click={
              JS.toggle()
              |> JS.toggle(to: "##{@id}-up-icon")
              |> JS.toggle(to: "##{@id}-options-container")
            }>
            <path .../>
          </svg>

        </div>
      </div>
      <div class="hidden" id={"#{@id}"}-occupation-container>
        <%= inputs_for @form, :occupation, fn value -> %>
          <div class="form-check">

              <label class="form-check">
                <%= checkbox value, :selected, phx_change: "checked", phx_target: {@myself}, value: value.data.selected %>
                <%= label value, :fos, value: value.data.fos class: "ml-2" %>
                <%= hidden_input value, :fos, value.data.fos %>
              </label>
            </div>

        <% end %>
      </div>
    </div>
    """
  end

  def update(assigns, socket) do
    %{occupation: occupation, form: form, selected: selected, id: id} = assigns

    socket =
      socket
      |> assign(:id, id)
      |> assign(:selected_occupation, filter_selected_occupation(occupation))
      |> assign(:selectable_occupation, occupation)
      |> assign(:form, form)
      |> assign(:selected, selected)

    {:ok, socket}
  end

  def handle_event("checked", %{"multi_select" => %{"occupation" => occ}}, socket) do
    [{index, %{"selected" => selected?}}] = Map.to_list(occ)

    index = String.to_integer(index)

    selectable_occupation = socket.assigns.selectable_occupation

    current_occupation = Enum.at(selectable_occupation, index)

    updated_occupation =
      List.replace_at(selectable_occupation, index, %{current_occupation | selected: selected?})

    send(self(), {:updated_occupation, updated_occupation})

    {:noreply, socket}
  end

  defp filter_selected_occupation(occupation) do
    Enum.filter(occupation, fn occ -> occ.selected in [true, "true"] end)
  end
end
