defmodule MsqhPortal.EnquiryResponseAttachment do
  use Arc.Definition

  # Include ecto support (requires package arc_ecto installed):
  use Arc.Ecto.Definition
  def __storage, do: Arc.Storage.Local
  @versions [:original]

  # To add a thumbnail version:
  @versions [:original]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.pdf .jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  # end

  # Override the persisted filenames:
  def filename(version, {file, scope}) do
    file.file_name
    |> Base.url_encode64
  end

  # Override the storage directory:
  def storage_dir(version, {file, scope}) do
    "priv/static/uploads/user/enquiry_response_attachment"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
