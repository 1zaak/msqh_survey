defmodule MsqhPortal.UserResourceController do
  use MsqhPortal.Web, :controller

  alias MsqhPortal.Resource

  def index(conn, params) do
    params_with_page_size = Enum.into(%{"page_size" => 12}, params)

    resources = Resource
    |> Resource.order_by_title
    |> Repo.paginate(params_with_page_size)

    render conn, :index, resources: resources
  end  
end
