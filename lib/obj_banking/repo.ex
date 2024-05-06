defmodule ObjBanking.Repo do
  use Ecto.Repo,
    otp_app: :obj_banking,
    adapter: Ecto.Adapters.Postgres
end
