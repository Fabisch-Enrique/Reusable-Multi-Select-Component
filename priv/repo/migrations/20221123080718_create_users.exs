defmodule Rms.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :age, :integer
      add :aos, :string, null: false
      add :occupation, {:array, :map}, default: []

      timestamps()
    end
  end
end
