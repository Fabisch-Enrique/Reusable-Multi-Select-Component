defmodule RmsWeb.MultiSelectComponent do
  use RmsWeb, :live_component

  alias Phoenix.LiveView.JS
  alias Rms.Users.User

  def update(params, socket) do
    %{user: user, id: id, occupation: occupation} = params

    {:ok,
     socket
     |> assign(:id, id)
     |> assign(:changeset, User.changeset(%User{}, %{}))
     |> assign(:user, user)
     |> assign(:selected_occupation, filter_selected_occupation(occupation))}
     |> IO.inspect()
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

  defp filter_selected_occupation(occupation) do
    Enum.filter(occupation, fn occ -> occ.selected == true or occ.selected == "true" end)
  end
end
