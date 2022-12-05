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
      <div class="relative">
      <.form let={f} for={@changeset} id="multiselect-form">
        <.live_component
          id="multi"
          module={RmsWeb.MultiSelectComponent}
          occupation={@user.occupation}
          user={@user}
          form={f}

          >
        </.live_component>
      </.form>
      </div>
    """
  end

  # def handle updated_occupation({:updated_occupation, occupation}, socket) do

  # end
end
