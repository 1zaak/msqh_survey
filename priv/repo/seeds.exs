# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MsqhPortal.Repo.insert!(%MsqhPortal.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Seeds.UsersAndMemberships do
  alias MsqhPortal.Repo
  alias MsqhPortal.User
  alias MsqhPortal.Membership
  alias MsqhPortal.PaymentLog

  @doc "Import given user into database"
  def import_from_csv(csv_path) do
    IO.inspect csv_path
    Agent.start_link(fn -> %{users: {}, memberships: []} end, name: __MODULE__)
    File.stream!(Path.expand(csv_path))
    |> CSV.decode(separator: ?,, headers: true)
    |> Stream.each(fn row ->
      _process_csv_row(row)
    end)
    |> Stream.run
  end

  defp _process_csv_row(row) do
    users = %{
      name: row["Name"],
      ic: row["NRIC"],
      email: row["Email"],
      professional_designation: row["Designation"],
      mailing_address: row["Mailing Address 1"],
      mailing_address_2: row["Mailing Address 2"],
      phone: row["Contact No"],
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
  end

  defp _process_users(users) do
    unless _get_processed(:users)[users[:name]] do
      # department = case Repo.get_by(Department, insee_code: department_params[:insee_code]) do
      #   nil        -> %Department{} # Department not found, we build one
      #   department -> department    # Post exists, let's use it
      # end
      # |> Department.changeset(department_params)
      # |> Repo.insert_or_update!
      # _add_processed(:departments, department_params[:name], department.id)
    end
  end

  defp _get_processed(:users) do
    Agent.get(__MODULE__, fn %{users: users} -> users end)
  end
end

Seeds.UsersAndMemberships.import_from_csv("./priv/repo/MSQH_DB_2017.csv")
