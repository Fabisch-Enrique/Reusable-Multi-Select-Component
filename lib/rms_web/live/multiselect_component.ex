defmodule RmsWeb.MultiSelectComponent do
  use RmsWeb, :live_component

  def update(params, socket) do
    %{user: user} = params

    IO.inspect(user)

    {:ok, assign(socket, :user, user)}
  end

  def handle_event(
        "update_selected",
        %{"occupation-id" => occupation_id},
        %{assigns: %{user: user}} = socket
      ) do
    user_occupations =
      user.occupation
      |> Enum.map(fn occ ->
        occupation_struct = Map.from_struct(occ)

        if occ.id == occupation_id do
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
        {:noreply, socket |> assign(:user, user)}

      _ ->
        {:noreply, socket}
    end
  end
end
