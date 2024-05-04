defmodule ObjBaking.Repo.Migrations.AddConta do
  use Ecto.Migration

  def change do
    create table(:conta, primary_key: false) do
      add :conta_id, :integer, primary_key: true
      add :saldo, :float, default: 0
      timestamps()
    end

    create(unique_index(:conta, [:conta_id]))
  end
end
