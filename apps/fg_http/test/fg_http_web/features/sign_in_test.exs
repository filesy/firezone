defmodule FgHttpWeb.Features.SignInTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  import Wallaby.Query,
    only: [
      text_field: 1,
      button: 1,
      css: 2
    ]

  alias FgHttp.Fixtures

  def create_user(_) do
    {:ok, user: Fixtures.user()}
  end

  setup [:create_user]

  @success_flash css(".notification .flash-info", count: 1, text: "Signed in successfully.")

  def sign_in(session) do
    session
    |> visit("/")
    |> fill_in(text_field("Email"), with: "test@test")
    |> fill_in(text_field("Password"), with: "test")
    |> click(button("Sign in"))
  end

  feature "users can sign in", %{session: session} do
    session
    |> sign_in()
    |> assert_has(@success_flash)
  end

  feature "dismisses alert", %{session: session} do
    session
    |> sign_in()
    |> click(button("Dismiss notification"))
    |> refute_has(@success_flash)
  end
end
