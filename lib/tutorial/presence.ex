defmodule Tutorial.Presence do
  use Phoenix.Presence, otp_app: :tutorial, pubsub_server: Tutorial.PubSub
end
