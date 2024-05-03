defmodule ObjBaking.Repo do
  use Ecto.Repo,
    otp_app: :obj_baking,
    adapter: Ecto.Adapters.Postgres
end
