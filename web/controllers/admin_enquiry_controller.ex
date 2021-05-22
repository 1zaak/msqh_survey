defmodule MsqhPortal.AdminEnquiryController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.Enquiry
  alias MsqhPortal.EnquiryResponse
  alias Ecto.Multi

  def index(conn, params) do
    params_with_page_size = Enum.into(%{"page_size" => 3}, params)

    enquiries = Enquiry
    |> order_by(desc: :updated_at)
    |> preload([{:enquiry_responses, [:admin, :member]}, :member])
    |> Repo.paginate(params_with_page_size)

    render(conn, "index.html", enquiries: enquiries)
  end

  def reply(conn, %{"id" => id}) do
    user_enquiry = Repo.get!(Enquiry, id)
    |> Repo.preload([enquiry_responses: from(e in EnquiryResponse, order_by: [asc: e.updated_at])])
    |> Repo.preload([{:enquiry_responses, [:admin, :member]}, :member])

    changeset = EnquiryResponse.changeset(%EnquiryResponse{})

    render(conn, "reply.html", user_enquiry: user_enquiry, changeset: changeset)
  end

  def send_reply(conn, %{"enquiry_response" => user_enquiry_response_params}) do
    admin_enquiry_response_changeset = EnquiryResponse.admin_changeset(%EnquiryResponse{}, user_enquiry_response_params, conn.assigns.current_user.id, user_enquiry_response_params["member_id"])
    user_enquiry = Repo.get!(Enquiry, user_enquiry_response_params["enquiry_id"])
    admin_enquiry_changeset = Enquiry.admin_replied_changeset(user_enquiry)

    transaction = Multi.new
    |> Multi.insert(:admin_enquiry_response_changeset, admin_enquiry_response_changeset)
    |> Multi.update(:admin_enquiry_changeset, admin_enquiry_changeset)

    case Repo.transaction(transaction) do
      {:ok, %{admin_enquiry_response_changeset: admin_enquiry_response_changeset}} ->
        conn
        |> put_flash(:info, "Message sent.")
        |> redirect(to: admin_enquiry_path(conn, :reply, user_enquiry))
      {:error, %{admin_enquiry_response_changeset: admin_enquiry_response_changeset}} ->
        put_flash(conn, :info, "Error sending message.")
        render(conn, "reply.html", changeset: admin_enquiry_response_changeset, user_enquiry: user_enquiry)
      {:ok, %{admin_enquiry_changeset: admin_enquiry_changeset}} ->
        conn
        |> put_flash(:info, "Message sent.")
        |> redirect(to: admin_enquiry_path(conn, :reply, user_enquiry))
      {:error, %{admin_enquiry_changeset: admin_enquiry_changeset}} ->
        put_flash(conn, :info, "Error sending message.")
        render(conn, "reply.html", changeset: admin_enquiry_changeset, user_enquiry: user_enquiry)
    end
  end

  def create(conn, %{"enquiry_response" => enquiry_response_params}) do
    changeset = EnquiryResponse.changeset(%EnquiryResponse{}, enquiry_response_params)
    new_changeset = EnquiryResponse.changeset(%EnquiryResponse{})

    case Repo.insert(changeset) do
      {:ok, _enquiry_response} ->
        enquiry = Enquiry
        |> Repo.get!(enquiry_response_params["enquiry_id"])
        |> Repo.preload([:enquiry_responses])

        conn
        |> put_flash(:info, "Enquiry replied successfully.")
        |> render("show.html", enquiry: enquiry, changeset: new_changeset)
      {:error, changeset} ->
        enquiry = Repo.get!(Enquiry, enquiry_response_params["enquiry_id"])
        render(conn, "show.html", enquiry: enquiry, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    enquiry = Enquiry
    |> Repo.get!(id)
    |> Repo.preload([:enquiry_responses])

    changeset = EnquiryResponse.changeset(%EnquiryResponse{})
    render(conn, "show.html", enquiry: enquiry, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    enquiry = Repo.get!(Enquiry, id)
    changeset = Enquiry.changeset(enquiry)
    render(conn, "edit.html", enquiry: enquiry, changeset: changeset)
  end

  def delete(conn, %{"id" => id}) do
    enquiry = Repo.get!(Enquiry, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(enquiry)

    conn
    |> put_flash(:info, "Enquiry deleted successfully.")
    |> redirect(to: admin_enquiry_path(conn, :index))
  end
end
