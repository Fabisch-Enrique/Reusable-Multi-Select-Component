defmodule Rms.Repo do
  use Ecto.Repo,
    otp_app: :rms,
    adapter: Ecto.Adapters.Postgres
end
