defmodule RmsWeb.DetailLive do
  use RmsWeb, :live_view

  alias Rms.Users.User
  alias Rms.Repo

  def mount(%{"id" => id}, _session, socket) do
    user = Repo.get(User, id)

    {:ok,
     socket
     |> assign(:user_id, id)
     |> assign(:user, user)
     |> assign(:changeset, User.changeset(user, %{}))}
  end

  def render(assigns) do
    ~H"""
    <h2><%= @user.name %></h2>
      <div class="relative">
        <.form let={f} for={@changeset} id="multiselect-form">
          <.live_component
            id="multi"
            module={RmsWeb.MultiSelectComponent}
            values={@user.occupation}
            user={@user}
            form={f}
            >
          </.live_component>
        </.form>
      </div>
    """
  end

  def handle_info({:update_occupations, selected_occupation_id}, %{assigns: %{user: user}} = socket) do

    user_occupations =
      user.occupation
      |> Enum.map(fn occ ->
        occupation_struct = Map.from_struct(occ)

        if occ.id == selected_occupation_id do
          occupation_struct
          |> Map.update!(:selected, fn _ -> !occupation_struct.selected end)
        else
          occupation_struct
        end
      end)

    user
    |> Ecto.Changeset.change(%{occupation: user_occupations})
    |> Rms.Repo.update()
    |> case do
      {:ok, user} ->
         socket
         |> assign(:user, user)
         |> assign(:changeset, User.changeset(user, %{}))

      _ ->
        socket
    end

    {:noreply, socket}
  end

end
