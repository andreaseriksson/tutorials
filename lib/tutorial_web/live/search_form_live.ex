defmodule TutorialWeb.SearchFormLive do
  use Phoenix.LiveView

  def mount(%{}, socket) do
    assigns = [
      conn: socket,
      search_results: [],
      search_phrase: "",
      current_focus: -1
    ]

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    TutorialWeb.PageView.render("search_form.html", assigns)
  end

  def handle_event("search", %{"search_phrase" => search_phrase}, socket) do
    assigns = [
      search_results: search(search_phrase),
      search_phrase: search_phrase
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("pick", %{"name" => search_phrase}, socket) do
    assigns = [
      search_results: [],
      search_phrase: search_phrase
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("submit", _, socket), do: {:noreply, socket} # PREVENT FORM SUBMIT

  def handle_event("set-focus", %{"keyCode" => 38}, socket) do # UP
    current_focus =
      Enum.max([(socket.assigns.current_focus - 1), 0])
    {:noreply, assign(socket, current_focus: current_focus)}
  end

  def handle_event("set-focus", %{"keyCode" => 40}, socket) do # DOWN
    current_focus =
      Enum.min([(socket.assigns.current_focus + 1), (length(socket.assigns.search_results)-1)])
    {:noreply, assign(socket, current_focus: current_focus)}
  end

  def handle_event("set-focus", %{"keyCode" => 13}, socket) do # ENTER
    case Enum.at(socket.assigns.search_results, socket.assigns.current_focus) do
      "" <> search_phrase -> handle_event("pick", %{"name" => search_phrase}, socket)
      _ -> {:noreply, socket}
    end
  end

  # FALLBACK FOR NON RELATED KEY STROKES
  def handle_event("set-focus", _, socket), do: {:noreply, socket}

  def search(""), do: []
  def search(search_phrase) do
    states()
    |> Enum.filter(& matches?(&1, search_phrase))
  end

  def matches?(first, second) do
    String.starts_with?(
      String.downcase(first), String.downcase(second)
    )
  end

  def states do
    [
      "Alabama", "Alaska", "Arizona", "Arkansas", "California",
      "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii",
      "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
      "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
      "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
      "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota",
      "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island",
      "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont",
      "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
    ]
  end
end
