defmodule MsqhPortal.UserEnquiryController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.Enquiry
  alias MsqhPortal.EnquiryResponse

  def index(conn, params) do
    params_with_page_size = Enum.into(%{"page_size" => 3}, params)
    id = conn.assigns.current_user.id

    user_enquiries = Enquiry
    |> where([member_id: ^id])
    |> preload([{:enquiry_responses, [:admin, :member]}])
    |> order_by(desc: :updated_at)
    |> Repo.paginate(params_with_page_size)

    changeset = Enquiry.changeset(%Enquiry{})
    render(conn, "index.html", user_enquiries: user_enquiries, changeset: changeset)
  end

  def new(conn, _params) do
    changeset = Enquiry.changeset(%Enquiry{})
    render(conn, "new.html", changeset: changeset)
  end

  def reply(conn, %{"id" => id}) do
    user_enquiry = Repo.get!(Enquiry, id)
    |> Repo.preload([enquiry_responses: from(e in EnquiryResponse, order_by: [asc: e.updated_at])])
    |> Repo.preload([{:enquiry_responses, [:admin, :member]}, :member])

    from(p in EnquiryResponse, where: p.enquiry_id == ^id)
    |> Repo.update_all(set: [user_read: true])

    changeset = EnquiryResponse.changeset(%EnquiryResponse{})

    render(conn, "reply.html", user_enquiry: user_enquiry, changeset: changeset)
  end

  def send_reply(conn, %{"enquiry_response" => user_enquiry_response_params}) do
    changeset = EnquiryResponse.member_changeset(%EnquiryResponse{}, user_enquiry_response_params, conn.assigns.current_user.id)

    user_enquiry = Repo.get!(Enquiry, user_enquiry_response_params["enquiry_id"])

    case Repo.insert(changeset) do
      {:ok, _enquiry_response} ->
        conn
        |> put_flash(:info, "Message sent.")
        |> redirect(to: user_enquiry_path(conn, :reply, user_enquiry))
      {:error, changeset} ->
        put_flash(conn, :info, "Error sending message.")
        render(conn, "reply.html", changeset: changeset, user_enquiry: user_enquiry)
    end
  end

  def create(conn, %{"enquiry" => user_enquiry_params}) do
    id = conn.assigns.current_user.id
    user_enquiry_params_with_member_id = Enum.into(%{"member_id" => id}, user_enquiry_params)
    changeset = Enquiry.changeset(%Enquiry{}, user_enquiry_params_with_member_id)

    user_enquiries = Repo.all from m in Enquiry,
    where: m.member_id == ^id,
    preload: [{:enquiry_responses, [:admin, :member]}],
    order_by: [asc: m.updated_at]

    case Repo.insert(changeset) do
      {:ok, _user_enquiry} ->
        conn
        |> put_flash(:info, "Message sent.")
        |> redirect(to: user_enquiry_path(conn, :index, user_enquiries))
      {:error, changeset} ->
        put_flash(conn, :info, "Error sending message.")
        render(conn, "index.html", changeset: changeset, user_enquiries: user_enquiries)
    end
  end

  def response(conn, %{"enquiry" => user_enquiry_params}) do
    IO.puts "IN RESPONSE"

    id = conn.assigns.current_user.id
    user_enquiry_params_with_member_id = Enum.into(%{"member_id" => id}, user_enquiry_params)
    changeset = Enquiry.changeset(%Enquiry{}, user_enquiry_params_with_member_id)

    user_enquiries = Repo.all from m in Enquiry,
    where: m.member_id == ^id,
    preload: [{:enquiry_responses, [:admin, :member]}],
    order_by: [asc: m.updated_at]

    case Repo.insert(changeset) do
      {:ok, _user_enquiry} ->
        conn
        |> put_flash(:info, "Message sent.")
        |> redirect(to: user_enquiry_path(conn, :index, user_enquiries))
      {:error, changeset} ->
        put_flash(conn, :info, "Error sending message.")
        render(conn, "index.html", changeset: changeset, user_enquiries: user_enquiries)
    end
  end


  def show(conn, %{"id" => id}) do
    user_enquiry = Repo.get!(Enquiry, id)
    render(conn, "show.html", user_enquiry: user_enquiry)
  end

  def edit(conn, %{"id" => id}) do
    user_enquiry = Repo.get!(Enquiry, id)
    id = conn.assigns.current_user.id
    IO.inspect user_enquiry
    changeset = EnquiryResponse.member_changeset(%EnquiryResponse{}, %{"enquiry_id" => user_enquiry.id}, id)

    user_enquiries = Repo.all from m in Enquiry,
    where: m.member_id == ^id,
    preload: [{:enquiry_responses, [:admin, :member]}],
    order_by: [asc: m.updated_at]

    render(conn, "edit.html", user_enquiry: user_enquiry, user_enquiries: user_enquiries, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user_enquiry" => user_enquiry_params}) do
    user_enquiry = Repo.get!(Enquiry, id)
    changeset = Enquiry.changeset(user_enquiry, user_enquiry_params)

    case Repo.update(changeset) do
      {:ok, user_enquiry} ->
        conn
        |> put_flash(:info, "User enquiry updated successfully.")
        |> redirect(to: user_enquiry_path(conn, :show, user_enquiry))
      {:error, changeset} ->
        render(conn, "edit.html", user_enquiry: user_enquiry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_enquiry = Repo.get!(Enquiry, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user_enquiry)

    conn
    |> put_flash(:info, "User enquiry deleted successfully.")
    |> redirect(to: user_enquiry_path(conn, :index))
  end
end
