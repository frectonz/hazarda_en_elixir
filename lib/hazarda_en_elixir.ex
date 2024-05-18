defmodule Game do
  defstruct secret: nil, tries: 0

  def new do
    %Game{secret: :rand.uniform(100)}
  end
end

defmodule HazardaEnElixir do
  def play(game) do
    if game.tries === 0 do
      greeting()
    end

    input = get_input()

    if input == "q" do
      quit(game)
    else
      input =
        try do
          String.to_integer(input)
        rescue
          ArgumentError -> invalid_number(game)
        end

      cond do
        input > game.secret -> try_smaller(game)
        input < game.secret -> try_bigger(game)
        input === game.secret -> success(game)
      end
    end
  end

  def main(_) do
    Game.new() |> HazardaEnElixir.play()
  end

  defp greeting do
    (IO.ANSI.green() <>
       "Guess a number between 0 and 100 inclusive." <>
       IO.ANSI.reset())
    |> IO.puts()
  end

  defp get_input do
    (IO.ANSI.yellow() <>
       "Enter your guess (q to quit): " <>
       IO.ANSI.reset())
    |> IO.gets()
    |> String.trim()
  end

  defp invalid_number(game) do
    (IO.ANSI.red() <>
       "Please enter a valid number." <>
       IO.ANSI.reset())
    |> IO.puts()

    play(%{game | tries: game.tries + 1})
  end

  defp try_smaller(game) do
    (IO.ANSI.blue() <>
       "Try a smaller number." <>
       IO.ANSI.reset())
    |> IO.puts()

    play(%{game | tries: game.tries + 1})
  end

  defp try_bigger(game) do
    (IO.ANSI.blue() <>
       "Try a bigger number." <>
       IO.ANSI.reset())
    |> IO.puts()

    play(%{game | tries: game.tries + 1})
  end

  defp success(game) do
    (IO.ANSI.green() <>
       "You got it in #{game.tries} tries." <>
       IO.ANSI.reset())
    |> IO.puts()
  end

  defp quit(game) do
    (IO.ANSI.red() <>
       "You used #{game.tries} tries. The secret number was #{game.secret}" <>
       IO.ANSI.reset())
    |> IO.puts()
  end
end
