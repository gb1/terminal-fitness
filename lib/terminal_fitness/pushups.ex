defmodule TerminalFitness.PushUps do

  def greeting do
    "Welcome to pushups\n\r" <>
    "=====================\n\r" <>
    "What week are you on?: "
  end

  def format_string(day_list) do
    days = day_list
    |> Enum.reduce("", fn(day, reps)->
      reps <> ", " <> Integer.to_string day
    end)

    "Do these pushups, resting 60s between each set: "
    <> days

  end

  def get_week(week, day) do
    case { week |> String.trim, day |> String.trim}  do
      {"1", "1"} ->
        [6, 6, 4, 4, 6]
      {"1", "2"} ->
        [6, 8, 6, 6, 7]
      {"1", "3"} ->
        [8, 10, 7, 7, 9]
      #week2
      {"2", "1"} ->
        [9, 11, 8, 8, 11]
      {"2", "2"} ->
        [10, 12, 9, 9, 13]
      {"2", "3"} ->
        [12, 13, 10, 10, 15]
      #week3
      {"3", "1"} ->
        [12, 17, 13, 13, 17]
      {"3", "2"} ->
        [14, 19, 14, 14, 19]
      {"3", "3"} ->
        [16, 21, 15, 15, 21]
      #week4
      {"4", "1"} ->
        [18, 22, 16, 16, 25]
      {"4", "2"} ->
        [20, 25, 20, 20, 28]
      {"4", "3"} ->
        [23, 28, 23, 23, 33]
      #week5
      {"5", "1"} ->
        [28, 35, 25, 25, 35]
      {"5", "2"} ->
        [18, 18, 20, 20, 14, 14, 16, 40]
      {"5", "3"} ->
        [18, 18, 20, 20, 17, 17, 20, 40]
      #week6
      {"6", "1"} ->
        [40, 50, 25, 25, 50]
      {"6", "2"} ->
        [20, 20, 23, 23, 20, 20, 18, 18, 53]
      {"6", "3"} ->
        [22, 22, 30, 30, 25, 25, 18, 18, 55]
      _->
        [9000, 9000, 9000, 9000, 9000]
    end
  end
end
