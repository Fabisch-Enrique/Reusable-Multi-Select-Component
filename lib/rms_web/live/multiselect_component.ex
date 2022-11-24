defmodule RmsWeb.Live.MultiSelectComponent do
  use RmsWeb, :live_component

  # alias Rms.Multisect

  def render(assigns) do
    ~H"""
    <div class="multiselect">
      <div class="fake_select_tag"
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
      <div id={"#{@id}"}-occupation-container>
        <%= inputs_for @form, :occupation, fn occ -> %>
          <div class="form-check">
            <div class="selectable-occupation">
              <%= checkbox occ, :title, occ.data.title phx_change: "checked", phx_target: {@myself} %>
              <%= checkbox occ, :title, occ: occ.data.title %>
              <%= label occ, :fos, occ.data.fos %>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def update(%{occupation: occupation, form: form, id: id} = assigns, socket) do
    {:ok,
     socket
     |> assign(:id, id)
     |> assign(:selectable_occupation, occupation)
     |> assign(:form, form)
     |> assign(:selected_occupation, filter_selected_occupation(occupation))}
  end

  def handle_event("checked", %{"multi_select" => %{"occupation" => occ}}, socket) do

    [{index, %{"title" => title?}}] = Map.to_list(occ)

    index =String.to_integer(index)

    current_occupation = Enum.at(socket.assigns.occupation, index)

    updated_occupation = List.replace_at(socket.assigns.occupation, index, %{current_occupation | title: title?})

    socket.assigns.selected.(updated_occupation)

    {:noreply, socket}
  end

  defp filter_selected_occupation(occupations) do
    Enum.filter(occupations, fn occ -> occ.selected in [true, "true"] end )
  end
end
