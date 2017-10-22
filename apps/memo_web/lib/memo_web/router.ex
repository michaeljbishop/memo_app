defmodule MemoWeb.Router do
  use MemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MemoWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/entries_new", EntryController, :new
    resources "/entries", EntryController, except: [:new]
  end

  # Other scopes may use custom stacks.
  # scope "/api", MemoWeb do
  #   pipe_through :api
  # end
end
