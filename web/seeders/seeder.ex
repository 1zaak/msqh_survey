defmodule MsqhPortal.UsersAndMembershipsSeeder do
  alias MsqhPortal.Repo
  alias MsqhPortal.User
  alias MsqhPortal.Membership
  alias MsqhPortal.PaymentLog

  @doc "Import given user into database"
  def import_from_csv(csv_path) do
    # IO.inspect csv_path
    Agent.start_link(fn -> %{users: %{}, memberships: [], phones: [], addresses: []} end, name: __MODULE__)
    File.stream!(Path.expand(csv_path))
    |> CSV.decode(separator: ?,, headers: true)
    |> Stream.each(fn row ->
      _process_csv_row(row)
    end)
    |> Stream.run
  end

  defp _process_csv_row(row) do
    # IO.puts "inside _process_csv_row"
    # IO.inspect row
    users = %{
      name: row["Name"],
      ic: row["NRIC"],
      email: unless (String.trim(row["Email"]) == "" ) do
        String.split(row["Email"], ["\n", "\r", ";", " "]) |> List.last
      else
        first = String.split(row["Name"]) |> List.first
        last =  String.split(row["Name"]) |> Enum.at(1)
        first <> "@" <> last <> ".com"
      end,
      professional_designation: row["Designation"],
      mailing_address: row["Mailing Address 1"],
      mailing_address_2: row["Mailing Address 2"],
      phone: row["Contact No"],
      state: "INACTIVE",
      username: row["Name"]
    }

    facilities = %{
      facility_name: row["Organisation"],
      sector: row["Sector"],
    }

    memberships = %{
      membership_category: row["Surveyor"],
      name: row["approved_when"],
      # membership_category?: row["Registration"],
      # membership_type?: row["Annual Subscription"],
    }

    _process_users(users)
    _get_processed(:users)
  end

  defp _process_users(user_params) do
    IO.puts "USER_PARAMS"
    IO.inspect user_params
    unless _get_processed(:users)[user_params[:name]] do
      user = case Repo.get_by(User, name: user_params[:name]) do
        nil        -> %User{} # Department not found, we build one
        user -> user    # Post exists, let's use it
      end
      |> User.seeder_changeset(user_params)
      |> Repo.insert_or_update!

      _add_processed(:users, user_params[:name], user.id)
    end
  end

  defp _get_processed(:users) do
    Agent.get(__MODULE__, fn %{users: users} ->
      users
    end)
  end

  defp _add_processed(:users, name, user_id) do
    Agent.update(__MODULE__, fn %{users: users} = processed ->
      %{processed | users: Map.put(users, name, user_id)}
    end)
  end

  # MsqhPortal.UsersAndMembershipsSeeder.import_from_csv("~/Downloads/MSQH_DB_2.csv")
end
