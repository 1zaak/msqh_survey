defmodule MsqhPortal.Router do
  use MsqhPortal.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MsqhPortal.Auth, repo: MsqhPortal.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin_layout do
    plug MsqhPortal.Notification, repo: MsqhPortal.Repo
    plug :put_layout, {MsqhPortal.LayoutView, :admin}
  end

  pipeline :user_layout do
    plug MsqhPortal.Notification, repo: MsqhPortal.Repo
    plug :put_layout, {MsqhPortal.LayoutView, :user}
  end

  pipeline :login_layout do
    plug :put_layout, {MsqhPortal.LayoutView, :login}
  end

  pipeline :register_layout do
    plug :put_layout, {MsqhPortal.LayoutView, :register}
  end

  scope "/", MsqhPortal do
    pipe_through [:browser, :login_layout]

    get "/", LoginController, :index
    get "/change", LoginController, :change
    post "/send_email", LoginController, :change_password
    get "/reset/:id", LoginController, :reset
    get "/admin", AdminLoginController, :index
    get "/admin/change", AdminLoginController, :change
  end

  scope "/register", MsqhPortal do
    pipe_through [:browser, :register_layout]

    get "/", UserController, :new
    get "/admin", AdminController, :new
    post "/admin", AdminController, :create
    post "/", UserController, :create
  end

  scope "/", MsqhPortal do
    pipe_through [:browser, :user_layout] # Use the default browser stack

    resources "/user_enquiries", UserEnquiryController
    get "/user_enquiries/reply/:id", UserEnquiryController, :reply
    post "/user_enquiries/reply", UserEnquiryController, :send_reply
    patch "/user_enquiries/:id", UserEnquiryController, :response
    put "/user_enquiries/:id", UserEnquiryController, :response

    resources "/payments", PaymentController
    resources "/memberships", MembershipController
    resources "/facilities", FacilityController
    resources "/dashboard", UserController, only: [:index]
    get "/profile", ProfileController, :index
    get "/profile/edit", ProfileController, :edit
    patch "/profile/:id", ProfileController, :update
    put "/profile/:id", ProfileController, :update
    get "/payment", UserPaymentController, :index
    resources "/membership", UserMembershipController, only: [:index, :new, :create]
    get "/membership/edit/:id", UserMembershipController, :edit
    patch "/membership/:id", UserMembershipController, :update
    put "/membership/:id", UserMembershipController, :update
    resources "/membership/payment", UserMembershipPaymentController, only: [:index, :new, :create, :show]
    get "/membership/payment/edit/:id", UserMembershipPaymentController, :edit
    patch "/membership/payment/:id", UserMembershipPaymentController, :update
    put "/membership/payment/:id", UserMembershipPaymentController, :update
    get "/help", HelpController, :index
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/activation/:confirm_id", ActivationController, :confirm
    get "/events", UserEventController, :index
    get "/vouchers", UserRebateController, :index
    get "/resources", UserResourceController, :index

  end

  scope "/admin", MsqhPortal do
    pipe_through [:browser, :admin_layout] # Use the default browser stack

    resources "/dashboard", AdminController, only: [:index, :new, :show, :delete, :update, :create]
    get "/dashboard/change/:id", AdminController, :change
    put "/dashboard/change_password/:id", AdminController, :change_password
    get "/dashboard/edit/:id", AdminController, :edit
    resources "/prices", DefaultPriceController
    resources "/notifications", AdminMembershipSettingController
    resources "/membership_type", MembershipTypeController
    resources "/membership_category", MembershipCategoryController
    resources "/payments", PaymentLogController
    post "/search", AdminController, :search
    get "/approve/:id", AdminController, :approve
    patch "/approve/:id", AdminController, :approve
    put "/approve/:id", AdminController, :approve
    put "/verify/payment", AdminController, :verify
    post "/verify/payment", AdminController, :verify
    resources "/facilities", AdminFacilityController, only: [:index, :new, :show, :delete, :update, :create]
    get "/facilities/edit/:id", AdminFacilityController, :edit
    get "/facilities/package/edit/:id", AdminFacilityController, :edit_package
    patch "/facilities/package/update/:id", AdminFacilityController, :update_package
    put "/facilities/package/update/:id", AdminFacilityController, :update_package
    get "/settings", AdminSettingController, :index
    put "/settings/expiration_notification", AdminSettingController, :edit_expiration_notification
    post "/settings/membership_type", AdminSettingController, :create_membership_type
    post "/settings/membership_category", AdminSettingController, :create_membership_category
    post "/settings/default_price", AdminSettingController, :create_default_price
    post "/settings/payment_type", AdminSettingController, :create_payment_type
    delete "/settings/admin/:id", AdminSettingController, :delete_admin
    patch "/settings/payment_type/:id", AdminSettingController, :update_payment_type
    put "/settings/payment_type/:id", AdminSettingController, :update_payment_type
    post "/settings/admin", AdminSettingController, :create_admin
    get "/rebates", AdminRebateController, :index
    resources "/events", AdminEventController, only: [:index, :new, :show, :delete, :update, :create]
    get "/events/edit/:id", AdminEventController, :edit
    post "/events/voucher/create", AdminEventController, :voucher_create
    resources "/manage/vouchers", VoucherController
    resources "/enquiries", AdminEnquiryController
    get "/enquiries/reply/:id", AdminEnquiryController, :reply
    post "/enquiries/reply", AdminEnquiryController, :send_reply
    resources "/manage/responses", EnquiryResponseController
    resources "/resources", AdminResourceController, only: [:index, :new, :show, :delete, :update, :create]
    get "/resources/edit/:id", AdminResourceController, :edit
    resources "/manage/resources/permissions", ResourcePermissionsController
    resources "/packages", PackageController, only: [:index, :new, :show, :delete, :update, :create]
    get "/packages/edit/:id", PackageController, :edit

    resources "/sessions", AdminSessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", MsqhPortal do
  #   pipe_through :api
  # end
end
