defmodule RmsWeb.DetailLive do
  use RmsWeb, :live_view

  alias Rms.Users.User
  alias Rms.Repo

  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:user_id, id)
     |> assign(:user, Repo.get(User, id))}
  end

  def render(assigns) do
    ~H"""
    <h1><%= @user.name%></h1>
    <.live_component
      id="multi-select"
      module={RmsWeb.MultiSelectComponent}
      user={@user}
      >
    </.live_component>
    """
  end
end
