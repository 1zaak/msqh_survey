defmodule MsqhPortal.EnquiryResponseController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.EnquiryResponse

  def index(conn, _params) do
    enquiry_responses = Repo.all(EnquiryResponse)
    render(conn, "index.html", enquiry_responses: enquiry_responses)
  end

  def new(conn, _params) do
    changeset = EnquiryResponse.changeset(%EnquiryResponse{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"enquiry_response" => enquiry_response_params}) do
    changeset = EnquiryResponse.changeset(%EnquiryResponse{}, enquiry_response_params)

    case Repo.insert(changeset) do
      {:ok, _enquiry_response} ->
        conn
        |> put_flash(:info, "Enquiry response created successfully.")
        |> redirect(to: enquiry_response_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    enquiry_response = Repo.get!(EnquiryResponse, id)
    render(conn, "show.html", enquiry_response: enquiry_response)
  end

  def edit(conn, %{"id" => id}) do
    enquiry_response = Repo.get!(EnquiryResponse, id)
    changeset = EnquiryResponse.changeset(enquiry_response)
    render(conn, "edit.html", enquiry_response: enquiry_response, changeset: changeset)
  end

  def update(conn, %{"id" => id, "enquiry_response" => enquiry_response_params}) do
    enquiry_response = Repo.get!(EnquiryResponse, id)
    changeset = EnquiryResponse.changeset(enquiry_response, enquiry_response_params)

    case Repo.update(changeset) do
      {:ok, enquiry_response} ->
        conn
        |> put_flash(:info, "Enquiry response updated successfully.")
        |> redirect(to: enquiry_response_path(conn, :show, enquiry_response))
      {:error, changeset} ->
        render(conn, "edit.html", enquiry_response: enquiry_response, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    enquiry_response = Repo.get!(EnquiryResponse, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(enquiry_response)

    conn
    |> put_flash(:info, "Enquiry response deleted successfully.")
    |> redirect(to: enquiry_response_path(conn, :index))
  end
end
