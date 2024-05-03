defmodule ObjBaking.Repo.Migrations.AddConta do
  use Ecto.Migration

  def change do
    create table("conta") do
      add :saldo, :float, default: 0
      add :saldo_anterior, :float, default: 0
      timestamps()
    end
  end
end
