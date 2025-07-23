defmodule DemoAppWeb.RegistrationHTML do
  @moduledoc """
  This module contains pages rendered by RegistrationController.

  See the `registration_html` directory for all templates.
  """
  use DemoAppWeb, :html

  embed_templates "registration_html/*"
end