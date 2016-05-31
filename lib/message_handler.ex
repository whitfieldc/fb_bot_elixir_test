defmodule Fbtestapp.MessageHandler do
  require Logger

  @fb_page_access_token System.get_env("FB_PAGE_ACCESS_TOKEN") 

  def handle(msg = %{message: %{text: _text}}) do
    buttons = [
      %{type: "postback", title: "Your name", payload: "PB_NAME"},
      %{type: "web_url", title: "Your website", url: "https://https://playoverwatch.com/en-us/heroes/bastion/"}
    ]

    send_button_message(msg.sender.id, "Choose from the following options", buttons)
  end
  
  def handle(msg) do
    Logger.info "Unhandled message:\n#{inspect msg}"
  end

  defp send_button_message(recipient, text, buttons) do
    payload = %{
      recipient: %{id: recipient},

      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "button",
            text: text,
            buttons: buttons
          }
        }
      }
    }

    url = "https://graph.facebook.com/v2.6/me/messages?access_token=#{@fb_page_access_token}"
    headers = [{"Content-Type", "application/json"}]
    Logger.info "Posting reply:\n#{inspect payload}"
    HTTPoison.post!(url, Poison.encode!(payload), headers)
  end
end
